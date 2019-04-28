module Node.PullStream.Types where
import Prelude
import Effect (Effect)

newtype ReadFunc a = ReadFunc (Boolean -> (Boolean -> a -> Effect Unit) -> Effect Unit)
