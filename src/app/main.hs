module Main where

import System.Environment
import qualified Zmq.Queue as Q
import qualified Actor.Gossima as G
import Arg (args,help,printUsage,role)

main :: IO ()
main = Q.defaultMain args

