{-# LANGUAGE TemplateHaskell #-}
module Arg (args,role,host,port,help,usage,printUsage,Options(..)) where

import System.Console.GetOpt
import System.Environment (getArgs,getProgName)
import Control.Lens

data Options = Options{_role::String
                       ,_host::String
                       ,_port::Int
                       ,_help::Bool
                       } deriving Show
defaultOptions = Options{_role="slave"
                        ,_host="localhost"
                        ,_port=9999
                        ,_help=False}
makeLenses '' Options

options :: [OptDescr (Options -> Options)]
options = [Option ['h'] ["host"]
           (ReqArg (\h opts -> opts{_host=h}) "host")
           "host"
          ,Option ['r'] ["role"]
           (ReqArg (\r opts -> opts{_role=r}) "role")
           "role"
          ,Option ['p'] ["port"]
           (ReqArg (\p opts -> opts{_port=(read p)}) "port")
           "port"
          ,Option ['?'] ["help"]
           (NoArg (\opts -> opts{_help=True}))
           "help"]

cmd :: IO String
cmd = getProgName

args :: IO Options
args = do
  args <- getArgs
  case getOpt RequireOrder options args of
    (opts, [], []) -> return (foldl (flip id) defaultOptions opts)
    (_, _, errs) -> do
      usage' <- usage
      ioError (userError $ concat errs ++ usage')

usage :: IO String
usage = do
  cmd' <- cmd
  let header = "usage: " ++ cmd' ++ " [options...]"
  return $ usageInfo header options

printUsage :: IO ()
printUsage = do
  usage <- usage
  putStr usage
