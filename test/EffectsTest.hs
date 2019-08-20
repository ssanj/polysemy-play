module EffectsTest where

import           Data.Text                      ( Text )
import           Polysemy
import           Polysemy.Error

import           Effects
import           Types

emulateReadInputData :: Text -> Sem (ReadInputData ': r) a -> Sem r a
emulateReadInputData result = interpret $ \PerformRead -> pure result

emulateDecodeInputData
  :: Member (Error AppError) r
  => Either AppError Awesomeness
  -> Sem (DecodeInputData ': r) a
  -> Sem r a
emulateDecodeInputData result =
  interpret $ \(PerformDecode _) -> fromEither result

emulateProduceAL
  :: AwesomenessLevel -> Sem (ProduceAwesomeLevel ': r) a -> Sem r a
emulateProduceAL awesomenessLevel =
  interpret $ \(PerformTransform _) -> pure awesomenessLevel

emulateSubmitAL :: Sem (SubmitAwesomenessLevel ': r) a -> Sem r a
emulateSubmitAL = interpret $ \(PerformSubmit _) -> pure Success
