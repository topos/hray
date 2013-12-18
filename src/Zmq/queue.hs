{-# LANGUAGE OverloadedStrings #-}
module Zmq.Queue (start,server,client) where

import Control.Concurrent (threadDelay)
import Control.Monad (forM_,forever)
import Data.ByteString.Char8 (unpack)
import Text.Printf
import System.ZMQ4 (withContext,withSocket,bind,proxy,Dealer(..),Rep(..),Router(..))
import System.ZMQ4.Monadic (runZMQ,socket,connect,send,receive,Req(..),liftIO)

start :: IO ()
start = withContext $ \ctx -> withSocket ctx Router $ \frontend -> withSocket ctx Dealer $ \backend -> do
  bind frontend "tcp://*:5559"
  bind backend "tcp://*:5560"
  putStrLn "queue started"
  proxy frontend backend Nothing

-- sample server/client app
client :: IO ()
client = do
  putStrLn "client starting ..."
  runZMQ $ do
    requester <- socket Req
    connect requester "tcp://localhost:5559"
    forM_ [1..10] $ \i -> do
      send requester [] "Hello"  
      msg <- receive requester
      liftIO $ printf "Received reply %d %s\n" (i ::Int) (unpack msg)

server :: IO ()
server = do
  putStrLn "server starting ..."
  runZMQ $ do
    responder <- socket Rep
    connect responder "tcp://localhost:5560"
    forever $ do
      receive responder >>= liftIO . printf "Received request: [%s]\n" . unpack
      -- Simulate doing some 'work' for 1 second
      liftIO $ threadDelay (1 * 1000 * 1000)
      send responder [] "World"       
