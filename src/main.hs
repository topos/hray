module Main where

import System.Environment
import qualified Zmq.Queue as Q
import qualified Actor.Gossima as G
import qualified Actor.Warp as W
import qualified Actor.Cluster as C
import Arg (args,help,printUsage,role)

main :: IO ()
main = C.run args
-- main = W.defaultMain
