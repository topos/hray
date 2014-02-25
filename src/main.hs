module Main where

import System.Environment
import qualified Actor.Cluster as C
import Arg (args,help,printUsage,role)

main :: IO ()
main = C.defaultMain args
