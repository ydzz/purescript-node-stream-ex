module Node.StreamEx.Types (
   Writable(..),
   Readable(..),
   wrap,
   unwrap,
   class IsWritable,
   toWritable
) where
import Prelude

import Foreign (Foreign)

newtype Writable = Writable Foreign

instance writableIsWritable :: IsWritable Writable where
   toWritable = identity

newtype Readable = Readable Foreign

wrap ::Foreign -> Writable
wrap f = Writable f

unwrap::Writable  -> Foreign
unwrap (Writable f) = f

class IsWritable w  where
   toWritable::w -> Writable

newtype Duplex = Duplex Foreign

instance duplexIsWritable :: IsWritable Duplex where
   toWritable::Duplex -> Writable
   toWritable (Duplex d) = Writable d

