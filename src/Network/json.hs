{-# LANGUAGE OverloadedStrings #-}
module Network.Json where

{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import Data.Text (Text)
import Network.Wai
import Network.Wai.Internal (Response(ResponseBuilder))
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)
import Blaze.ByteString.Builder.ByteString (fromLazyByteString)

defmain = do
  let port = 3000
  putStrLn $ "Listening on port " ++ show port
  run port app

app req = return $ 
          case pathInfo req of
            -- Place custom routes here
            _ -> anyRoute

-- The data that will be converted to JSON
jsonData = ["a","b","c"] :: [Text]

anyRoute = ResponseBuilder status200 [(hContentType, "application/json")] $ fromLazyByteString (encode jsonData)
