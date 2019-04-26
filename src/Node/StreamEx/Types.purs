module Node.StreamEx.Types (
   Writable(..),
   Readable(..),
   Duplex(..),
   class IsWritable,
   toWritable,
   class IsReadable,
   toReadable,
   NewWritableOptions(..),
   NewReadableOptions(..),
   NewDuplexOptions(..),
   NewTransformOptions(..),
   defNewWritableOptions,
   defNewReadableOptions,
   defNewDuplexOptions,
   defNewTransformOptions,
   Transform(..)
) where
import Data.Nullable
import Data.Newtype (class Newtype)
import Effect (Effect)
import Foreign (Foreign)
import Prelude (Unit, identity, pure,($))
import Unsafe.Coerce (unsafeCoerce)

-------------------Writable-----------------------
newtype Writable a = Writable Foreign

class IsWritable w a where
   toWritable::w -> Writable a

instance writableIsWritable :: IsWritable (Writable a) a where
  toWritable::Writable a -> Writable a
  toWritable w = w

instance writableNewtype :: Newtype (Writable a) Foreign where
   wrap   = Writable
   unwrap (Writable w) = w

type NewWritableOptions a =  {
   highWaterMark   ::Nullable Int,
   decodeStrings   ::Nullable Boolean,
   defaultEncoding ::Nullable String,
   objectMode      ::Nullable Boolean,
   emitClose       ::Nullable Boolean,
   _write          ::(a -> String -> (Nullable String -> Effect Unit) -> Effect Unit),
   _destory        ::Nullable (String -> Effect Unit -> Effect Unit),
   _final          ::Nullable ((Nullable String -> Effect Unit) -> Effect Unit)
}

defNewWritableOptions ::forall a. NewWritableOptions a
defNewWritableOptions =  {
     highWaterMark:null,
     decodeStrings:null,
     defaultEncoding:null,
     objectMode:null,
     emitClose:null,
     _write:(\_ _ cb -> cb null),
     _destory:null,
     _final:null
}
-------------------Readable-----------------------
newtype Readable a = Readable Foreign

class IsReadable r a where
  toReadable::r -> Readable a

instance readableIsReadable :: IsReadable (Readable a) a where
   toReadable::Readable a -> Readable a
   toReadable = identity

instance readableNewtype :: Newtype (Readable a) Foreign where
   wrap   = Readable
   unwrap::Readable a -> Foreign
   unwrap (Readable w) = w

type NewReadableOptions a = {
   highWaterMark::Nullable Int,
   encoding     ::Nullable String,
   objectMode   ::Nullable Boolean,
   _read        ::Int -> (Nullable String -> Effect Unit) -> Effect Unit,
   _destory     ::Nullable (a -> Effect Unit -> Effect Unit)
}

defNewReadableOptions::forall a. NewReadableOptions a
defNewReadableOptions = {
   highWaterMark : null,
   encoding      : null,
   objectMode    : null,
   _read         : (\n ns -> pure $ unsafeCoerce ""),
   _destory      :null
}
-------------------Duplex-------------------------
newtype Duplex a = Duplex Foreign

instance duplexIsWritable :: IsWritable (Duplex a) a where
   toWritable::Duplex a -> Writable a
   toWritable (Duplex d) = Writable d

instance duplexIsReadable :: IsReadable (Duplex a) a where
   toReadable (Duplex d) = Readable d

type NewDuplexOptions a = {
  allowHalfOpen::Nullable Boolean,
  objectMode::Nullable Boolean,
  readableObjectMode::Nullable Boolean,
  writableObjectMode::Nullable Boolean,
  readableHighWaterMark::Nullable Int,
  writableHighWaterMark::Nullable Int,
  highWaterMark::Nullable Int,
  _read::Int -> (Nullable a -> Effect Unit) -> Effect Unit,
  _write::(a -> String -> (Nullable String -> Effect Unit) -> Effect Unit)
}

defNewDuplexOptions::forall a. NewDuplexOptions a
defNewDuplexOptions = {
  allowHalfOpen:null,
  readableObjectMode:null,
  writableObjectMode:null,
  objectMode:null,
  readableHighWaterMark:null,
  writableHighWaterMark:null,
  highWaterMark:null,
  _read: (\n ns -> pure $ unsafeCoerce ""),
  _write:(\_ _ cb -> cb null)
}

-------------------Transform-------------------------
newtype Transform a = Transform Foreign

instance transformIsWritable :: IsWritable (Transform a) a where
   toWritable::Transform a -> Writable a
   toWritable (Transform d) = Writable d

instance transformIsReadable :: IsReadable (Transform a) a where
   toReadable (Transform d) = Readable d

type NewTransformOptions a =  { 
   _transform:: a -> String -> (Nullable a -> Effect Unit) -> (Nullable String -> Effect Unit) -> Effect Unit,
   _flush    ::Nullable ((Nullable a -> Effect Unit) -> (Nullable String -> Effect Unit) -> Effect Unit)
}
defNewTransformOptions::forall a. NewTransformOptions a
defNewTransformOptions = {
   _transform:(\a enc pushFunc callback -> callback null),
   _flush:null
}