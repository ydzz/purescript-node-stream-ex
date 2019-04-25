module Node.SteamEx.Readable where
import Node.StreamEx.Types
import Prelude (Unit, ($))

import Data.Newtype (unwrap)
import Effect (Effect)
import Foreign (Foreign)

foreign import jsDestroy ::Foreign -> String -> Effect Unit

destroy:: forall  r. IsReadable r  => r  -> String -> Effect Unit
destroy r errString = jsDestroy (unwrap $ toReadable r)  errString

foreign import jsIsPaused ::Foreign -> Effect Boolean
isPaused:: forall r. IsReadable r => r -> Effect Boolean
isPaused r = jsIsPaused　$ (unwrap $ toReadable r)

foreign import jsPause ::Foreign -> Effect Unit
pause:: forall r. IsReadable r => r -> Effect Unit
pause r = jsPause $ (unwrap $ toReadable r)
