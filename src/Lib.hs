module Lib
  ( runApp
  )
where

import           Data.Foldable                  ( traverse_ )
import           Polysemy
import           Polysemy.Error
import           Polysemy.Output
import           Polysemy.Reader

import           Effects
import           OrchestrateApp
import           Types

runApp :: IO ()
runApp = do
  let config = AppConfig "http://cool.com/endpoint"
  (logs, result) <-
    runM
      $ ( runOutputList
        . runError
        . runReader config
        . submitAwesomenessInIO
        . produceAwesomeLevel
        . decodeInputData
        . readInputDataInIO
        )
          orchestrateApp
  traverse_ print logs
  case result of
    (Left  appError   ) -> putStrLn $ "Failed with: " <> show appError
    (Right finalResult) -> putStrLn $ "Completed with " <> show finalResult
