module Node.StreamEx.Writable (
    cork,
    destroy,
    end,
    setDefaultEncoding,
    uncork,
    isWritable,
    writableHighWaterMark,
    writableLength,
    write,
    onClose,
    onDrain,
    onError,
    onFinish,
    onPipe,
    onUnpipe,
    mkWritable
) where

import Data.Maybe (Maybe, maybe)
import Data.Newtype (unwrap)
import Data.Nullable (Nullable)
import Effect (Effect)
import Foreign (Foreign)
import Node.StreamEx.Types (Readable, Writable, NewWritableOptions)
import Prelude (Unit, identity, pure, unit)

foreign import jsCork ::Foreign -> Effect Unit
cork::forall a. Writable a -> Effect Unit
cork w = jsCork (unwrap w)

foreign import jsDestroy ::Foreign -> Nullable String -> Effect Unit
destroy:: forall a. Writable a   -> Nullable String -> Effect Unit
destroy w errString = jsDestroy (unwrap w)  errString

foreign import jsEnd ::forall a. Foreign -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end::forall a. Writable a -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end  w chunk encoding callback = jsEnd (unwrap  w) chunk encoding callback

end::forall a.Writable a -> a -> Maybe String -> Maybe (Unit -> Effect Unit) -> Effect Unit
end w chunk mayEncoding mayCallback  = _end w chunk (maybe "" identity mayEncoding) (maybe (\_ -> pure unit) identity mayCallback)

foreign import jsSetDefaultEncoding ::Foreign -> String -> Effect Unit
setDefaultEncoding::forall a. Writable a -> String -> Effect Unit
setDefaultEncoding w encoding = jsSetDefaultEncoding (unwrap w) encoding

foreign import jsUncork ::Foreign -> Effect Unit
uncork::forall a.Writable a -> Effect Unit
uncork w = jsUncork (unwrap w)


foreign import jsWritable ::Foreign -> Effect Boolean
isWritable::forall a.Writable a -> Effect Boolean
isWritable w = jsWritable (unwrap w)


foreign import jsWritableHighWaterMark ::Foreign -> Effect Number
writableHighWaterMark::forall a.Writable a -> Effect Number
writableHighWaterMark w = jsWritableHighWaterMark (unwrap w)



foreign import jsWritableLength ::Foreign -> Effect Number
writableLength::forall a. Writable a -> Effect Number
writableLength w = jsWritableLength (unwrap w)


foreign import jsWrite ::forall a. Foreign -> a -> String -> Effect Unit -> Effect Boolean
_write::forall a.  Writable a -> a -> String -> (Effect Unit) -> Effect Boolean
_write w chunk encoding callback = jsWrite (unwrap w) chunk encoding callback

write::forall a. Writable a -> a -> Maybe String -> Maybe (Effect Unit) -> Effect Boolean
write w chunk mayEncoding mayCallback  = _write w chunk (maybe "" identity mayEncoding) (maybe (pure unit) identity mayCallback)


foreign import jsOnClose::Foreign ->  Effect Unit -> Effect Unit
onClose::forall a. Writable a ->  Effect Unit -> Effect Unit
onClose w callback = jsOnClose (unwrap  w) callback

foreign import jsOnDrain::Foreign ->  Effect Unit -> Effect Unit
onDrain::forall a. Writable a ->  Effect Unit -> Effect Unit
onDrain w callback = jsOnDrain (unwrap w) callback

foreign import jsOnError::Foreign -> (String -> Effect Unit) -> Effect Unit
onError::forall a. Writable a -> (String -> Effect Unit) -> Effect Unit
onError w callback = jsOnError (unwrap w) callback

foreign import jsOnFinish::Foreign -> Effect Unit -> Effect Unit
onFinish::forall a.Writable a -> Effect Unit -> Effect Unit
onFinish w callback = jsOnFinish (unwrap w) callback


foreign import jsOnPipe::forall a. Foreign -> (Readable a -> Effect Unit) -> Effect Unit
onPipe::forall a. Writable a -> (Readable a -> Effect Unit) -> Effect Unit
onPipe w callback = jsOnPipe (unwrap w) callback

foreign import jsOnUnpipe::forall a. Foreign -> (Readable a -> Effect Unit) -> Effect Unit
onUnpipe::forall a. Writable a -> (Readable a -> Effect Unit) -> Effect Unit
onUnpipe w callback = jsOnUnpipe (unwrap w) callback

foreign import mkWritable::forall a. NewWritableOptions a -> Effect (Writable a)
