{-# LANGUAGE OverloadedStrings #-}
module Zmq.QueueSpec where

import Control.Lens ((^.))
import Control.Monad (forM_,forever)
import Control.Concurrent (threadDelay)
import Data.ByteString.Char8 (unpack)
import Text.Printf
import System.ZMQ4 (withContext,withSocket,bind,proxy,Dealer(..),Rep(..),Router(..))
import System.ZMQ4.Monadic (connect,liftIO,receive,runZMQ,send,socket,Req(..))
import Test.Hspec
import Test.QuickCheck
import System.ZMQ4

