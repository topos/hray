{- stolen from http://www.yesodweb.com/book/json-web-service -}
{-# LANGUAGE OverloadedStrings #-}
module Network.Json where

import System.Environment (getArgs)
import Control.Exception (SomeException)
import Control.Exception.Lifted (handle)
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (Value, encode, object, (.=))
import Data.Aeson.Parser (json)
import Data.ByteString (ByteString)
import Data.Conduit (ResourceT, ($$))
import Data.Conduit.Attoparsec (sinkParser)
import Network.HTTP.Types (status200, status400)
import Network.Wai (Application, Response, requestBody, responseLBS)
import Network.Wai.Handler.Warp (run)

app :: Application
app req = handle invalidJson $ do
    value <- requestBody req $$ sinkParser json
    newValue <- liftIO $ modValue value
    return $ responseLBS
        status200
        [("Content-Type", "application/json")]
        $ encode newValue

invalidJson :: SomeException -> IO Response
invalidJson ex = return $ responseLBS
    status400
    [("Content-Type", "application/json")]
    $ encode $ object [("message" .= show ex)]

-- Application-specific logic would go here.
modValue :: Value -> IO Value
modValue = return

defmain :: IO ()
defmain = run 3000 app
