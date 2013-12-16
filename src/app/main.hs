module Main where

import Text.Printf(printf)
import Actor.Cluster as Cluster
import Actor.Gossima as Gossima

main :: IO ()
main = Gossima.run
