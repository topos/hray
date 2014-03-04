module Main where

import System.Environment
import qualified Network.Json as S
import Arg (args,help,printUsage,role)

main :: IO ()
main = S.defmain
