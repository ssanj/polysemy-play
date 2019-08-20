module Types where

import           Data.Text                      ( Text )

newtype Awesomeness = Awesomeness Int
  deriving (Eq, Show)

data AwesomenessLevel =
    NotAwesome
  | SomewhatAwesome
  | AwesomeAs
  deriving (Eq, Show)

data FinalResult =
    Success
  | Failure Text
  deriving (Eq, Show)

data AppError =
    FileReadFailure
  | ParseFailure
  | PostFailure
  deriving (Eq, Show)

newtype AppConfig = AppConfig
  { _postToUrl :: Text
  } deriving (Eq, Show)
