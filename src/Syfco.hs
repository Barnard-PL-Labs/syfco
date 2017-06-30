----------------------------------------------------------------------------
-- |
-- Module      :  Syfco
-- License     :  MIT (see the LICENSE file)
-- Maintainer  :  Felix Klein (klein@react.uni-saarland.de)
--
-- Syfco Library Interface.
--
-----------------------------------------------------------------------------

{-# LANGUAGE

    RecordWildCards

  #-}

-----------------------------------------------------------------------------

module Syfco
  ( -- * Data Structures
    Configuration(..)
  , WriteFormat(..)
  , WriteMode(..)
  , Semantics(..)
  , Target(..)
  , Specification
  , Error
    -- * Configurations
  , defaultCfg
  , update
  , verify
    -- * Specifcations
  , source
  , title
  , description
  , semantics
  , target
  , tags
  , parameters
  , inputs
  , outputs
  , symboltable
  , fromTLSF
  , partition
  , apply
    -- * Fragment Detection
  , checkGR
    -- * Meta Information
  , version
  ) where

-----------------------------------------------------------------------------

import Data.Types
  ( Semantics(..)
  , Target(..)
  )

import Data.Error
  ( Error
  )

import Config
  ( Configuration(..)
  , defaultCfg
  , update
  , verify
  )

import Writer.Data
  ( WriteMode(..)
  )

import Writer
  ( WriteFormat(..)
  , apply
  , partition
  )

import Data.Specification
  ( Specification
  , source
  , title
  , description
  , semantics
  , target
  , tags
  )

import qualified Data.Specification as S
  ( symboltable
  , parameters
  )

import Reader
  ( fromTLSF
  )

import Detection
  ( checkGR
  )

import Data.Binding
  ( BindExpr(..)
  )

import Data.SymbolTable
  ( IdRec(..)
  , st2csv
  )

import Data.Array
  ( (!)
  )

import Writer.Eval
  ( eval
  )

import Data.LTL
  ( Formula(..)
  , fmlInputs
  , fmlOutputs
  )

import Data.Info
  ( version
  )

-----------------------------------------------------------------------------

-- | Returns the parameters of a specification.

parameters
  :: Specification -> [String]

parameters s =
  map (idName . ((S.symboltable s) !) . bIdent) $ S.parameters s

-----------------------------------------------------------------------------

-- | Returns the input signals of a specification using the format as
-- implied by the given configuration.

inputs
  :: Configuration -> Specification -> Either Error [String]

inputs c s = case eval c s of
  Left err                  -> Left err
  Right (es,ss,rs,as,is,gs) ->
    return $ fmlInputs $ And $ es ++ ss ++ rs ++ as ++ is ++ gs

-----------------------------------------------------------------------------

-- | Returns the ouputs signals of a specification using the format as
-- implied by the given configuration.

outputs
  :: Configuration -> Specification -> Either Error [String]

outputs c s = case eval c s of
  Left err                  -> Left err
  Right (es,ss,rs,as,is,gs) ->
    return $ fmlOutputs $ And $ es ++ ss ++ rs ++ as ++ is ++ gs

-----------------------------------------------------------------------------

-- | Returns the symbol table of a specification in CSV format.

symboltable
  :: Specification -> String

symboltable =
  st2csv . S.symboltable

-----------------------------------------------------------------------------
