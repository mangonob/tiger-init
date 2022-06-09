{-# OPTIONS_GHC -fno-warn-unused-binds -fno-warn-missing-signatures #-}
{-# LANGUAGE CPP #-}
{-# LINE 1 "Lexer.x" #-}

module Simple.Lexer where

#if __GLASGOW_HASKELL__ >= 603
#include "ghcconfig.h"
#elif defined(__GLASGOW_HASKELL__)
#include "config.h"
#endif
#if __GLASGOW_HASKELL__ >= 503
import Data.Array
#else
import Array
#endif
{-# LINE 1 "templates/wrappers.hs" #-}
-- -----------------------------------------------------------------------------
-- Alex wrapper code.
--
-- This code is in the PUBLIC DOMAIN; you may copy it freely and use
-- it for any purpose whatsoever.


import Control.Applicative as App (Applicative (..))


import Data.Word (Word8)
















import Data.Char (ord)
import qualified Data.Bits

-- | Encode a Haskell String to a list of Word8 values, in UTF8 format.
utf8Encode :: Char -> [Word8]
utf8Encode = uncurry (:) . utf8Encode'

utf8Encode' :: Char -> (Word8, [Word8])
utf8Encode' c = case go (ord c) of
                  (x, xs) -> (fromIntegral x, map fromIntegral xs)
 where
  go oc
   | oc <= 0x7f       = ( oc
                        , [
                        ])

   | oc <= 0x7ff      = ( 0xc0 + (oc `Data.Bits.shiftR` 6)
                        , [0x80 + oc Data.Bits..&. 0x3f
                        ])

   | oc <= 0xffff     = ( 0xe0 + (oc `Data.Bits.shiftR` 12)
                        , [0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ])
   | otherwise        = ( 0xf0 + (oc `Data.Bits.shiftR` 18)
                        , [0x80 + ((oc `Data.Bits.shiftR` 12) Data.Bits..&. 0x3f)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ])



type Byte = Word8

-- -----------------------------------------------------------------------------
-- The input type


type AlexInput = (AlexPosn,     -- current position,
                  Char,         -- previous char
                  [Byte],       -- pending bytes on current char
                  String)       -- current input string

ignorePendingBytes :: AlexInput -> AlexInput
ignorePendingBytes (p,c,_ps,s) = (p,c,[],s)

alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (_p,c,_bs,_s) = c

alexGetByte :: AlexInput -> Maybe (Byte,AlexInput)
alexGetByte (p,c,(b:bs),s) = Just (b,(p,c,bs,s))
alexGetByte (_,_,[],[]) = Nothing
alexGetByte (p,_,[],(c:s))  = let p' = alexMove p c
                              in case utf8Encode' c of
                                   (b, bs) -> p' `seq`  Just (b, (p', c, bs, s))





























































-- -----------------------------------------------------------------------------
-- Token positions

-- `Posn' records the location of a token in the input text.  It has three
-- fields: the address (number of chacaters preceding the token), line number
-- and column of a token within the file. `start_pos' gives the position of the
-- start of the file and `eof_pos' a standard encoding for the end of file.
-- `move_pos' calculates the new position after traversing a given character,
-- assuming the usual eight character tab stops.


data AlexPosn = AlexPn !Int !Int !Int
        deriving (Eq,Show)

alexStartPos :: AlexPosn
alexStartPos = AlexPn 0 1 1

alexMove :: AlexPosn -> Char -> AlexPosn
alexMove (AlexPn a l c) '\t' = AlexPn (a+1)  l     (c+alex_tab_size-((c-1) `mod` alex_tab_size))
alexMove (AlexPn a l _) '\n' = AlexPn (a+1) (l+1)   1
alexMove (AlexPn a l c) _    = AlexPn (a+1)  l     (c+1)


-- -----------------------------------------------------------------------------
-- Monad (default and with ByteString input)


data AlexState = AlexState {
        alex_pos :: !AlexPosn,  -- position at current input location

        alex_inp :: String,     -- the current input
        alex_chr :: !Char,      -- the character before the input
        alex_bytes :: [Byte],





        alex_scd :: !Int        -- the current startcode



    }

-- Compile with -funbox-strict-fields for best results!


runAlex :: String -> Alex a -> Either String a
runAlex input__ (Alex f)
   = case f (AlexState {alex_bytes = [],





                        alex_pos = alexStartPos,
                        alex_inp = input__,
                        alex_chr = '\n',



                        alex_scd = 0}) of Left msg -> Left msg
                                          Right ( _, a ) -> Right a

newtype Alex a = Alex { unAlex :: AlexState -> Either String (AlexState, a) }

instance Functor Alex where
  fmap f a = Alex $ \s -> case unAlex a s of
                            Left msg -> Left msg
                            Right (s', a') -> Right (s', f a')

instance Applicative Alex where
  pure a   = Alex $ \s -> Right (s, a)
  fa <*> a = Alex $ \s -> case unAlex fa s of
                            Left msg -> Left msg
                            Right (s', f) -> case unAlex a s' of
                                               Left msg -> Left msg
                                               Right (s'', b) -> Right (s'', f b)

instance Monad Alex where
  m >>= k  = Alex $ \s -> case unAlex m s of
                                Left msg -> Left msg
                                Right (s',a) -> unAlex (k a) s'
  return = App.pure

alexGetInput :: Alex AlexInput
alexGetInput

 = Alex $ \s@AlexState{alex_pos=pos,alex_chr=c,alex_bytes=bs,alex_inp=inp__} ->
        Right (s, (pos,c,bs,inp__))





alexSetInput :: AlexInput -> Alex ()

alexSetInput (pos,c,bs,inp__)
 = Alex $ \s -> case s{alex_pos=pos,alex_chr=c,alex_bytes=bs,alex_inp=inp__} of







                  state__@(AlexState{}) -> Right (state__, ())

alexError :: String -> Alex a
alexError message = Alex $ const $ Left message

alexGetStartCode :: Alex Int
alexGetStartCode = Alex $ \s@AlexState{alex_scd=sc} -> Right (s, sc)

alexSetStartCode :: Int -> Alex ()
alexSetStartCode sc = Alex $ \s -> Right (s{alex_scd=sc}, ())









alexMonadScan = do

  inp__ <- alexGetInput



  sc <- alexGetStartCode
  case alexScan inp__ sc of
    AlexEOF -> alexEOF
    AlexError ((AlexPn _ line column),_,_,_) -> alexError $ "lexical error at line " ++ (show line) ++ ", column " ++ (show column)
    AlexSkip  inp__' _len -> do
        alexSetInput inp__'
        alexMonadScan

    AlexToken inp__' len action -> do



        alexSetInput inp__'
        action (ignorePendingBytes inp__) len

-- -----------------------------------------------------------------------------
-- Useful token actions


type AlexAction result = AlexInput -> Int -> Alex result




-- just ignore this token and scan another one
-- skip :: AlexAction result
skip _input _len = alexMonadScan

-- ignore this token, but set the start code to a new value
-- begin :: Int -> AlexAction result
begin code _input _len = do alexSetStartCode code; alexMonadScan

-- perform an action for this token, and set the start code to a new value
andBegin :: AlexAction result -> Int -> AlexAction result
(action `andBegin` code) input__ len = do
  alexSetStartCode code
  action input__ len


token :: (AlexInput -> Int -> token) -> AlexAction token



token t input__ len = return (t input__ len)



-- -----------------------------------------------------------------------------
-- Basic wrapper
























-- -----------------------------------------------------------------------------
-- Basic wrapper, ByteString version
































-- -----------------------------------------------------------------------------
-- Posn wrapper

-- Adds text positions to the basic model.













-- -----------------------------------------------------------------------------
-- Posn wrapper, ByteString version














-- -----------------------------------------------------------------------------
-- GScan wrapper

-- For compatibility with previous versions of Alex, and because we can.














alex_tab_size :: Int
alex_tab_size = 8
alex_base :: Array Int Int
alex_base = listArray (0 :: Int, 14)
  [ -8
  , -3
  , -37
  , 69
  , 79
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 154
  , 229
  , 304
  ]

alex_table :: Array Int Int
alex_table = listArray (0 :: Int, 559)
  [ 0
  , 1
  , 1
  , 1
  , 1
  , 1
  , 1
  , 1
  , 1
  , 1
  , 1
  , 2
  , 2
  , 2
  , 2
  , 2
  , 2
  , 2
  , 2
  , 2
  , 2
  , 0
  , 0
  , 0
  , 1
  , 0
  , 0
  , 0
  , 0
  , 1
  , 0
  , 0
  , 10
  , 11
  , 7
  , 5
  , 0
  , 6
  , 0
  , 8
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 0
  , 0
  , 0
  , 9
  , 0
  , 0
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 13
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 12
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 2
  , 0
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 3
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 13
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 13
  , 0
  , 13
  , 13
  , 13
  , 13
  , 14
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 13
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 13
  , 0
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 4
  , 13
  , 13
  , 13
  , 13
  , 13
  , 13
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  ]

alex_check :: Array Int Int
alex_check = listArray (0 :: Int, 559)
  [ -1
  , 9
  , 10
  , 11
  , 12
  , 13
  , 9
  , 10
  , 11
  , 12
  , 13
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , 32
  , -1
  , -1
  , -1
  , -1
  , 32
  , -1
  , -1
  , 40
  , 41
  , 42
  , 43
  , -1
  , 45
  , -1
  , 47
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , 61
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 46
  , -1
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  ]

alex_deflt :: Array Int Int
alex_deflt = listArray (0 :: Int, 14)
  [ -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  ]

alex_accept = listArray (0 :: Int, 14)
  [ AlexAccNone
  , AlexAccSkip
  , AlexAcc 12
  , AlexAcc 11
  , AlexAcc 10
  , AlexAcc 9
  , AlexAcc 8
  , AlexAcc 7
  , AlexAcc 6
  , AlexAcc 5
  , AlexAcc 4
  , AlexAcc 3
  , AlexAcc 2
  , AlexAcc 1
  , AlexAcc 0
  ]

alex_actions = array (0 :: Int, 13)
  [ (12,alex_action_1)
  , (11,alex_action_2)
  , (10,alex_action_3)
  , (9,alex_action_4)
  , (8,alex_action_5)
  , (7,alex_action_6)
  , (6,alex_action_7)
  , (5,alex_action_8)
  , (4,alex_action_9)
  , (3,alex_action_10)
  , (2,alex_action_11)
  , (1,alex_action_11)
  , (0,alex_action_11)
  ]

{-# LINE 28 "Lexer.x" #-}

data Token = IntToken Int AlexPosn 
    | DoubleToken Double AlexPosn 
    | IdToken String AlexPosn 
    | Assign AlexPosn
    | LeftParen AlexPosn
    | RightParen AlexPosn
    | Plus AlexPosn
    | Minus AlexPosn
    | Mul AlexPosn
    | Div AlexPosn
    | Let AlexPosn 
    | EOF AlexPosn deriving (Show, Eq)

alexEOF :: Alex Token
alexEOF = do 
    input <- alexGetInput
    let (pos, _, _, _)  = input
    return (EOF pos)

token' :: (String -> AlexPosn -> Token) -> AlexAction Token
token' f = token (\(pos, _, _, s) _ -> f s pos)

alex_action_1 =  token' $ DoubleToken . read 
alex_action_2 =  token' $ IntToken . read 
alex_action_3 =  token' $ const Let 
alex_action_4 =  token' $ const Plus 
alex_action_5 =  token' $ const Minus
alex_action_6 =  token' $ const Mul 
alex_action_7 =  token' $ const Div 
alex_action_8 =  token' $ const Assign
alex_action_9 =  token' $ const LeftParen 
alex_action_10 =  token' $ const RightParen 
alex_action_11 =  token' $ IdToken 
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- -----------------------------------------------------------------------------
-- ALEX TEMPLATE
--
-- This code is in the PUBLIC DOMAIN; you may copy it freely and use
-- it for any purpose whatsoever.

-- -----------------------------------------------------------------------------
-- INTERNALS and main scanner engine




































































alexIndexInt16OffAddr arr off = arr ! off
























alexIndexInt32OffAddr arr off = arr ! off











quickIndex arr i = arr ! i


-- -----------------------------------------------------------------------------
-- Main lexing routines

data AlexReturn a
  = AlexEOF
  | AlexError  !AlexInput
  | AlexSkip   !AlexInput !Int
  | AlexToken  !AlexInput !Int a

-- alexScan :: AlexInput -> StartCode -> AlexReturn a
alexScan input__ (sc)
  = alexScanUser undefined input__ (sc)

alexScanUser user__ input__ (sc)
  = case alex_scan_tkn user__ input__ (0) input__ sc AlexNone of
  (AlexNone, input__') ->
    case alexGetByte input__ of
      Nothing ->



                                   AlexEOF
      Just _ ->



                                   AlexError input__'

  (AlexLastSkip input__'' len, _) ->



    AlexSkip input__'' len

  (AlexLastAcc k input__''' len, _) ->



    AlexToken input__''' len (alex_actions ! k)


-- Push the input through the DFA, remembering the most recent accepting
-- state it encountered.

alex_scan_tkn user__ orig_input len input__ s last_acc =
  input__ `seq` -- strict in the input
  let
  new_acc = (check_accs (alex_accept `quickIndex` (s)))
  in
  new_acc `seq`
  case alexGetByte input__ of
     Nothing -> (new_acc, input__)
     Just (c, new_input) ->



      case fromIntegral c of { (ord_c) ->
        let
                base   = alexIndexInt32OffAddr alex_base s
                offset = (base + ord_c)
                check  = alexIndexInt16OffAddr alex_check offset

                new_s = if (offset >= (0)) && (check == ord_c)
                          then alexIndexInt16OffAddr alex_table offset
                          else alexIndexInt16OffAddr alex_deflt s
        in
        case new_s of
            (-1) -> (new_acc, input__)
                -- on an error, we want to keep the input *before* the
                -- character that failed, not after.
            _ -> alex_scan_tkn user__ orig_input (if c < 0x80 || c >= 0xC0 then (len + (1)) else len)
                                                -- note that the length is increased ONLY if this is the 1st byte in a char encoding)
                        new_input new_s new_acc
      }
  where
        check_accs (AlexAccNone) = last_acc
        check_accs (AlexAcc a  ) = AlexLastAcc a input__ (len)
        check_accs (AlexAccSkip) = AlexLastSkip  input__ (len)

        check_accs (AlexAccPred a predx rest)
           | predx user__ orig_input (len) input__
           = AlexLastAcc a input__ (len)
           | otherwise
           = check_accs rest
        check_accs (AlexAccSkipPred predx rest)
           | predx user__ orig_input (len) input__
           = AlexLastSkip input__ (len)
           | otherwise
           = check_accs rest


data AlexLastAcc
  = AlexNone
  | AlexLastAcc !Int !AlexInput !Int
  | AlexLastSkip     !AlexInput !Int

data AlexAcc user
  = AlexAccNone
  | AlexAcc Int
  | AlexAccSkip

  | AlexAccPred Int (AlexAccPred user) (AlexAcc user)
  | AlexAccSkipPred (AlexAccPred user) (AlexAcc user)

type AlexAccPred user = user -> AlexInput -> Int -> AlexInput -> Bool

-- -----------------------------------------------------------------------------
-- Predicates on a rule

alexAndPred p1 p2 user__ in1 len in2
  = p1 user__ in1 len in2 && p2 user__ in1 len in2

--alexPrevCharIsPred :: Char -> AlexAccPred _
alexPrevCharIs c _ input__ _ _ = c == alexInputPrevChar input__

alexPrevCharMatches f _ input__ _ _ = f (alexInputPrevChar input__)

--alexPrevCharIsOneOfPred :: Array Char Bool -> AlexAccPred _
alexPrevCharIsOneOf arr _ input__ _ _ = arr ! alexInputPrevChar input__

--alexRightContext :: Int -> AlexAccPred _
alexRightContext (sc) user__ _ _ input__ =
     case alex_scan_tkn user__ input__ (0) input__ sc AlexNone of
          (AlexNone, _) -> False
          _ -> True
        -- TODO: there's no need to find the longest
        -- match when checking the right context, just
        -- the first match will do.

