{-# LANGUAGE DeriveDataTypeable #-}
module Actor.Gossima (start,defaultMain) where

import Control.Concurrent (threadDelay)
import Data.Binary
import Data.Typeable
import Control.Distributed.Process
import Control.Distributed.Process.Node
import Control.Concurrent (threadDelay)
import Network.Transport.TCP

start :: Process ()
start = do
  sPing <- spawnChannelLocal server -- start server
  spawnLocal $ client sPing -- start client
  liftIO $ threadDelay 100000 -- wait a while

data Ping = Ping deriving (Typeable) -- serializable (= Binary + Typeable)

instance Binary Ping where
  put Ping = putWord8 0
  get = do {getWord8; return Ping}

server :: ReceivePort Ping -> Process ()
server rPing = do
  Ping <- receiveChan rPing
  liftIO $ print "ping"

client :: SendPort Ping -> Process ()
client sPing = do
  sendChan sPing Ping
  
-- main = defaultMain
defaultMain :: IO ()
defaultMain = do
  Right transport <- createTransport "127.0.0.1" "8080" defaultTCPParameters
  node <- newLocalNode transport initRemoteTable
  runProcess node start

-- data SendPort a     -- Serializable
-- data ReceivePort a  -- NOT Serializable
-- newChan     :: Serializable a => Process (SendPort a, ReceivePort a)
-- sendChan    :: Serializable a => SendPort a -> a -> Process ()
-- receiveChan :: Serializable a => ReceivePort a -> Process a
