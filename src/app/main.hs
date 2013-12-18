module Main where

import System.Environment
import Text.Printf (printf)
import Control.Lens ((^.))
import qualified Zmq.Queue as Queue
import qualified Actor.Gossima as Gossima
import Arg (args,help,printUsage,role)

main :: IO ()
main = do
  args <- args
  if not (args^.help) then
    case args^.role of
      "queue" -> Queue.start
      "server" -> Queue.server
      "client" -> Queue.client
    _ -> printUsage
  else
    printUsage

