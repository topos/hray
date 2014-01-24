module Statistics.Interpolation (predict) where

import Data.Matrix

type X = Double
type Y = Double
type V = Double

predict :: X -> Y -> V
predict x y = x+y

e :: Double
e = exp 1

c0 :: Double
c0 = 0

c1 :: Double
c1 = 10

a :: Double
a = 10

distanceMatrix :: Matrix Double
distanceMatrix = fromLists [[ 0.0,   4.47,  3.61,  8.06,  9.49,  6.71,  8.94,  13.45]
                            ,[4.47,  0.0,   2.24,  10.44, 13.04, 10.05, 12.17, 17.8]
                            ,[3.61,  2.24,  0.0,   11.05, 13.0,  8.0,   10.05, 16.97]
                            ,[8.06,  10.04, 11.05, 0.0,   4.12,  13.04, 15.0,  11.05]
                            ,[9.49,  13.04, 13.05, 4.12,  0.0,   12.37, 13.93, 7.0]
                            ,[6.71,  10.05, 8.0,   13.04, 12.37, 0.0,   2.24,  12.05]
                            ,[8.94,  12.17, 10.05, 15.0,  13.93, 2.24,  0.0,   13.15]
                            ,[13.45, 17,8,  16.97, 11.05, 7.0,   12.65, 13.15, 0.0]]

cov :: Double -> Double
cov h
  | abs h == 0 = c0+c1
  | otherwise = c1*e**((-3.0)*abs(h)/a)

gamma :: Double -> Double
gamma h
  | h == 0 = 0
  | otherwise = c0+c1*(1.0-e**((-3.0)*abs(h)/a))
