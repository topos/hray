module Main where

import System.Environment
import qualified Network.Json as S
import Arg (args,help,printUsage,role)

main :: IO ()
<<<<<<< HEAD
main = C.run args
-- main = W.defaultMain
=======
main = S.defmain
>>>>>>> 9d4990e60034ffeca7d590377ac2fb61360702dc
