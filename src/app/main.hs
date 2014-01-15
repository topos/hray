module Main where

import System.Environment
import qualified Zmq.Queue as Q
import qualified Actor.Gossima as G
import qualified Actor.Warp as W
import Arg (args,help,printUsage,role)

main :: IO ()
--main = W.defaultMain 
main = Q.defaultMain args

