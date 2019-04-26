module Node.StreamEx.PassThrough (
 mkPassThrough
) where

import Effect (Effect)
import Node.StreamEx.Types (Duplex)


foreign import mkPassThrough::forall a.Effect (Duplex a)