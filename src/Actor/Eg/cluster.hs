module Actor.Eg.Cluster where

import System.Environment (getArgs)
import Control.Distributed.Process
import Control.Distributed.Process.Node (initRemoteTable)
import Control.Distributed.Process.Backend.SimpleLocalnet

master :: Backend -> [NodeId] -> Process ()
master backend slaves = do
  -- do something interesting with the slaves
  liftIO . putStrLn $ "Slaves: " ++ show slaves
  -- terminate the slaves when the master terminates (this is optional)
  terminateAllSlaves backend

defmain :: args -> IO ()
defmain args = do
  args <- getArgs
  case args of
    ["master", host, port] -> do
      backend <- initializeBackend host port initRemoteTable
      startMaster backend (master backend)
    ["slave", host, port] -> do
      backend <- initializeBackend host port initRemoteTable
      startSlave backend
    _ -> do
      putStrLn "e.g.: ./Main master localhost 8000"
      putStrLn "      ./Main slave localhost 9000"
