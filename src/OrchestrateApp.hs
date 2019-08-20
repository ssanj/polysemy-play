module OrchestrateApp
  ( orchestrateApp
  )
where

import           Data.Text                      ( Text
                                                , pack
                                                )
import           Polysemy
import           Polysemy.Output
import           Polysemy.Error

import           Effects
import           Types

orchestrateApp
  :: Members
       '[ReadInputData, DecodeInputData, ProduceAwesomeLevel, SubmitAwesomenessLevel, Error
         AppError, Output Text]
       r
  => Sem r FinalResult
orchestrateApp = do
  rawInput <- performRead
  output $ "Received raw text: " <> rawInput
  awesomeness      <- performDecode rawInput
  awesomenessLevel <- performTransform awesomeness
  output $ "Submitting: " <> (pack . show $ awesomenessLevel)
  performSubmit awesomenessLevel
