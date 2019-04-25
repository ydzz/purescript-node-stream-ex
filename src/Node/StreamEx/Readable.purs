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
    onError
) where
import Node.StreamEx.Types

import Data.Maybe (Maybe, maybe)
import Data.Newtype (unwrap)
import Effect (Effect)
import Foreign (Foreign)
import Prelude (Unit, identity, ($))

foreign import jsDestroy ::Foreign -> String -> Effect Unit

destroy:: forall  r. IsReadable r  => r  -> String -> Effect Unit
destroy r errString = jsDestroy (unwrap $ toReadable r)  errString

foreign import jsIsPaused ::Foreign -> Effect Boolean
isPaused:: forall r. IsReadable r => r -> Effect Boolean
isPaused r = jsIsPaused　$ (unwrap $ toReadable r)

foreign import jsPause ::Foreign -> Effect Unit
pause:: forall r. IsReadable r => r -> Effect Unit
pause r = jsPause $ (unwrap $ toReadable r)

foreign import jsPipe ::Foreign -> Foreign -> Boolean  -> Effect Unit
_pipe::forall r w.IsReadable r => IsWritable w => r -> w -> Boolean -> Effect Unit
_pipe r w isEnd = jsPipe (unwrap $ toReadable r) (unwrap $ toWritable w) isEnd

pipe::forall r w.IsReadable r => IsWritable w => r -> w -> Maybe Boolean -> Effect Unit
pipe r w mayIsEnd = _pipe r w (maybe true identity mayIsEnd)

foreign import jsRead::forall a. Foreign -> Number  -> Effect a
read::forall r a.IsReadable r => r -> Number -> Effect a
read r num = jsRead (unwrap $ toReadable r) num

foreign import jsReadable::Foreign -> Effect Boolean
isReadable::forall r.IsReadable r => r -> Effect Boolean
isReadable r = jsReadable (unwrap $ toReadable r) 

foreign import jsReadableHighWaterMark::Foreign -> Effect Number
readableHighWaterMark::forall r.IsReadable r => r -> Effect Number
readableHighWaterMark r = jsReadableHighWaterMark (unwrap $ toReadable r) 

foreign import jsReadableLength::Foreign -> Effect Number
readableLength::forall r.IsReadable r => r -> Effect Number
readableLength r = jsReadableLength (unwrap $ toReadable r)

foreign import jsResume::Foreign -> Effect Unit
resume::forall r.IsReadable r => r -> Effect Unit
resume r = jsResume (unwrap $ toReadable r)

foreign import jsSetEncoding::Foreign -> String -> Effect Unit
setEncoding::forall r.IsReadable r => r -> String -> Effect Unit
setEncoding r encoding = jsSetEncoding (unwrap $ toReadable r) encoding

foreign import jsUnpipe::Foreign -> Foreign -> Effect Unit
unpipe::forall r w.IsReadable r=> IsWritable w => r -> w -> Effect Unit
unpipe r w = jsUnpipe (unwrap $ toReadable r) (unwrap $ toWritable w)

foreign import jsUnshift::forall a. Foreign -> a -> Effect Unit
unshift::forall r a.IsReadable r => r -> a -> Effect Unit
unshift r chunk = jsUnshift (unwrap $ toReadable r) chunk

foreign import jsOnClose::Foreign -> Effect Unit -> Effect Unit
onClose::forall r. IsReadable r => r -> Effect Unit -> Effect Unit
onClose r callback = jsOnClose (unwrap $ toReadable r) callback

foreign import jsOnData::forall a. Foreign -> (a -> Effect Unit) -> Effect Unit
onData :: forall r a. IsReadable r => r -> (a -> Effect Unit) -> Effect Unit
onData r callback = jsOnData (unwrap $ toReadable r) callback

foreign import jsOnEnd::Foreign -> Effect Unit -> Effect Unit
onEnd::forall r.IsReadable r => r -> Effect Unit -> Effect Unit
onEnd r callback  = jsOnEnd (unwrap $ toReadable r) callback

foreign import jsOnError::Foreign -> (String -> Effect Unit) -> Effect Unit
onError::forall r.IsReadable r => r -> (String -> Effect Unit) -> Effect Unit
onError r callback = jsOnError (unwrap $ toReadable r) callback

foreign import jsOnReadable::Foreign -> Effect Unit -> Effect Unit
onReadable::forall r.IsReadable r => r -> Effect Unit -> Effect Unit
onReadable r callback = jsOnReadable (unwrap $ toReadable r) callback