module Node.StreamEx.Stream where

import Prelude

import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Foreign (Foreign)

class IsWritable a b where
   toWritable::a -> Writable b

data WritableEvent = CLOSE | DRAIN | ERROR | FINISH | PIPE | UNPIPE

data  Writable a = Writable {jsWritable::Foreign}


foreign import jscork ::Foreign -> Effect Unit
cork::forall a. Writable a -> Effect Unit
cork (Writable w) = jscork w.jsWritable

foreign import jsdestroy ::Foreign -> String -> Effect Unit
destroy::forall a. Writable a -> String -> Effect Unit
destroy (Writable w) errString = jsdestroy w.jsWritable errString

foreign import jsend ::forall a. Foreign -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end::forall a. Writable a  -> a -> String -> (Unit -> Effect Unit) -> Effect Unit
_end  (Writable w) chunk encoding callback = jsend w.jsWritable chunk encoding callback

end::forall a. Writable a  -> a -> Maybe String -> Maybe (Unit -> Effect Unit) -> Effect Unit
end w chunk mayEncoding mayCallback  = _end w chunk (maybe "" identity mayEncoding) (maybe (\_ -> pure unit) identity mayCallback)

foreign import jssetDefaultEncoding ::Foreign -> String -> Effect Unit
setDefaultEncoding::forall a. Writable a -> String -> Effect Unit
setDefaultEncoding (Writable w)  encoding = jssetDefaultEncoding w.jsWritable encoding

foreign import jsuncork ::Foreign -> Effect Unit
uncork::forall a. Writable a -> Effect Unit
uncork (Writable w) = jsuncork w.jsWritable

foreign import jswritable ::Foreign -> Effect Boolean
isWritable::forall a. Writable a -> Effect Boolean
isWritable (Writable w) = jswritable w.jsWritable