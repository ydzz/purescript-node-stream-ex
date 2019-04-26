module Node.StreamEx.Stream (
 newPassThrough
) where

import Effect (Effect)
import Node.StreamEx.Types (Duplex)


foreign import newPassThrough::forall a.Effect (Duplex a)