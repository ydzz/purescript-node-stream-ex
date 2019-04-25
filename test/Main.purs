module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Node.SteamEx.Readable as SR
import Node.StreamEx.Stream as S
import Node.StreamEx.Types (Readable, Writable)
import Node.StreamEx.Writable as SW


foreign import createWriteStream ::String -> Effect Writable

foreign import createReadStream ::String -> Effect Readable

foreign import jslog ::forall a. a -> Effect Unit

main :: Effect Unit
main = do
  testReadable


testReadable::Effect Unit
testReadable = do
  r <- createReadStream "test.txt"
  SR.onData r (\a ->  log a)
  newThrough <- S.newPassThrough
  SR.pipe r newThrough Nothing
  SW.onFinish newThrough (log "newThrough onFinish")
  log "testReadable end"

testWritable::Effect Unit
testWritable = do
 w <- createWriteStream "test.txt"
 _ <- SW.onFinish w (do
                       log "onFinish"
                    )
 _ <- SW.onError w (\str -> log str)
 _ <- SW.write w "one\r\n" Nothing Nothing
 _ <- SW.write w "two\r\n" Nothing Nothing
 _ <- SW.write w "three\r\n" Nothing Nothing
 _ <- SW.end w "write end" Nothing Nothing
 _ <- SW.write w "three\r\n" Nothing Nothing
 log "testWritable end"