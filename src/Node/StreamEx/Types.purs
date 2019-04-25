module Node.StreamEx.Types (
   Writable(..),
   Readable(..),
   class IsWritable,
   toWritable,
   class IsReadable,
   toReadable
) where
import Prelude

import Data.Newtype (class Newtype)
import Foreign (Foreign)


-------------------Writable-----------------------
newtype Writable = Writable Foreign

class IsWritable w  where
   toWritable::w -> Writable

instance writableIsWritable :: IsWritable Writable where
   toWritable = identity

instance writableNewtype :: Newtype Writable Foreign where
   wrap   = Writable
   unwrap (Writable w) = w

-------------------Readable-----------------------
newtype Readable = Readable Foreign

class IsReadable r where
  toReadable::r -> Readable

instance readableIsReadable :: IsReadable Readable where
   toReadable = identity

instance readableNewtype :: Newtype Readable Foreign where
   wrap   = Readable
   unwrap (Readable w) = w

-------------------Duplex-------------------------
newtype Duplex = Duplex Foreign

instance duplexIsWritable :: IsWritable Duplex where
   toWritable::Duplex -> Writable
   toWritable (Duplex d) = Writable d

instance duplexIsReadable :: IsReadable Duplex where
   toReadable (Duplex d) = Readable d

