module AwesomenessParser
  ( parseAwesomeness
  )
where

import           Data.Text                      ( Text
                                                , unpack
                                                )
import           Data.Void                      ( Void )
import           Text.Megaparsec                ( Parsec
                                                , parseMaybe
                                                )
import           Text.Megaparsec.Char           ( string
                                                , space
                                                , newline
                                                , spaceChar
                                                )
import           Control.Applicative            ( (<|>) )
import           Control.Monad.Combinators      ( skipMany )
import qualified Text.Megaparsec.Char.Lexer    as L
                                                ( decimal )

import           Types

type Parser = Parsec Void String

awesomenessParser :: Parser Awesomeness
awesomenessParser = do
  _     <- string "Awesomeness"
  _     <- space
  level <- L.decimal
  _     <- skipMany (spaceChar <|> newline)
  pure $ Awesomeness level

parseAwesomeness :: Text -> Maybe Awesomeness
parseAwesomeness = parseMaybe awesomenessParser . unpack
