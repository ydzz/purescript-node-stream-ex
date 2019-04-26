module Node.StreamEx.Types (
   Writable(..),
   Readable(..),
   Duplex(..),
   class IsWritable,
   toWritable,
   class IsReadable,
   toReadable
) where
import Prelude

import Data.Newtype (class Newtype)
import Foreign (Foreign)

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

-------------------Duplex-------------------------
newtype Duplex a = Duplex Foreign

instance duplexIsWritable :: IsWritable (Duplex a) a where
   toWritable::Duplex a -> Writable a
   toWritable (Duplex d) = Writable d

instance duplexIsReadable :: IsReadable (Duplex a) a where
   toReadable (Duplex d) = Readable d

