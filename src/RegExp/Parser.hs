{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
module RegExp.Parser where

import RegExp.AbSyn
import RegExp.Lexer (Alex, AlexPosn, alexMonadScan, alexError)
import RegExp.Token (Token)
import qualified RegExp.Token as T
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

data HappyAbsSyn 
	= HappyTerminal (Token AlexPosn)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (RegExps)
	| HappyAbsSyn5 ([Flag])
	| HappyAbsSyn6 (RegExp)
	| HappyAbsSyn8 ([CharSet])
	| HappyAbsSyn9 (CharSet)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Happy_GHC_Exts.Int# 
	-> (Token AlexPosn)
	-> HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> m HappyAbsSyn)
	-> [HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> m HappyAbsSyn)] 
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
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37 :: () => Happy_GHC_Exts.Int# -> ({-HappyReduction (Alex) = -}
	   Happy_GHC_Exts.Int# 
	-> (Token AlexPosn)
	-> HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
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
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23 :: () => ({-HappyReduction (Alex) = -}
	   Happy_GHC_Exts.Int# 
	-> (Token AlexPosn)
	-> HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Token AlexPosn) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x0a\xa8\x01\x50\x40\x09\x00\x00\x01\x00\x54\xd6\x02\xa0\x80\x12\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x02\x4a\x00\x00\x08\x01\x00\x01\x10\x00\x00\x00\x00\x10\x10\x00\x40\x65\x0d\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x80\x12\x00\x00\x00\x00\x00\x41\x00\x00\x00\x00\x00\x10\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parse","reg_exps","flags","reg_exp0","reg_exp","char_sets","char_set","'('","')'","'['","']'","'{'","'}'","'-'","'+'","'?'","'|'","'^'","','","'$'","'*'","'/'","ch","int","%eof"]
        bit_start = st Prelude.* 27
        bit_end = (st Prelude.+ 1) Prelude.* 27
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..26]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (10#) = happyShift action_4
action_0 (12#) = happyShift action_5
action_0 (20#) = happyShift action_6
action_0 (22#) = happyShift action_7
action_0 (24#) = happyShift action_10
action_0 (25#) = happyShift action_8
action_0 (4#) = happyGoto action_9
action_0 (6#) = happyGoto action_2
action_0 (7#) = happyGoto action_3
action_0 x = happyTcHack x happyReduce_5

action_1 (10#) = happyShift action_4
action_1 (12#) = happyShift action_5
action_1 (20#) = happyShift action_6
action_1 (22#) = happyShift action_7
action_1 (25#) = happyShift action_8
action_1 (6#) = happyGoto action_2
action_1 (7#) = happyGoto action_3
action_1 x = happyTcHack x happyFail (happyExpListPerState 1)

action_2 (19#) = happyShift action_20
action_2 x = happyTcHack x happyReduce_1

action_3 (10#) = happyShift action_4
action_3 (12#) = happyShift action_5
action_3 (14#) = happyShift action_16
action_3 (17#) = happyShift action_17
action_3 (18#) = happyShift action_18
action_3 (20#) = happyShift action_6
action_3 (22#) = happyShift action_7
action_3 (23#) = happyShift action_19
action_3 (25#) = happyShift action_8
action_3 (7#) = happyGoto action_15
action_3 x = happyTcHack x happyReduce_6

action_4 (10#) = happyShift action_4
action_4 (12#) = happyShift action_5
action_4 (20#) = happyShift action_6
action_4 (22#) = happyShift action_7
action_4 (25#) = happyShift action_8
action_4 (6#) = happyGoto action_14
action_4 (7#) = happyGoto action_3
action_4 x = happyTcHack x happyReduce_5

action_5 (20#) = happyShift action_13
action_5 (8#) = happyGoto action_12
action_5 x = happyTcHack x happyReduce_20

action_6 x = happyTcHack x happyReduce_18

action_7 x = happyTcHack x happyReduce_19

action_8 x = happyTcHack x happyReduce_8

action_9 (27#) = happyAccept
action_9 x = happyTcHack x happyFail (happyExpListPerState 9)

action_10 (10#) = happyShift action_4
action_10 (12#) = happyShift action_5
action_10 (20#) = happyShift action_6
action_10 (22#) = happyShift action_7
action_10 (25#) = happyShift action_8
action_10 (6#) = happyGoto action_11
action_10 (7#) = happyGoto action_3
action_10 x = happyTcHack x happyReduce_5

action_11 (19#) = happyShift action_20
action_11 (24#) = happyShift action_28
action_11 x = happyTcHack x happyFail (happyExpListPerState 11)

action_12 (13#) = happyShift action_26
action_12 (25#) = happyShift action_27
action_12 (9#) = happyGoto action_25
action_12 x = happyTcHack x happyFail (happyExpListPerState 12)

action_13 (8#) = happyGoto action_24
action_13 x = happyTcHack x happyReduce_20

action_14 (11#) = happyShift action_23
action_14 (19#) = happyShift action_20
action_14 x = happyTcHack x happyFail (happyExpListPerState 14)

action_15 (10#) = happyShift action_4
action_15 (12#) = happyShift action_5
action_15 (14#) = happyShift action_16
action_15 (17#) = happyShift action_17
action_15 (18#) = happyShift action_18
action_15 (20#) = happyShift action_6
action_15 (22#) = happyShift action_7
action_15 (23#) = happyShift action_19
action_15 (7#) = happyGoto action_15
action_15 x = happyTcHack x happyReduce_9

action_16 (26#) = happyShift action_22
action_16 x = happyTcHack x happyFail (happyExpListPerState 16)

action_17 x = happyTcHack x happyReduce_13

action_18 x = happyTcHack x happyReduce_12

action_19 x = happyTcHack x happyReduce_14

action_20 (10#) = happyShift action_4
action_20 (12#) = happyShift action_5
action_20 (20#) = happyShift action_6
action_20 (22#) = happyShift action_7
action_20 (25#) = happyShift action_8
action_20 (6#) = happyGoto action_21
action_20 (7#) = happyGoto action_3
action_20 x = happyTcHack x happyReduce_5

action_21 x = happyTcHack x happyReduce_7

action_22 (15#) = happyShift action_32
action_22 (21#) = happyShift action_33
action_22 x = happyTcHack x happyFail (happyExpListPerState 22)

action_23 x = happyTcHack x happyReduce_15

action_24 (13#) = happyShift action_31
action_24 (25#) = happyShift action_27
action_24 (9#) = happyGoto action_25
action_24 x = happyTcHack x happyFail (happyExpListPerState 24)

action_25 x = happyTcHack x happyReduce_21

action_26 x = happyTcHack x happyReduce_16

action_27 (16#) = happyShift action_30
action_27 x = happyTcHack x happyReduce_23

action_28 (5#) = happyGoto action_29
action_28 x = happyTcHack x happyReduce_3

action_29 (25#) = happyShift action_36
action_29 x = happyTcHack x happyReduce_2

action_30 (25#) = happyShift action_35
action_30 x = happyTcHack x happyFail (happyExpListPerState 30)

action_31 x = happyTcHack x happyReduce_17

action_32 x = happyTcHack x happyReduce_10

action_33 (26#) = happyShift action_34
action_33 x = happyTcHack x happyFail (happyExpListPerState 33)

action_34 (15#) = happyShift action_37
action_34 x = happyTcHack x happyFail (happyExpListPerState 34)

action_35 x = happyTcHack x happyReduce_22

action_36 x = happyTcHack x happyReduce_4

action_37 x = happyTcHack x happyReduce_11

happyReduce_1 = happySpecReduce_1  4# happyReduction_1
happyReduction_1 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn4
		 (RegExps happy_var_1 []
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happyReduce 4# 4# happyReduction_2
happyReduction_2 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (RegExps happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_0  5# happyReduction_3
happyReduction_3  =  HappyAbsSyn5
		 ([]
	)

happyReduce_4 = happySpecReduce_2  5# happyReduction_4
happyReduction_4 (HappyTerminal (T.Char happy_var_2 _))
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (Flag happy_var_2 : happy_var_1
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_0  6# happyReduction_5
happyReduction_5  =  HappyAbsSyn6
		 (Empty
	)

happyReduce_6 = happySpecReduce_1  6# happyReduction_6
happyReduction_6 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  6# happyReduction_7
happyReduction_7 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Or happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  7# happyReduction_8
happyReduction_8 (HappyTerminal (T.Char happy_var_1 _))
	 =  HappyAbsSyn6
		 (Char happy_var_1
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_2  7# happyReduction_9
happyReduction_9 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Concat happy_var_2 happy_var_1
	)
happyReduction_9 _ _  = notHappyAtAll 

happyReduce_10 = happyReduce 4# 7# happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyTerminal (T.Int happy_var_3 _)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Repeat happy_var_1 happy_var_3 Nothing
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 6# 7# happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyTerminal (T.Int happy_var_5 _)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (T.Int happy_var_3 _)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Repeat happy_var_1 happy_var_3 (Just happy_var_5)
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_2  7# happyReduction_12
happyReduction_12 _
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Optional happy_var_1
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  7# happyReduction_13
happyReduction_13 _
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Require happy_var_1
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  7# happyReduction_14
happyReduction_14 _
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Closure happy_var_1
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  7# happyReduction_15
happyReduction_15 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (Group happy_var_2
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  7# happyReduction_16
happyReduction_16 _
	(HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (CharSets happy_var_2 False
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happyReduce 4# 7# happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (CharSets happy_var_3 True
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_1  7# happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn6
		 (LineStart
	)

happyReduce_19 = happySpecReduce_1  7# happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn6
		 (LineEnd
	)

happyReduce_20 = happySpecReduce_0  8# happyReduction_20
happyReduction_20  =  HappyAbsSyn8
		 ([]
	)

happyReduce_21 = happySpecReduce_2  8# happyReduction_21
happyReduction_21 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_2 : happy_var_1
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  9# happyReduction_22
happyReduction_22 (HappyTerminal (T.Char happy_var_3 _))
	_
	(HappyTerminal (T.Char happy_var_1 _))
	 =  HappyAbsSyn9
		 (Range happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  9# happyReduction_23
happyReduction_23 (HappyTerminal (T.Char happy_var_1 _))
	 =  HappyAbsSyn9
		 (Only happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyNewToken :: () => (Happy_GHC_Exts.Int#
                   -> Happy_GHC_Exts.Int#
                   -> (Token AlexPosn)
                   -> HappyState (Token AlexPosn) (t -> Alex a)
                   -> [HappyState (Token AlexPosn) (t -> Alex a)]
                   -> t
                   -> Alex a)
                 -> [HappyState (Token AlexPosn) (t -> Alex a)]
                 -> t
                 -> Alex a
happyNewToken action sts stk
	= alexMonadScan >>=(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	T.EOF _ -> action 27# 27# tk (HappyState action) sts stk;
	T.ParenLeft _ -> cont 10#;
	T.ParenRight _ -> cont 11#;
	T.BracketLeft _ -> cont 12#;
	T.BracketRight _ -> cont 13#;
	T.BraceLeft _ -> cont 14#;
	T.BraceRight _ -> cont 15#;
	T.Minus _ -> cont 16#;
	T.Plus  _ -> cont 17#;
	T.Question _ -> cont 18#;
	T.Channel _ -> cont 19#;
	T.Caret _ -> cont 20#;
	T.Comma _ -> cont 21#;
	T.Dollar _ -> cont 22#;
	T.Star _ -> cont 23#;
	T.Slash _ -> cont 24#;
	T.Char happy_dollar_dollar _ -> cont 25#;
	T.Int happy_dollar_dollar _ -> cont 26#;
	_ -> happyError' (tk, [])
	})

happyError_ explist 27# tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> Alex a
happyReturn = (Prelude.return)
happyThen1 :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => ((Token AlexPosn), [Prelude.String]) -> Alex a
happyError' tk = (\(tokens, _) -> parseError tokens) tk
parse = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: Token AlexPosn -> Alex a
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
