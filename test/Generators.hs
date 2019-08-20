module Generators where

import           Hedgehog                       ( Gen )
import qualified Hedgehog.Gen                  as G
import qualified Hedgehog.Range                as HR

import           Types

genAwesomeness :: Gen Awesomeness
genAwesomeness = Awesomeness <$> G.int (HR.constant 1 100)
