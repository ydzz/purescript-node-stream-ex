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
    onUnpipe
) where

import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Foreign (Foreign)
import Node.StreamEx.Types (class IsWritable, toWritable, unwrap,Readable)
import Prelude (Unit, identity, pure, unit, ($))

foreign import jsCork ::Foreign -> Effect Unit
cork::forall  w. IsWritable w  => w -> Effect Unit
cork w = jsCork (unwrap $ toWritable w)

foreign import jsDestroy ::Foreign -> String -> Effect Unit
destroy:: forall  w. IsWritable w  => w  -> String -> Effect Unit
destroy w errString = jsDestroy (unwrap $ toWritable w)  errString

foreign import jsEnd ::forall a. Foreign -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end::forall w a. IsWritable w => w -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end  w chunk encoding callback = jsEnd (unwrap $ toWritable w) chunk encoding callback

end::forall w a. IsWritable w => w -> a -> Maybe String -> Maybe (Unit -> Effect Unit) -> Effect Unit
end w chunk mayEncoding mayCallback  = _end w chunk (maybe "" identity mayEncoding) (maybe (\_ -> pure unit) identity mayCallback)

foreign import jsSetDefaultEncoding ::Foreign -> String -> Effect Unit
setDefaultEncoding::forall w. IsWritable w => w -> String -> Effect Unit
setDefaultEncoding w encoding = jsSetDefaultEncoding (unwrap $ toWritable w) encoding

foreign import jsUncork ::Foreign -> Effect Unit
uncork::forall w. IsWritable w => w -> Effect Unit
uncork w = jsUncork (unwrap $ toWritable w)


foreign import jsWritable ::Foreign -> Effect Boolean
isWritable::forall w. IsWritable w => w -> Effect Boolean
isWritable w = jsWritable (unwrap $ toWritable w)


foreign import jsWritableHighWaterMark ::Foreign -> Effect Number
writableHighWaterMark::forall w. IsWritable w => w -> Effect Number
writableHighWaterMark w = jsWritableHighWaterMark (unwrap $ toWritable w)



foreign import jsWritableLength ::Foreign -> Effect Number
writableLength::forall w. IsWritable w => w -> Effect Number
writableLength w = jsWritableLength (unwrap $ toWritable w)


foreign import jsWrite ::forall a. Foreign -> a -> String -> (Unit -> Effect Unit) -> Effect Boolean
_write::forall w a. IsWritable w => w -> a -> String -> (Unit -> Effect Unit) -> Effect Boolean
_write w chunk encoding callback = jsWrite (unwrap $ toWritable w) chunk encoding callback

write::forall w a. IsWritable w => w -> a -> Maybe String -> Maybe (Unit -> Effect Unit) -> Effect Boolean
write w chunk mayEncoding mayCallback  = _write w chunk (maybe "" identity mayEncoding) (maybe (\_ -> pure unit) identity mayCallback)


foreign import jsOnClose::Foreign ->  Effect Unit -> Effect Unit
onClose::forall w. IsWritable w => w ->  Effect Unit -> Effect Unit
onClose w callback = jsOnClose (unwrap $ toWritable w) callback

foreign import jsOnDrain::Foreign ->  Effect Unit -> Effect Unit
onDrain::forall w. IsWritable w => w ->  Effect Unit -> Effect Unit
onDrain w callback = jsOnDrain (unwrap $ toWritable w) callback

foreign import jsOnError::Foreign -> (String -> Effect Unit) -> Effect Unit
onError::forall w. IsWritable w => w -> (String -> Effect Unit) -> Effect Unit
onError w callback = jsOnError (unwrap $ toWritable w) callback

foreign import jsOnFinish::Foreign -> Effect Unit -> Effect Unit
onFinish::forall w. IsWritable w => w -> Effect Unit -> Effect Unit
onFinish w callback = jsOnFinish (unwrap $ toWritable w) callback

foreign import jsOnPipe::Foreign -> (Readable -> Effect Unit) -> Effect Unit
onPipe::forall w. IsWritable w => w -> (Readable -> Effect Unit) -> Effect Unit
onPipe w callback = jsOnPipe (unwrap $ toWritable w) callback

foreign import jsOnUnpipe::Foreign -> (Readable -> Effect Unit) -> Effect Unit
onUnpipe::forall w. IsWritable w => w -> (Readable -> Effect Unit) -> Effect Unit
onUnpipe w callback = jsOnUnpipe (unwrap $ toWritable w) callback