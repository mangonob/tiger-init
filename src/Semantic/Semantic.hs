module Semantic.Semantic
  ( Exp (..),
    ExpTy (..),
    transExpr,
    translate,
    translate',
  )
where

import AbSyn
import Control.Applicative
import Control.Monad (when)
import Data.Function (on)
import Data.Functor ((<&>))
import Data.List
import Lexer (AlexPosn, runAlex)
import Parser (parser)
import Semantic.Env
import Semantic.STable (STable)
import Semantic.Sem
import qualified Semantic.Types as T
import Symbol (Sym)

data Exp = Exp deriving (Show)

data ExpTy = ExpTy {exp :: Maybe Exp, expType :: T.Type} deriving (Show)

checkType :: T.Type -> T.Type -> AlexPosn -> Sem Bool
checkType t1 t2 p = do
  actualTy1 <- actualType t1 p
  actualTy2 <- actualType t2 p
  compatible actualTy1 actualTy2
  where
    compatible (T.RecordType _) T.NilType = return True
    compatible T.NilType (T.RecordType _) = return True
    compatible t1 t2
      | t1 == t2 = return True
      | otherwise = semError $ "type \"" ++ show t2 ++ "\" is not match with \"" ++ show t1 ++ "\" at position " ++ show p

--- Find actual Type of symbol
findTypeAt :: Sym -> AlexPosn -> Sem T.Type
findTypeAt name pos = do
  maybeEntry <- findType name
  case maybeEntry of
    Just ty -> actualType ty pos
    _ -> semError $ "undefiend type " ++ name ++ " at position " ++ show pos

transExpr :: Expr -> Sem ExpTy
transExpr (VarExpr v) = transVar v
transExpr (NilExpr _) = return $ ExpTy Nothing T.NilType
transExpr (SeqExpr exprs _) =
  if null exprs
    then return $ ExpTy Nothing T.Void
    else do
      expTys <- mapM transExpr exprs
      return $ last expTys
transExpr (IntExpr _ _) = return $ ExpTy Nothing T.IntType
transExpr (StringExpr _ _) = return $ ExpTy Nothing T.StringType
transExpr (UMinus exp p) = do
  ExpTy _ v_ty <- transExpr exp
  case v_ty of
    T.IntType -> return $ ExpTy Nothing v_ty
    _ -> semError $ "\"-\" can not apply on " ++ show v_ty ++ " type at position " ++ show p
transExpr (Call funcName args p) = do
  maybeEntry <- findVar funcName
  case maybeEntry of
    Just (FuncEntry farmals returnTy) -> do
      argTys <- mapM (fmap expType . transExpr) args
      case (compare `on` length) argTys farmals of
        LT -> do
          let ty = farmals !! max 0 (length argTys)
          semError $ "excepted " ++ show ty ++ " type arugment at position " ++ show p
        GT -> do
          let ty = argTys !! max 0 (length farmals)
          let arg = args !! max 0 (length farmals)
          semError $ "unexcepted " ++ show ty ++ " type argument at position " ++ show (posn arg)
        EQ -> sequence_ $ checkType <$> ZipList farmals <*> ZipList argTys <*> ZipList (fmap posn args)
      -- return $ ExpTy Nothing returnTy
      if funcName == "debugger"
        then debugger
        else return $ ExpTy Nothing returnTy
    _ -> semError $ "undefined function " ++ funcName ++ " at position " ++ show p
transExpr (OpExpr e1 op e2 p) = do
  ExpTy _ t1 <- transExpr e1
  ExpTy _ t2 <- transExpr e2
  case op of
    PlusOp ->
      if t1 == T.IntType && t2 == T.IntType
        then return $ ExpTy Nothing T.IntType
        else semError "\"+\" operator only work with both int type"
    MinusOp ->
      if t1 == T.IntType && t2 == T.IntType
        then return $ ExpTy Nothing T.IntType
        else semError "\"-\" operator only work with both int type"
    TimesOp ->
      if t1 == T.IntType && t2 == T.IntType
        then return $ ExpTy Nothing T.IntType
        else semError "\"*\" operator only work with both int type"
    DivideOp ->
      if t1 == T.IntType && t2 == T.IntType
        then return $ ExpTy Nothing T.IntType
        else semError "\"/\" operator only work with both int type"
    EqOp -> do
      checkEquality t1 t2
      return $ ExpTy Nothing T.IntType
    NeqOp -> do
      checkEquality t1 t2
      return $ ExpTy Nothing T.IntType
    LtOp ->
      if comparable t1 t2
        then return $ ExpTy Nothing T.IntType
        else canNotCompareError t1 t2
    LeOp ->
      if comparable t1 t2
        then return $ ExpTy Nothing T.IntType
        else canNotCompareError t1 t2
    GtOp ->
      if comparable t1 t2
        then return $ ExpTy Nothing T.IntType
        else canNotCompareError t1 t2
    GeOp ->
      if comparable t1 t2
        then return $ ExpTy Nothing T.IntType
        else canNotCompareError t1 t2
  where
    comparable T.IntType T.IntType = True
    comparable T.StringType T.StringType = True
    comparable _ _ = False

    checkEquality :: T.Type -> T.Type -> Sem ()
    checkEquality T.IntType T.IntType = return ()
    checkEquality T.StringType T.StringType = return ()
    checkEquality (T.RecordType _) T.NilType = return ()
    checkEquality T.NilType (T.RecordType _) = return ()
    checkEquality t1 t2
      | T.isArray t1 && t1 == t2 = return ()
      | T.isRecord t1 && t1 == t2 = return ()
      | otherwise =
          semError $
            "can not compare equality with \"" ++ show t1 ++ "\" and \"" ++ show t2 ++ "\" at position " ++ show p

    canNotCompareError t1 t2 = semError $ "can not compare " ++ show t1 ++ " with " ++ show t2 ++ " at position " ++ show p
transExpr (RecordsExpr name fields p) = do
  maybeType <- findActualType name p
  case maybeType of
    Just rcdTy@(T.RecordType records) -> do
      mapM_
        ( \(Field fieldName value fieldPos) -> do
            case lookup fieldName records of
              Just ty -> do
                ExpTy _ fieldTy <- transExpr value
                checkType ty fieldTy p
              Nothing -> semError $ "unexcepted field " ++ fieldName ++ " at position " ++ show fieldPos
        )
        fields
      mapM_
        ( \(recordName, recordTy) -> do
            fieldTy <- case find ((== recordName) . field_name) fields of
              Just (Field fieldName value fieldPos) -> do
                ExpTy _ ty <- transExpr value
                return ty
              Nothing -> case recordTy of
                T.RecordType _ -> return T.NilType
                _ -> semError $ "field \"" ++ recordName ++ "\" not found in record type \"" ++ name ++ "\" at position " ++ show p
            checkType recordTy fieldTy p
        )
        records
      checkFieldsDuplication fields
      return $ ExpTy Nothing rcdTy
    _ -> semError $ "undefined record type " ++ name ++ " at position " ++ show p
  where
    checkFieldsDuplication :: [Field] -> Sem ()
    checkFieldsDuplication [] = return ()
    checkFieldsDuplication xs =
      let ys = init xs
          y = last xs
          equality = ((==) `on` field_name) y
       in do
            checkFieldsDuplication ys
            when (any equality ys) $ semError $ "duplicate field " ++ field_name y ++ " at position " ++ show (field_pos y)
transExpr (ArrayExpr name size element p) = do
  entry <- findType name
  case entry of
    Just arrayType@(T.ArrayType elementTy) -> do
      ExpTy _ sizeTy <- transExpr size
      checkType T.IntType sizeTy (posn size)
      ExpTy _ elementTy' <- transExpr element
      checkType elementTy elementTy' (posn element)
      return $ ExpTy Nothing arrayType
    _ -> semError $ "undefiend array type " ++ name
transExpr (AssignExpr lvalue v p) = do
  ExpTy _ lvalueTy <- transVar lvalue
  ExpTy _ vType <- transExpr v
  checkType lvalueTy vType (posn v)
  return $ ExpTy Nothing T.Void
transExpr (IFExpr pred succ Nothing p) = do
  ExpTy _ pTy <- transExpr pred
  checkType T.IntType pTy (posn pred)
  ExpTy _ sTy <- transExpr succ
  checkType T.Void sTy (posn succ)
  return $ ExpTy Nothing T.Void
transExpr (IFExpr pred succ (Just fail) p) = do
  ExpTy _ pTy <- transExpr pred
  checkType T.IntType pTy (posn pred)
  ExpTy _ sTy <- transExpr succ
  ExpTy _ fTy <- transExpr fail
  checkType fTy sTy p
  return $ ExpTy Nothing sTy
transExpr (WhileExpr pred body p) = do
  ExpTy _ p_ty <- transExpr pred
  checkType T.IntType p_ty (posn pred)
  transExpr body
transExpr (ForExpr v_name from to body _ p) = do
  ExpTy _ fromType <- transExpr from
  ExpTy _ toType <- transExpr to
  checkType T.IntType fromType (posn from)
  checkType T.IntType toType (posn to)
  scopeBegin
  insertVar v_name (VarEntry T.IntType)
  ExpTy _ bodyTy <- transExpr body
  scopeEnd
  return $ ExpTy Nothing bodyTy
transExpr (BreakExpr p) = return $ ExpTy Nothing T.Void
transExpr (LetExpr decs body p) = do
  scopeBegin
  mapM_ transDecFirstPass decs
  mapM_ transDec decs
  ExpTy _ bodyTy <- transExpr body
  scopeEnd
  return $ ExpTy Nothing bodyTy
  where
    transDecFirstPass :: Dec -> Sem ()
    transDecFirstPass dec = case dec of
      TypeDec alias (SimpleType name p) _ ->
        insertType alias $ T.NamedType name Nothing
      FuncDec name parameters Nothing body p ->
        insertVar name $ FuncEntry (fmap recordNamedType parameters) T.Void
      FuncDec name parameters (Just returnTypeName) body p ->
        insertVar name $ FuncEntry (fmap recordNamedType parameters) (T.NamedType returnTypeName Nothing)
      _ -> return ()
      where
        recordNamedType r = T.NamedType (record_type r) Nothing

transVar :: Var -> Sem ExpTy
transVar (SimpleVar s p) = do
  v <- findVar s
  case v of
    Just (VarEntry ty) -> return $ ExpTy Nothing ty
    _ -> semError $ "undefined variable " ++ s ++ " at position " ++ show p
transVar (FieldVar v s p) = do
  ExpTy _ ty <- transVar v
  case ty of
    t@(T.RecordType records) -> case lookup s records of
      Nothing -> semError $ "can not access field \"" ++ s ++ "\" of type " ++ show t ++ " at position " ++ show p
      Just t -> return $ ExpTy Nothing t
    t -> semError $ "can not access field \"" ++ s ++ "\" of type " ++ show t ++ " at position " ++ show p
transVar (IndexedVar v exp p) = do
  ExpTy _ i_ty <- transExpr exp
  checkType T.IntType i_ty (posn exp)
  ExpTy _ v_ty <- transVar v
  case v_ty of
    T.ArrayType e_ty -> return $ ExpTy Nothing e_ty
    _ -> semError $ "indexed is not a type of array at position " ++ show p

actualType :: T.Type -> AlexPosn -> Sem T.Type
actualType (T.NamedType name Nothing) p = do
  maybeTy <- findType name
  case maybeTy of
    Just ty -> actualType' ty p
    _ -> semError $ "undefined type " ++ name ++ " at position " ++ show p
  where
    actualType' (T.NamedType name' Nothing) p
      | name' == name = semError $ "unresolved type because loop define of type " ++ name ++ " at position " ++ show p
      | otherwise = do
          maybeTy <- findType name'
          case maybeTy of
            Just ty -> actualType' ty p
            _ -> semError $ "undefined type " ++ name ++ " at position " ++ show p
    actualType' (T.ArrayType ty) p = actualType' ty p <&> T.ArrayType
    actualType' t _ = return t
actualType (T.NamedType name (Just ty)) p = actualType ty p
actualType (T.ArrayType ty) p = actualType ty p <&> T.ArrayType
actualType t _ = return t

transDec :: Dec -> Sem ExpTy
transDec (TypeDec name ty p) = do
  ExpTy _ ty' <- transType ty
  insertType name ty'
  return $ ExpTy Nothing T.Void
transDec (VarDec name initial Nothing _ p) = do
  ExpTy _ initialTy <- transExpr initial
  insertVar name (VarEntry initialTy)
  return $ ExpTy Nothing T.Void
transDec (VarDec name initial (Just typeName) _ p) = do
  maybeEntry <- findType typeName
  case maybeEntry of
    Just ty -> do
      ExpTy _ initialTy <- transExpr initial
      checkType initialTy ty (posn initial)
      insertVar name $ VarEntry ty
      return $ ExpTy Nothing T.Void
    _ -> semError $ "undefined type " ++ typeName ++ " at position " ++ show p
transDec (FuncDec name parameters Nothing body p) = do
  formals <- mapM (\r -> findTypeAt (record_type r) p) parameters
  insertVar name $ FuncEntry formals T.Void
  scopeBegin
  mapM_ transRecord parameters
  ExpTy _ bodyTy <- transExpr body
  scopeEnd
  return $ ExpTy Nothing T.Void
transDec (FuncDec name parameters (Just returnTypeName) body p) = do
  formals <- mapM (\r -> findTypeAt (record_type r) p) parameters
  returnTy <- findTypeAt returnTypeName p
  insertVar name $ FuncEntry formals returnTy
  scopeBegin
  mapM_ transRecord parameters
  ExpTy _ bodyTy <- transExpr body
  checkType returnTy bodyTy p
  scopeEnd
  return $ ExpTy Nothing T.Void

transRecord :: Record -> Sem T.Type
transRecord (Record name typeName _ p) = do
  ty <- findTypeAt typeName p
  insertVar name (VarEntry ty)
  return ty

transType :: Type -> Sem ExpTy
transType (SimpleType name p) = do
  maybeTy <- findType name
  case maybeTy of
    Just ty -> return $ ExpTy Nothing ty
    Nothing -> semError $ "undefined type " ++ name ++ " at position " ++ show p
transType (Records records p) = do
  checkRecordsDuplication records
  rcds <- mapM transRecord records
  return $ ExpTy Nothing (T.RecordType rcds)
  where
    transRecord :: Record -> Sem (Sym, T.Type)
    transRecord (Record name typeName _ p) = do
      maybeTy <- findType typeName
      case maybeTy of
        Just ty -> return (name, ty)
        Nothing -> semError $ "undefined type " ++ typeName ++ " at position " ++ show p

    checkRecordsDuplication :: [Record] -> Sem ()
    checkRecordsDuplication [] = return ()
    checkRecordsDuplication xs =
      let ys = init xs
          y = last xs
          equality = ((==) `on` record_name) y
       in do
            checkRecordsDuplication ys
            when (any equality ys) $ semError $ "duplicate record " ++ record_name y ++ " at position " ++ show (record_pos y)
transType (Array elemName p) = do
  maybeTy <- findType elemName
  case maybeTy of
    Just ty -> return $ ExpTy Nothing (T.ArrayType ty)
    Nothing -> semError $ "undefined type " ++ elemName ++ " at position " ++ show p

findActualType :: Sym -> AlexPosn -> Sem (Maybe T.Type)
findActualType name p = do
  maybeType <- findType name
  case maybeType of
    Nothing -> return Nothing
    Just ty -> Just <$> actualType ty p

translate :: Expr -> ExpTy
translate expr = case runSem (transExpr expr) baseEnv of
  Left msg -> error msg
  Right (e, ty) -> ty

translate' :: Expr -> Either String ExpTy
translate' expr = snd <$> runSem (transExpr expr) baseEnv

debugger :: Sem a
debugger = get >>= semError . show