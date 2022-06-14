{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
module Simple.Parser where

import Control.Monad (liftM2, (>>=))
import Control.Monad.State (State, put, get)
import Simple.AbSyn
import Simple.Token (intValue, doubleValue, pos)
import Simple.Lexer (Alex, AlexPosn, alexMonadScan, alexError)
import qualified Simple.Token as T
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

data HappyAbsSyn 
	= HappyTerminal (T.Token AlexPosn)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 ([Expr])
	| HappyAbsSyn6 (Expr)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Happy_GHC_Exts.Int# 
	-> (T.Token AlexPosn)
	-> HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> m HappyAbsSyn)
	-> [HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32 :: () => Happy_GHC_Exts.Int# -> ({-HappyReduction (Alex) = -}
	   Happy_GHC_Exts.Int# 
	-> (T.Token AlexPosn)
	-> HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16 :: () => ({-HappyReduction (Alex) = -}
	   Happy_GHC_Exts.Int# 
	-> (T.Token AlexPosn)
	-> HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (T.Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

happyExpList :: HappyAddr
happyExpList = HappyA# "\xc0\x5c\x02\x00\x00\x00\x00\x00\x00\x00\x40\x00\xe0\x01\x00\x01\x00\xcc\x25\x00\x00\x00\x00\x00\x00\x00\x00\x00\xcc\x25\x00\x73\x09\x00\xe0\x05\x00\x00\x00\x10\x1e\x00\x00\x20\xc0\x5c\x02\x30\x97\x00\xcc\x25\x00\x73\x09\xc0\x5c\x02\x00\x78\x00\x00\x00\x00\x00\x00\x00\x80\x01\x00\x60\x00\xcc\x25\x00\x73\x09\x00\x00\x00\x80\x78\x00\x00\x1e\x00\x73\x09\x00\xe0\x01\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parse","Prog","Seq","Expr","let","if","then","else","id","integer","double","'+'","'-'","'*'","'/'","'('","')'","'='","';'","%eof"]
        bit_start = st Prelude.* 22
        bit_end = (st Prelude.+ 1) Prelude.* 22
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..21]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (7#) = happyShift action_5
action_0 (8#) = happyShift action_6
action_0 (11#) = happyShift action_7
action_0 (12#) = happyShift action_8
action_0 (13#) = happyShift action_9
action_0 (15#) = happyShift action_10
action_0 (18#) = happyShift action_11
action_0 (4#) = happyGoto action_2
action_0 (5#) = happyGoto action_3
action_0 (6#) = happyGoto action_4
action_0 x = happyTcHack x happyReduce_1

action_1 x = happyTcHack x happyFail (happyExpListPerState 1)

action_2 (22#) = happyAccept
action_2 x = happyTcHack x happyFail (happyExpListPerState 2)

action_3 (21#) = happyShift action_20
action_3 x = happyTcHack x happyReduce_2

action_4 (14#) = happyShift action_16
action_4 (15#) = happyShift action_17
action_4 (16#) = happyShift action_18
action_4 (17#) = happyShift action_19
action_4 x = happyTcHack x happyReduce_3

action_5 (11#) = happyShift action_15
action_5 x = happyTcHack x happyFail (happyExpListPerState 5)

action_6 (7#) = happyShift action_5
action_6 (8#) = happyShift action_6
action_6 (11#) = happyShift action_7
action_6 (12#) = happyShift action_8
action_6 (13#) = happyShift action_9
action_6 (15#) = happyShift action_10
action_6 (18#) = happyShift action_11
action_6 (6#) = happyGoto action_14
action_6 x = happyTcHack x happyFail (happyExpListPerState 6)

action_7 x = happyTcHack x happyReduce_9

action_8 x = happyTcHack x happyReduce_10

action_9 x = happyTcHack x happyReduce_11

action_10 (7#) = happyShift action_5
action_10 (8#) = happyShift action_6
action_10 (11#) = happyShift action_7
action_10 (12#) = happyShift action_8
action_10 (13#) = happyShift action_9
action_10 (15#) = happyShift action_10
action_10 (18#) = happyShift action_11
action_10 (6#) = happyGoto action_13
action_10 x = happyTcHack x happyFail (happyExpListPerState 10)

action_11 (7#) = happyShift action_5
action_11 (8#) = happyShift action_6
action_11 (11#) = happyShift action_7
action_11 (12#) = happyShift action_8
action_11 (13#) = happyShift action_9
action_11 (15#) = happyShift action_10
action_11 (18#) = happyShift action_11
action_11 (6#) = happyGoto action_12
action_11 x = happyTcHack x happyFail (happyExpListPerState 11)

action_12 (14#) = happyShift action_16
action_12 (15#) = happyShift action_17
action_12 (16#) = happyShift action_18
action_12 (17#) = happyShift action_19
action_12 (19#) = happyShift action_28
action_12 x = happyTcHack x happyFail (happyExpListPerState 12)

action_13 x = happyTcHack x happyReduce_15

action_14 (9#) = happyShift action_27
action_14 (14#) = happyShift action_16
action_14 (15#) = happyShift action_17
action_14 (16#) = happyShift action_18
action_14 (17#) = happyShift action_19
action_14 x = happyTcHack x happyFail (happyExpListPerState 14)

action_15 (20#) = happyShift action_26
action_15 x = happyTcHack x happyFail (happyExpListPerState 15)

action_16 (7#) = happyShift action_5
action_16 (8#) = happyShift action_6
action_16 (11#) = happyShift action_7
action_16 (12#) = happyShift action_8
action_16 (13#) = happyShift action_9
action_16 (15#) = happyShift action_10
action_16 (18#) = happyShift action_11
action_16 (6#) = happyGoto action_25
action_16 x = happyTcHack x happyFail (happyExpListPerState 16)

action_17 (7#) = happyShift action_5
action_17 (8#) = happyShift action_6
action_17 (11#) = happyShift action_7
action_17 (12#) = happyShift action_8
action_17 (13#) = happyShift action_9
action_17 (15#) = happyShift action_10
action_17 (18#) = happyShift action_11
action_17 (6#) = happyGoto action_24
action_17 x = happyTcHack x happyFail (happyExpListPerState 17)

action_18 (7#) = happyShift action_5
action_18 (8#) = happyShift action_6
action_18 (11#) = happyShift action_7
action_18 (12#) = happyShift action_8
action_18 (13#) = happyShift action_9
action_18 (15#) = happyShift action_10
action_18 (18#) = happyShift action_11
action_18 (6#) = happyGoto action_23
action_18 x = happyTcHack x happyFail (happyExpListPerState 18)

action_19 (7#) = happyShift action_5
action_19 (8#) = happyShift action_6
action_19 (11#) = happyShift action_7
action_19 (12#) = happyShift action_8
action_19 (13#) = happyShift action_9
action_19 (15#) = happyShift action_10
action_19 (18#) = happyShift action_11
action_19 (6#) = happyGoto action_22
action_19 x = happyTcHack x happyFail (happyExpListPerState 19)

action_20 (7#) = happyShift action_5
action_20 (8#) = happyShift action_6
action_20 (11#) = happyShift action_7
action_20 (12#) = happyShift action_8
action_20 (13#) = happyShift action_9
action_20 (15#) = happyShift action_10
action_20 (18#) = happyShift action_11
action_20 (6#) = happyGoto action_21
action_20 x = happyTcHack x happyFail (happyExpListPerState 20)

action_21 (14#) = happyShift action_16
action_21 (15#) = happyShift action_17
action_21 (16#) = happyShift action_18
action_21 (17#) = happyShift action_19
action_21 x = happyTcHack x happyReduce_4

action_22 x = happyTcHack x happyReduce_8

action_23 x = happyTcHack x happyReduce_7

action_24 (16#) = happyShift action_18
action_24 (17#) = happyShift action_19
action_24 x = happyTcHack x happyReduce_6

action_25 (16#) = happyShift action_18
action_25 (17#) = happyShift action_19
action_25 x = happyTcHack x happyReduce_5

action_26 (7#) = happyShift action_5
action_26 (8#) = happyShift action_6
action_26 (11#) = happyShift action_7
action_26 (12#) = happyShift action_8
action_26 (13#) = happyShift action_9
action_26 (15#) = happyShift action_10
action_26 (18#) = happyShift action_11
action_26 (6#) = happyGoto action_30
action_26 x = happyTcHack x happyFail (happyExpListPerState 26)

action_27 (7#) = happyShift action_5
action_27 (8#) = happyShift action_6
action_27 (11#) = happyShift action_7
action_27 (12#) = happyShift action_8
action_27 (13#) = happyShift action_9
action_27 (15#) = happyShift action_10
action_27 (18#) = happyShift action_11
action_27 (6#) = happyGoto action_29
action_27 x = happyTcHack x happyFail (happyExpListPerState 27)

action_28 x = happyTcHack x happyReduce_16

action_29 (10#) = happyShift action_31
action_29 (14#) = happyShift action_16
action_29 (15#) = happyShift action_17
action_29 (16#) = happyShift action_18
action_29 (17#) = happyShift action_19
action_29 x = happyTcHack x happyReduce_13

action_30 (14#) = happyShift action_16
action_30 (15#) = happyShift action_17
action_30 (16#) = happyShift action_18
action_30 (17#) = happyShift action_19
action_30 x = happyTcHack x happyReduce_12

action_31 (7#) = happyShift action_5
action_31 (8#) = happyShift action_6
action_31 (11#) = happyShift action_7
action_31 (12#) = happyShift action_8
action_31 (13#) = happyShift action_9
action_31 (15#) = happyShift action_10
action_31 (18#) = happyShift action_11
action_31 (6#) = happyGoto action_32
action_31 x = happyTcHack x happyFail (happyExpListPerState 31)

action_32 (14#) = happyShift action_16
action_32 (15#) = happyShift action_17
action_32 (16#) = happyShift action_18
action_32 (17#) = happyShift action_19
action_32 x = happyTcHack x happyReduce_14

happyReduce_1 = happySpecReduce_0  4# happyReduction_1
happyReduction_1  =  HappyAbsSyn4
		 ([]
	)

happyReduce_2 = happySpecReduce_1  4# happyReduction_2
happyReduction_2 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  5# happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  5# happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_3 : happy_var_1
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  6# happyReduction_5
happyReduction_5 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Add happy_var_1 happy_var_3
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  6# happyReduction_6
happyReduction_6 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  6# happyReduction_7
happyReduction_7 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Mul happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  6# happyReduction_8
happyReduction_8 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Div happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  6# happyReduction_9
happyReduction_9 (HappyTerminal (T.IdToken happy_var_1 _))
	 =  HappyAbsSyn6
		 (Id happy_var_1
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  6# happyReduction_10
happyReduction_10 (HappyTerminal (T.IntToken happy_var_1 _))
	 =  HappyAbsSyn6
		 (Int happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  6# happyReduction_11
happyReduction_11 (HappyTerminal (T.DoubleToken happy_var_1 _))
	 =  HappyAbsSyn6
		 (Double happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happyReduce 4# 6# happyReduction_12
happyReduction_12 ((HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (T.IdToken happy_var_2 _)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Let happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_13 = happyReduce 4# 6# happyReduction_13
happyReduction_13 ((HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (If happy_var_2 happy_var_4 Nothing
	) `HappyStk` happyRest

happyReduce_14 = happyReduce 6# 6# happyReduction_14
happyReduction_14 ((HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (If happy_var_2 happy_var_4 (Just happy_var_6)
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_2  6# happyReduction_15
happyReduction_15 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (Minus happy_var_2
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  6# happyReduction_16
happyReduction_16 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (Brack happy_var_2
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyNewToken :: () => (Happy_GHC_Exts.Int#
                   -> Happy_GHC_Exts.Int#
                   -> (T.Token AlexPosn)
                   -> HappyState (T.Token AlexPosn) (t -> Alex a)
                   -> [HappyState (T.Token AlexPosn) (t -> Alex a)]
                   -> t
                   -> Alex a)
                 -> [HappyState (T.Token AlexPosn) (t -> Alex a)]
                 -> t
                 -> Alex a
happyNewToken action sts stk
	= alexMonadScan >>=(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	T.EOF _ -> action 22# 22# tk (HappyState action) sts stk;
	T.Let _ -> cont 7#;
	T.If _ -> cont 8#;
	T.Then _ -> cont 9#;
	T.Else _ -> cont 10#;
	T.IdToken happy_dollar_dollar _ -> cont 11#;
	T.IntToken happy_dollar_dollar _ -> cont 12#;
	T.DoubleToken happy_dollar_dollar _ -> cont 13#;
	T.Plus _ -> cont 14#;
	T.Minus _ -> cont 15#;
	T.Mul _ -> cont 16#;
	T.Div _ -> cont 17#;
	T.LeftParen _ -> cont 18#;
	T.RightParen _ -> cont 19#;
	T.Assign _ -> cont 20#;
	T.Semicolon _ -> cont 21#;
	_ -> happyError' (tk, [])
	})

happyError_ explist 22# tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> Alex a
happyReturn = (Prelude.return)
happyThen1 :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => ((T.Token AlexPosn), [Prelude.String]) -> Alex a
happyError' tk = (\(tokens, _) -> parseError tokens) tk
parse = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: T.Token AlexPosn -> Alex a
parseError t = alexError $ "parse error at token " ++ show t
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Prelude.Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Prelude.Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Prelude.Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif



















data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 1# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j ) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

































indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `Prelude.mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Happy_GHC_Exts.Int# ->                    -- token number
         Happy_GHC_Exts.Int# ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 1# tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Happy_GHC_Exts.Int#
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n ((_):(t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 1# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action 1# 1# tk (HappyState (action)) sts ((HappyErrorToken (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
