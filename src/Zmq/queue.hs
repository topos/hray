module Queue where

import System.ZMQ4

run :: IO ()
run =
  withContext $ \ctx -> withSocket ctx Router $ \frontend -> withSocket ctx Dealer $ \backend -> do
    bind frontend "tcp://*:5559"
    bind backend "tcp://*:5560"      
    proxy frontend backend Nothing
