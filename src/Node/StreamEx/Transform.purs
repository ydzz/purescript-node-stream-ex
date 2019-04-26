module Node.StreamEx.Transform (
 mkTransform,
 onFinish,
 onEnd
) where

import Prelude

import Effect (Effect)
import Node.SteamEx.Readable as SR
import Node.StreamEx.Types (NewTransformOptions, Readable, Transform, Writable, toReadable, toWritable)
import Node.StreamEx.Writable as SW


foreign import mkTransform::forall a. NewTransformOptions a -> Effect (Transform a)

onFinish::forall a.Transform a -> Effect Unit -> Effect Unit
onFinish t callback = SW.onFinish (toWritable t::Writable a) callback

onEnd::forall a.Transform a -> Effect Unit -> Effect Unit
onEnd t callback  = SR.onEnd (toReadable t::Readable a) callback