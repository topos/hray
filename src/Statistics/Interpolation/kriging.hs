{-# LANGUAGE ScopedTypeVariables,TemplateHaskell #-}
module Statistics.Interpolation.Kriging
       (flat,spherical,exponential,gaussian
       ,mkParams,nugget,sill,range,c0,c1)
       where
import Control.Lens

-- ref: http://people.ku.edu/~gbohling/cpe940/Variograms.pdf 
data Parameters = Parameters {_nugget :: Double
                             ,_sill :: Double
                             ,_range :: Double
                             ,_c0 :: Double
                             ,_c1 :: Double
                             } deriving (Show)
makeLenses ''Parameters

type Nugget = Double
type Sill = Double
type Range = Double
type H = Double

mkParams :: Nugget -> Sill -> Range -> Parameters
mkParams nugget sill range = Parameters {_nugget = nugget
                                        ,_sill = sill
                                        ,_range = range
                                        ,_c0 = nugget
                                        ,_c1 = sill-nugget}

-- variograms: www.nbb.cornell.edu/neurobio/land/OldStudentProjects/cs490-94to95/clang/kriging.html
flat :: Parameters -> H -> Double
flat p h | h == 0 = p^.c0
         | otherwise = p^.sill

spherical :: Parameters -> H -> Double
spherical p h | abs h <= (p^.range) = (p^.c0)+(p^.c1)*(1.5*h/(p^.range)-0.5*(h/(p^.range))**3)
              | otherwise = p^.sill

exponential :: Parameters -> H -> Double
exponential p h | abs h == 0 = 0
                | abs h > 0 = (p^.c0)+(p^.c1)*(1-exp((-3)*(abs h)/(p^.range)))
                              
gaussian :: Parameters -> H -> Double
gaussian p h | h == 0 = 0
             | otherwise = (p^.sill)*(1-exp((-3)*(abs h)**2/((p^.range)**2)))
