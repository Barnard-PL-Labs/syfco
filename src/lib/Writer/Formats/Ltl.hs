-----------------------------------------------------------------------------
-- |
-- Module      :  Writer.Formats.Ltl
-- License     :  MIT (see the LICENSE file)
-- Maintainer  :  Felix Klein (klein@react.uni-saarland.de)
--
-- Transforms a specification to a pure LTL formula.
--
-----------------------------------------------------------------------------

module Writer.Formats.Ltl where

-----------------------------------------------------------------------------

import Config
import Simplify

import Data.Error
import Data.Specification

import Writer.Eval
import Writer.Data
import Writer.Utils

-----------------------------------------------------------------------------

-- | pure LTL operator configuration.

opConfig
  :: OperatorConfig

opConfig = OperatorConfig
  { tTrue          = "true"
  , fFalse         = "false"
  , opNot          = UnaryOp  "!"   1
  , opAnd          = BinaryOp "&&"  2 AssocLeft
  , opOr           = BinaryOp "||"  3 AssocLeft
  , opImplies      = BinaryOp "->"  4 AssocRight
  , opEquiv        = BinaryOp "<->" 4 AssocRight
  , opNext         = UnaryOp  "X"   1
  , opPrevious     = UnaryOp  "Y"   1
  , opFinally      = UnaryOp  "F"   1
  , opGlobally     = UnaryOp  "G"   1
  , opHistorically = UnaryOp  "H"   1
  , opOnce         = UnaryOp  "O"   1
  , opUntil        = BinaryOp "U"   6 AssocRight
  , opRelease      = BinaryOp "R"   7 AssocLeft
  , opWeak         = BinaryOp "W"   5 AssocRight
  , opSince        = BinaryOp "S"   8 AssocRight
  , opTriggered    = BinaryOp "T"   9 AssocLeft
  }

-----------------------------------------------------------------------------

-- | LTL writer.

writeFormat
  :: Configuration -> Specification -> Either Error String

writeFormat c s = do
  (es,ss,rs,as,is,gs) <- eval c s
  fml0 <- merge es ss rs as is gs
  fml1 <- simplify (adjust c opConfig) fml0

  printFormula opConfig (outputMode c) (quoteMode c) fml1

-----------------------------------------------------------------------------
