module Statistics.Interpolation.KrigingSpec (spec) where

import Data.Matrix
import Test.Hspec
import Test.QuickCheck
import Statistics.Interpolation.Kriging

distanceMatrix :: Matrix Double
distanceMatrix = fromLists [[ 0,     4.47,  3.61,  8.06,  9.49,  6.71,  8.94,  13.45]
                            ,[4.47,  0,     2.24,  10.44, 13.04, 10.05, 12.17, 17.8]
                            ,[3.61,  2.24,  0,     11.05, 13,    8,     10.05, 16.97]
                            ,[8.06,  10.04, 11.05, 0,     4.12,  13.04, 15,    11.05]
                            ,[9.49,  13.04, 13.05, 4.12,  0,     12.37, 13.93, 7]
                            ,[6.71,  10.05, 8.0,   13.04, 12.37, 0,     2.24,  12.05]
                            ,[8.94,  12.17, 10.05, 15.0,  13.93, 2.24,  0,     13.15]
                            ,[13.45, 17,8,  16.97, 11.05, 7,     12.65, 13.15, 0]]

spec :: Spec
spec = do
  describe "Kriging.variogram" $ do
    it "returns 0 when h=0" $ do
      variogram 0 `shouldBe` 0
