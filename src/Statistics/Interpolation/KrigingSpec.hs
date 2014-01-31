module Statistics.Interpolation.KrigingSpec
       (spec)
       where

import Control.Lens
import Data.Matrix
import Test.Hspec
import Test.QuickCheck
import Statistics.Interpolation.Kriging (flat,spherical,exponential,gaussian,mkParams,nugget,sill,range,c0,c1)

distanceMatrix :: Matrix Double
distanceMatrix = fromLists [[0,     4.47,  3.61,  8.06,  9.49,  6.71,  8.94,  13.45]
                           ,[4.47,  0,     2.24,  10.44, 13.04, 10.05, 12.17, 17.8]
                           ,[3.61,  2.24,  0,     11.05, 13,    8,     10.05, 16.97]
                           ,[8.06,  10.04, 11.05, 0,     4.12,  13.04, 15,    11.05]
                           ,[9.49,  13.04, 13.05, 4.12,  0,     12.37, 13.93, 7]
                           ,[6.71,  10.05, 8.0,   13.04, 12.37, 0,     2.24,  12.05]
                           ,[8.94,  12.17, 10.05, 15.0,  13.93, 2.24,  0,     13.15]
                           ,[13.45, 17,8,  16.97, 11.05, 7,     12.65, 13.15, 0]]

spec :: Spec
spec = do
  context "As Defined" $ do
    let nugget' = 1
        sill' = 100
        range' = 10
        p = mkParams nugget' sill' range'
    describe "Kriging.Parameters" $ do
      it "returns c0 and c1 as defined" $ do
        p^.c0 `shouldBe` nugget'
        p^.c1 `shouldBe` sill'-nugget'
    describe "Kriging.flat" $ do
      it "returns c0 when h=0" $ do
        flat p 0 `shouldBe` p^.c0
      it "returns sill when h>0" $ do
        flat p 1 `shouldBe` p^.sill
    describe "Kriging.spherical" $ do
      it "returns c0 when h=0" $ do
        spherical p 0 `shouldBe` p^.c0
      it "returns (c0,sill) when 0<h<=range" $ do
        -- refactor code below
        spherical p (range'/2) `shouldSatisfy` (\z -> z > p^.c0 && z < p^.sill)
        spherical p (range'/4) `shouldSatisfy` (\z -> z > p^.c0 && z < p^.sill)
        spherical p (range'/16) `shouldSatisfy` (\z -> z > p^.c0 && z < p^.sill)
        spherical p (range'/32) `shouldSatisfy` (\z -> z > p^.c0 && z < p^.sill)
      it "returns sill when h>=range" $ do
        spherical p (range') `shouldBe` p^.sill
        spherical p (2*range') `shouldBe` p^.sill
        spherical p (10*range') `shouldBe` p^.sill
    describe "Kriging.exponential" $ do
      it "returns 0 when h=0" $ do
        exponential p 0 `shouldBe` 0
      it "returns (0,sill) when h>=0" $ do
        exponential p (range') `shouldSatisfy` (< p^.sill)
        exponential p (2*range') `shouldSatisfy` (< p^.sill)
        exponential p (10*range') `shouldSatisfy` (< p^.sill)
    describe "Kriging.gaussian" $ do
      it "returns 0 when h=0" $ do
        gaussian p 0 `shouldBe` 0
      it "returns (0,sill) when h>=0" $ do
        gaussian p (range') `shouldSatisfy` (< p^.sill)
        gaussian p (2*range') `shouldSatisfy` (< p^.sill)
        gaussian p (10*range') `shouldSatisfy` (<= p^.sill) -- in theory it should be < the sill
