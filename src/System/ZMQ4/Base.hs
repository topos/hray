{-# LINE 1 "Base.hsc" #-}
{-# LANGUAGE CPP                      #-}
{-# LINE 2 "Base.hsc" #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module System.ZMQ4.Base where

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Control.Applicative


{-# LINE 12 "Base.hsc" #-}


{-# LINE 16 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Message

newtype ZMQMsg = ZMQMsg
  { content :: Ptr ()
  } deriving (Eq, Ord)

instance Storable ZMQMsg where
    alignment _        = 1
{-# LINE 26 "Base.hsc" #-}
    sizeOf    _        = (32)
{-# LINE 27 "Base.hsc" #-}
    peek p             = ZMQMsg <$> (\hsc_ptr -> peekByteOff hsc_ptr 0) p
{-# LINE 28 "Base.hsc" #-}
    poke p (ZMQMsg c)  = (\hsc_ptr -> pokeByteOff hsc_ptr 0) p c
{-# LINE 29 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Poll

data ZMQPoll = ZMQPoll
    { pSocket  :: {-# UNPACK #-} !ZMQSocket
    , pFd      :: {-# UNPACK #-} !CInt
    , pEvents  :: {-# UNPACK #-} !CShort
    , pRevents :: {-# UNPACK #-} !CShort
    }

instance Storable ZMQPoll where
    alignment _ = 8
{-# LINE 42 "Base.hsc" #-}
    sizeOf    _ = (16)
{-# LINE 43 "Base.hsc" #-}
    peek p = do
        s  <- (\hsc_ptr -> peekByteOff hsc_ptr 0) p
{-# LINE 45 "Base.hsc" #-}
        f  <- (\hsc_ptr -> peekByteOff hsc_ptr 8) p
{-# LINE 46 "Base.hsc" #-}
        e  <- (\hsc_ptr -> peekByteOff hsc_ptr 12) p
{-# LINE 47 "Base.hsc" #-}
        re <- (\hsc_ptr -> peekByteOff hsc_ptr 14) p
{-# LINE 48 "Base.hsc" #-}
        return $ ZMQPoll s f e re
    poke p (ZMQPoll s f e re) = do
        (\hsc_ptr -> pokeByteOff hsc_ptr 0) p s
{-# LINE 51 "Base.hsc" #-}
        (\hsc_ptr -> pokeByteOff hsc_ptr 8) p f
{-# LINE 52 "Base.hsc" #-}
        (\hsc_ptr -> pokeByteOff hsc_ptr 12) p e
{-# LINE 53 "Base.hsc" #-}
        (\hsc_ptr -> pokeByteOff hsc_ptr 14) p re
{-# LINE 54 "Base.hsc" #-}

type ZMQMsgPtr  = Ptr ZMQMsg
type ZMQCtx     = Ptr ()
type ZMQSocket  = Ptr ()
type ZMQPollPtr = Ptr ZMQPoll


{-# LINE 61 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Socket Types

newtype ZMQSocketType = ZMQSocketType
  { typeVal :: CInt
  } deriving (Eq, Ord)

pair      :: ZMQSocketType
pair      = ZMQSocketType 0
pub       :: ZMQSocketType
pub       = ZMQSocketType 1
sub       :: ZMQSocketType
sub       = ZMQSocketType 2
xpub      :: ZMQSocketType
xpub      = ZMQSocketType 9
xsub      :: ZMQSocketType
xsub      = ZMQSocketType 10
request   :: ZMQSocketType
request   = ZMQSocketType 3
response  :: ZMQSocketType
response  = ZMQSocketType 4
dealer    :: ZMQSocketType
dealer    = ZMQSocketType 5
router    :: ZMQSocketType
router    = ZMQSocketType 6
pull      :: ZMQSocketType
pull      = ZMQSocketType 7
push      :: ZMQSocketType
push      = ZMQSocketType 8
stream    :: ZMQSocketType
stream    = ZMQSocketType 11

{-# LINE 83 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Socket Options

newtype ZMQOption = ZMQOption
  { optVal :: CInt
  } deriving (Eq, Ord)

affinity              :: ZMQOption
affinity              = ZMQOption 4
backlog               :: ZMQOption
backlog               = ZMQOption 19
conflate              :: ZMQOption
conflate              = ZMQOption 54
curve                 :: ZMQOption
curve                 = ZMQOption 2
curvePublicKey        :: ZMQOption
curvePublicKey        = ZMQOption 48
curveSecretKey        :: ZMQOption
curveSecretKey        = ZMQOption 49
curveServer           :: ZMQOption
curveServer           = ZMQOption 47
curveServerKey        :: ZMQOption
curveServerKey        = ZMQOption 50
delayAttachOnConnect  :: ZMQOption
delayAttachOnConnect  = ZMQOption 39
events                :: ZMQOption
events                = ZMQOption 15
filedesc              :: ZMQOption
filedesc              = ZMQOption 14
identity              :: ZMQOption
identity              = ZMQOption 5
immediate             :: ZMQOption
immediate             = ZMQOption 39
ipv4Only              :: ZMQOption
ipv4Only              = ZMQOption 31
ipv6                  :: ZMQOption
ipv6                  = ZMQOption 42
lastEndpoint          :: ZMQOption
lastEndpoint          = ZMQOption 32
linger                :: ZMQOption
linger                = ZMQOption 17
maxMessageSize        :: ZMQOption
maxMessageSize        = ZMQOption 22
mcastHops             :: ZMQOption
mcastHops             = ZMQOption 25
mechanism             :: ZMQOption
mechanism             = ZMQOption 43
null                  :: ZMQOption
null                  = ZMQOption 0
plain                 :: ZMQOption
plain                 = ZMQOption 1
plainPassword         :: ZMQOption
plainPassword         = ZMQOption 46
plainServer           :: ZMQOption
plainServer           = ZMQOption 44
plainUserName         :: ZMQOption
plainUserName         = ZMQOption 45
probeRouter           :: ZMQOption
probeRouter           = ZMQOption 51
rate                  :: ZMQOption
rate                  = ZMQOption 8
receiveBuf            :: ZMQOption
receiveBuf            = ZMQOption 12
receiveHighWM         :: ZMQOption
receiveHighWM         = ZMQOption 24
receiveMore           :: ZMQOption
receiveMore           = ZMQOption 13
receiveTimeout        :: ZMQOption
receiveTimeout        = ZMQOption 27
reconnectIVL          :: ZMQOption
reconnectIVL          = ZMQOption 18
reconnectIVLMax       :: ZMQOption
reconnectIVLMax       = ZMQOption 21
recoveryIVL           :: ZMQOption
recoveryIVL           = ZMQOption 9
reqCorrelate          :: ZMQOption
reqCorrelate          = ZMQOption 52
reqRelaxed            :: ZMQOption
reqRelaxed            = ZMQOption 53
routerMandatory       :: ZMQOption
routerMandatory       = ZMQOption 33
sendBuf               :: ZMQOption
sendBuf               = ZMQOption 11
sendHighWM            :: ZMQOption
sendHighWM            = ZMQOption 23
sendTimeout           :: ZMQOption
sendTimeout           = ZMQOption 28
subscribe             :: ZMQOption
subscribe             = ZMQOption 6
tcpAcceptFilter       :: ZMQOption
tcpAcceptFilter       = ZMQOption 38
tcpKeepAlive          :: ZMQOption
tcpKeepAlive          = ZMQOption 34
tcpKeepAliveCount     :: ZMQOption
tcpKeepAliveCount     = ZMQOption 35
tcpKeepAliveIdle      :: ZMQOption
tcpKeepAliveIdle      = ZMQOption 36
tcpKeepAliveInterval  :: ZMQOption
tcpKeepAliveInterval  = ZMQOption 37
unsubscribe           :: ZMQOption
unsubscribe           = ZMQOption 7
xpubVerbose           :: ZMQOption
xpubVerbose           = ZMQOption 40
zapDomain             :: ZMQOption
zapDomain             = ZMQOption 55

{-# LINE 142 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Context Options

newtype ZMQCtxOption = ZMQCtxOption
  { ctxOptVal :: CInt
  } deriving (Eq, Ord)

_ioThreads  :: ZMQCtxOption
_ioThreads  = ZMQCtxOption 1
_maxSockets  :: ZMQCtxOption
_maxSockets  = ZMQCtxOption 2

{-# LINE 154 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Event Type

newtype ZMQEventType = ZMQEventType
  { eventTypeVal :: Word16
  } deriving (Eq, Ord, Show)

connected       :: ZMQEventType
connected       = ZMQEventType 1
connectDelayed  :: ZMQEventType
connectDelayed  = ZMQEventType 2
connectRetried  :: ZMQEventType
connectRetried  = ZMQEventType 4
listening       :: ZMQEventType
listening       = ZMQEventType 8
bindFailed      :: ZMQEventType
bindFailed      = ZMQEventType 16
accepted        :: ZMQEventType
accepted        = ZMQEventType 32
acceptFailed    :: ZMQEventType
acceptFailed    = ZMQEventType 64
closed          :: ZMQEventType
closed          = ZMQEventType 128
closeFailed     :: ZMQEventType
closeFailed     = ZMQEventType 256
disconnected    :: ZMQEventType
disconnected    = ZMQEventType 512
allEvents       :: ZMQEventType
allEvents       = ZMQEventType 2047
monitorStopped  :: ZMQEventType
monitorStopped  = ZMQEventType 1024

{-# LINE 176 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Event

data ZMQEvent = ZMQEvent
  { zeEvent :: {-# UNPACK #-} !ZMQEventType
  , zeValue :: {-# UNPACK #-} !Int32
  }

instance Storable ZMQEvent where
    alignment _ = 4
{-# LINE 187 "Base.hsc" #-}
    sizeOf    _ = (8)
{-# LINE 188 "Base.hsc" #-}
    peek e = ZMQEvent
        <$> (ZMQEventType <$> (\hsc_ptr -> peekByteOff hsc_ptr 0) e)
{-# LINE 190 "Base.hsc" #-}
        <*> (\hsc_ptr -> peekByteOff hsc_ptr 4) e
{-# LINE 191 "Base.hsc" #-}
    poke e (ZMQEvent (ZMQEventType a) b) = do
        (\hsc_ptr -> pokeByteOff hsc_ptr 0) e a
{-# LINE 193 "Base.hsc" #-}
        (\hsc_ptr -> pokeByteOff hsc_ptr 4) e b
{-# LINE 194 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Security Mechanism

newtype ZMQSecMechanism = ZMQSecMechanism
  { secMechanism :: Int
  } deriving (Eq, Ord, Show)

secNull   :: ZMQSecMechanism
secNull   = ZMQSecMechanism 0
secPlain  :: ZMQSecMechanism
secPlain  = ZMQSecMechanism 1
secCurve  :: ZMQSecMechanism
secCurve  = ZMQSecMechanism 2

{-# LINE 207 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Message Options

newtype ZMQMsgOption = ZMQMsgOption
  { msgOptVal :: CInt
  } deriving (Eq, Ord)

more  :: ZMQMsgOption
more  = ZMQMsgOption 1

{-# LINE 218 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Flags

newtype ZMQFlag = ZMQFlag
  { flagVal :: CInt
  } deriving (Eq, Ord)

dontWait  :: ZMQFlag
dontWait  = ZMQFlag 1
sndMore   :: ZMQFlag
sndMore   = ZMQFlag 2

{-# LINE 230 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- Poll Events

newtype ZMQPollEvent = ZMQPollEvent
  { pollVal :: CShort
  } deriving (Eq, Ord)

pollIn     :: ZMQPollEvent
pollIn     = ZMQPollEvent 1
pollOut    :: ZMQPollEvent
pollOut    = ZMQPollEvent 2
pollerr    :: ZMQPollEvent
pollerr    = ZMQPollEvent 4

{-# LINE 243 "Base.hsc" #-}

-----------------------------------------------------------------------------
-- function declarations

-- general initialization

foreign import ccall unsafe "zmq.h zmq_version"
    c_zmq_version :: Ptr CInt -> Ptr CInt -> Ptr CInt -> IO ()

foreign import ccall unsafe "zmq.h zmq_ctx_new"
    c_zmq_ctx_new :: IO ZMQCtx

foreign import ccall unsafe "zmq.h zmq_ctx_shutdown"
    c_zmq_ctx_shutdown :: ZMQCtx -> IO CInt

foreign import ccall unsafe "zmq.h zmq_ctx_term"
    c_zmq_ctx_term :: ZMQCtx -> IO CInt

foreign import ccall unsafe "zmq.h zmq_ctx_get"
    c_zmq_ctx_get :: ZMQCtx -> CInt -> IO CInt

foreign import ccall unsafe "zmq.h zmq_ctx_set"
    c_zmq_ctx_set :: ZMQCtx -> CInt -> CInt -> IO CInt

-- zmq_msg_t related

foreign import ccall unsafe "zmq.h zmq_msg_init"
    c_zmq_msg_init :: ZMQMsgPtr -> IO CInt

foreign import ccall unsafe "zmq.h zmq_msg_init_size"
    c_zmq_msg_init_size :: ZMQMsgPtr -> CSize -> IO CInt

foreign import ccall unsafe "zmq.h zmq_msg_close"
    c_zmq_msg_close :: ZMQMsgPtr -> IO CInt

foreign import ccall unsafe "zmq.h zmq_msg_data"
    c_zmq_msg_data :: ZMQMsgPtr -> IO (Ptr a)

foreign import ccall unsafe "zmq.h zmq_msg_size"
    c_zmq_msg_size :: ZMQMsgPtr -> IO CSize

foreign import ccall unsafe "zmq.h zmq_msg_get"
    c_zmq_msg_get :: ZMQMsgPtr -> CInt -> IO CInt

foreign import ccall unsafe "zmq.h zmq_msg_set"
    c_zmq_msg_set :: ZMQMsgPtr -> CInt -> CInt -> IO CInt

-- socket

foreign import ccall unsafe "zmq.h zmq_socket"
    c_zmq_socket :: ZMQCtx -> CInt -> IO ZMQSocket

foreign import ccall unsafe "zmq.h zmq_close"
    c_zmq_close :: ZMQSocket -> IO CInt

foreign import ccall unsafe "zmq.h zmq_setsockopt"
    c_zmq_setsockopt :: ZMQSocket
                     -> CInt   -- option
                     -> Ptr () -- option value
                     -> CSize  -- option value size
                     -> IO CInt

foreign import ccall unsafe "zmq.h zmq_getsockopt"
    c_zmq_getsockopt :: ZMQSocket
                     -> CInt       -- option
                     -> Ptr ()     -- option value
                     -> Ptr CSize  -- option value size ptr
                     -> IO CInt

foreign import ccall unsafe "zmq.h zmq_bind"
    c_zmq_bind :: ZMQSocket -> CString -> IO CInt

foreign import ccall unsafe "zmq.h zmq_unbind"
    c_zmq_unbind :: ZMQSocket -> CString -> IO CInt

foreign import ccall unsafe "zmq.h zmq_connect"
    c_zmq_connect :: ZMQSocket -> CString -> IO CInt

foreign import ccall unsafe "zmq.h zmq_sendmsg"
    c_zmq_sendmsg :: ZMQSocket -> ZMQMsgPtr -> CInt -> IO CInt

foreign import ccall unsafe "zmq.h zmq_recvmsg"
    c_zmq_recvmsg :: ZMQSocket -> ZMQMsgPtr -> CInt -> IO CInt

foreign import ccall unsafe "zmq.h zmq_socket_monitor"
    c_zmq_socket_monitor :: ZMQSocket -> CString -> CInt -> IO CInt

-- errors

foreign import ccall unsafe "zmq.h zmq_errno"
    c_zmq_errno :: IO CInt

foreign import ccall unsafe "zmq.h zmq_strerror"
    c_zmq_strerror :: CInt -> IO CString

-- proxy

foreign import ccall safe "zmq.h zmq_proxy"
    c_zmq_proxy :: ZMQSocket -> ZMQSocket -> ZMQSocket -> IO CInt

-- poll

foreign import ccall safe "zmq.h zmq_poll"
    c_zmq_poll :: ZMQPollPtr -> CInt -> CLong -> IO CInt

-- Z85 encode/decode

foreign import ccall unsafe "zmq.h zmq_z85_encode"
    c_zmq_z85_encode :: CString -> Ptr Word8 -> CSize -> IO CString

foreign import ccall unsafe "zmq.h zmq_z85_decode"
    c_zmq_z85_decode :: Ptr Word8 -> CString -> IO (Ptr Word8)

-- curve crypto

foreign import ccall unsafe "zmq.h zmq_curve_keypair"
    c_zmq_curve_keypair :: CString -> CString -> IO CInt

