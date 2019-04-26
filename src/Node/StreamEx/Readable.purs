module Node.SteamEx.Readable (
    destroy,
    isPaused,
    pause,
    pipe,
    read,
    isReadable,
    readableHighWaterMark,
    readableLength,
    resume,
    setEncoding,
    unpipe,
    unshift,
    onClose,
    onEnd,
    onData,
    onReadable,
    onError,
    mkReadable
) where
import Node.StreamEx.Types

import Data.Maybe (Maybe, maybe)
import Data.Newtype (unwrap)
import Effect (Effect)
import Foreign (Foreign)
import Prelude (Unit, identity, ($))

foreign import jsDestroy ::Foreign -> String -> Effect Unit

destroy:: forall a.Readable a -> String -> Effect Unit
destroy r errString = jsDestroy (unwrap r)  errString

foreign import jsIsPaused ::Foreign -> Effect Boolean
isPaused:: forall a. Readable a -> Effect Boolean
isPaused r = jsIsPaused　$ (unwrap r)

foreign import jsPause ::Foreign -> Effect Unit
pause:: forall a. Readable a -> Effect Unit
pause r = jsPause $ (unwrap r)

foreign import jsPipe ::Foreign -> Foreign -> Boolean  -> Effect Unit
_pipe::Foreign -> Foreign -> Boolean -> Effect Unit
_pipe r w isEnd = jsPipe r w isEnd

pipe::forall a.Readable a -> Writable a -> Maybe Boolean -> Effect Unit
pipe r w mayIsEnd = _pipe (unwrap r) (unwrap w) (maybe true identity mayIsEnd)

foreign import jsRead::forall a. Foreign -> Number  -> Effect a
read::forall a.Readable a -> Number -> Effect a
read r num = jsRead (unwrap r) num

foreign import jsReadable::Foreign -> Effect Boolean
isReadable::forall a.Readable a -> Effect Boolean
isReadable r = jsReadable (unwrap r) 

foreign import jsReadableHighWaterMark::Foreign -> Effect Number
readableHighWaterMark::forall a.Readable a -> Effect Number
readableHighWaterMark r = jsReadableHighWaterMark (unwrap r) 

foreign import jsReadableLength::Foreign -> Effect Number
readableLength::forall a.Readable a-> Effect Number
readableLength r = jsReadableLength (unwrap r)

foreign import jsResume::Foreign -> Effect Unit
resume::forall a.Readable a -> Effect Unit
resume r = jsResume (unwrap r)

foreign import jsSetEncoding::Foreign -> String -> Effect Unit
setEncoding::forall a.Readable a -> String -> Effect Unit
setEncoding r encoding = jsSetEncoding (unwrap r) encoding

foreign import jsUnpipe::Foreign -> Foreign -> Effect Unit
unpipe::forall a. Readable a -> Writable a -> Effect Unit
unpipe r w = jsUnpipe (unwrap  r) (unwrap w)

foreign import jsUnshift::forall a. Foreign -> a -> Effect Unit
unshift::forall a.Readable a -> a -> Effect Unit
unshift r chunk = jsUnshift (unwrap r) chunk

foreign import jsOnClose::Foreign -> Effect Unit -> Effect Unit
onClose::forall a. Readable a -> Effect Unit -> Effect Unit
onClose r callback = jsOnClose (unwrap r) callback

foreign import jsOnData::forall a. Foreign -> (a -> Effect Unit) -> Effect Unit
onData :: forall a. Readable a -> (a -> Effect Unit) -> Effect Unit
onData r callback = jsOnData (unwrap r) callback

foreign import jsOnEnd::Foreign -> Effect Unit -> Effect Unit
onEnd::forall a.Readable a -> Effect Unit -> Effect Unit
onEnd r callback  = jsOnEnd (unwrap r) callback

foreign import jsOnError::Foreign -> (String -> Effect Unit) -> Effect Unit
onError::forall a.Readable a -> (String -> Effect Unit) -> Effect Unit
onError r callback = jsOnError (unwrap r) callback

foreign import jsOnReadable::Foreign -> Effect Unit -> Effect Unit
onReadable::forall a.Readable a -> Effect Unit -> Effect Unit
onReadable r callback = jsOnReadable (unwrap r) callback

foreign import mkReadable::forall a. NewReadableOptions a ->　Effect (Readable a)