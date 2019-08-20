module DetermineAwesomeness where

import Types

determineAwesomenessLevel :: Awesomeness -> AwesomenessLevel
determineAwesomenessLevel (Awesomeness level)
  | level < 25 = NotAwesome
  | level < 80 = SomewhatAwesome
  | otherwise = AwesomeAs
