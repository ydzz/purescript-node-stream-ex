module Node.PullStream.Sink.Log (
  sinkLog
) where

import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Node.PullStream.Types (ReadFunc(..))

sinkLog::forall a. Show a => ReadFunc a -> Effect Unit
sinkLog (ReadFunc readFn) = do
  readFn false callbackFunc
 where
  callbackFunc::Boolean -> a -> Effect Unit
  callbackFunc end d = do
   if end then pure unit
          else do 
                logShow d
                readFn false callbackFunc