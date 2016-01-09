-----------------------------------------------------------------------------
-- |
-- Module      :  Writer.Formats.Utf8
-- License     :  MIT (see the LICENSE file)
-- Maintainer  :  Felix Klein (klein@react.uni-saarland.de)
-- 
-- Transforms a specification to a UTF8 string.
-- 
-----------------------------------------------------------------------------

module Writer.Formats.Utf8 where

-----------------------------------------------------------------------------

import Config
import Simplify

import Data.Error
import Data.Specification

import Writer.Eval
import Writer.Data
import Writer.Utils

-----------------------------------------------------------------------------

-- | UTF8 operator configuration.

opConfig
  :: OperatorConfig

opConfig = OperatorConfig
  { tTrue      = "⊤"
  , fFalse     = "⊥"
  , opNot      = UnaryOp  "¬" 1
  , opAnd      = BinaryOp "∧" 2 AssocLeft
  , opOr       = BinaryOp "∨" 3 AssocLeft
  , opImplies  = BinaryOp "→" 4 AssocRight
  , opEquiv    = BinaryOp "↔" 4 AssocRight
  , opNext     = UnaryOp  "◯" 1 
  , opFinally  = UnaryOp  "◇" 1 
  , opGlobally = UnaryOp  "□" 1 
  , opUntil    = BinaryOp "U" 6 AssocRight
  , opRelease  = BinaryOp "R" 7 AssocLeft
  , opWeak     = BinaryOp "W" 5 AssocRight
  }

-----------------------------------------------------------------------------

-- | UTF8 writer.

writeFormat
  :: Configuration -> Specification -> Either Error String

writeFormat c s = do
  (as,is,gs) <- eval c s
  fml0 <- merge as is gs
  fml1 <- simplify (adjust c opConfig) fml0
    
  return $ printFormula opConfig (outputMode c) fml1

-----------------------------------------------------------------------------

