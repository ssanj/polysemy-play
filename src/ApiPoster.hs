module ApiPoster
  ( postTextToApi
  )
where

import           Control.Monad.IO.Class
import           Data.Text                      ( Text )

import           Types

postTextToApi :: MonadIO m => Text -> Text -> m FinalResult
postTextToApi endpoint body = pure Success
