{-# LANGUAGE DeriveDataTypeable #-}
module Actor.Eg.Warp (defmain) where

import Network.Wai (Application,responseBuilder)
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType,hContentLength,hConnection)
import qualified Network.Wai.Handler.Warp as Warp (run)
import Blaze.ByteString.Builder (fromByteString)
import qualified Data.ByteString.Char8 as C8 (pack,length)

app :: Application
app _ = return $ responseBuilder status200
                                 [(hContentType,C8.pack "text/plain"), 
                                  (hContentLength,C8.pack $ show bodyLen),
                                  (hConnection,C8.pack "keep-alive")]
                                 (fromByteString body)
                 where body = C8.pack "Hi, There!"
                       bodyLen = C8.length body

run :: IO ()
run = Warp.run 8080 app
