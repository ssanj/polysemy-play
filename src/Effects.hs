{-# LANGUAGE TemplateHaskell #-}
module Effects where

import           Data.Text                      ( Text
                                                , pack
                                                )
import           Polysemy
import           Polysemy.Error
import           Polysemy.Reader
import           Data.Either.Combinators        ( maybeToRight )

import           AwesomenessParser
import           Types
import           ApiPoster
import           DetermineAwesomeness

data ReadInputData m a where
  PerformRead ::ReadInputData m Text

data DecodeInputData m a where
  PerformDecode ::Text -> DecodeInputData m Awesomeness

data ProduceAwesomeLevel m a where
  PerformTransform ::Awesomeness -> ProduceAwesomeLevel m AwesomenessLevel

data SubmitAwesomenessLevel m a where
  PerformSubmit ::AwesomenessLevel -> SubmitAwesomenessLevel m FinalResult

makeSem ''ReadInputData
makeSem ''DecodeInputData
makeSem ''ProduceAwesomeLevel
makeSem ''SubmitAwesomenessLevel

readInputDataInIO
  :: Member (Embed IO) r => Sem (ReadInputData ': r) a -> Sem r a
readInputDataInIO =
  interpret $ \PerformRead -> embed $ pack <$> readFile "data/data.txt"

decodeInputData
  :: Member (Error AppError) r => Sem (DecodeInputData ': r) a -> Sem r a
decodeInputData = interpret $ \(PerformDecode rawTestData) ->
  fromEither . maybeToRight ParseFailure $ parseAwesomeness rawTestData

produceAwesomeLevel :: Sem (ProduceAwesomeLevel ': r) a -> Sem r a
produceAwesomeLevel = interpret $ \(PerformTransform awesomeness) ->
  pure $ determineAwesomenessLevel awesomeness

submitAwesomenessInIO
  :: Members '[Reader AppConfig, Embed IO] r
  => Sem (SubmitAwesomenessLevel ': r) a
  -> Sem r a
submitAwesomenessInIO = interpret $ \(PerformSubmit result) -> do
  (AppConfig endpoint) <- ask
  embed $ runM $ postTextToApi endpoint (pack $ show result)
