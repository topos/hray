module Main where

import System.Environment
import Text.Printf (printf)
import Control.Lens ((^.))
import qualified Zmq.Queue as Queue
import qualified Actor.Gossima as Gossima
import Arg (args,help,printUsage,role)

main :: IO ()
main = Queue.defaultMain
--  args <- args

