module OrchestrateAppSpec where

import           Test.Hspec                     ( Spec
                                                , describe
                                                , it
                                                , shouldBe
                                                )
import           Polysemy
import           Polysemy.Output
import           Polysemy.Error
import qualified Hedgehog.Gen                  as G

import           OrchestrateApp
import           Generators
import           EffectsTest
import           Types

spec :: Spec
spec = describe "orchestrateApp" $ do
  it "happy path" $ do
    awesomeness <- G.sample genAwesomeness
    let readInputData'   = emulateReadInputData "blah"
        decodeInputData' = emulateDecodeInputData $ Right awesomeness
        transformAL'     = emulateProduceAL AwesomeAs
        app              = orchestrateApp
        (_, result) =
          run
            $ ( runOutputList
              . runError
              . emulateSubmitAL
              . transformAL'
              . decodeInputData'
              . readInputData'
              )
                app
    result `shouldBe` Right Success

  it "decode failure" $ do
    let readInputData'   = emulateReadInputData "blah"
        decodeInputData' = emulateDecodeInputData $ Left ParseFailure
        transformAL'     = emulateProduceAL AwesomeAs
        app              = orchestrateApp
        (_, result) =
          run
            $ ( runOutputList
              . runError
              . emulateSubmitAL
              . transformAL'
              . decodeInputData'
              . readInputData'
              )
                app
    result `shouldBe` Left ParseFailure
