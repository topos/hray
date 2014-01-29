{-# LANGUAGE ScopedTypeVariables #-}
module Statistics.Interpolation.Kriging (predict,covariance,variogram) where

import Data.Matrix

type X = Double
type Y = Double
type V = Double

predict :: X -> Y -> V
predict x y = x+y

e :: Double = exp 1
c0 :: Double = 0
c1 :: Double = 10
a :: Double = 10

covariance :: Double -> Double
covariance h
  | abs h == 0 = c0+c1
  | otherwise = c1*e**((-3.0)*abs(h)/a)

variogram:: Double -> Double
variogram h
  | h == 0 = 0
  | otherwise = c0+c1*(1.0-e**((-3.0)*abs(h)/a))
