module Node.StreamEx.Duplex (
 mkDuplex
) where

import Effect (Effect)
import Node.StreamEx.Types (Duplex, NewDuplexOptions)

foreign import mkDuplex::forall a. NewDuplexOptions a -> Effect (Duplex a)