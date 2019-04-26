module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Node.Buffer (Buffer, toString)
import Node.Buffer as Buf
import Node.Encoding (Encoding(..))
import Node.SteamEx.Readable as SR
import Node.StreamEx.Stream as S
import Node.StreamEx.Types (Duplex, Readable, Writable, toWritable)
import Node.StreamEx.Writable as SW


foreign import createWriteStream ::forall a. String -> Effect (Writable a)

foreign import createReadStream ::forall a. String -> Effect  (Readable a)

foreign import jslog ::forall a. a -> Effect Unit

main :: Effect Unit
main = do
  testNewWritable


testNewWritable::Effect Unit
testNewWritable  = do
 newW::Writable Buffer <- SW.mkWritable _write
 SW.onFinish newW (log "onFinish")
 _ <- SW.write newW  (unsafePerformEffect $ Buf.fromString "abc\r\n" UTF8) Nothing Nothing
 SW.end newW (unsafePerformEffect $ Buf.fromString "end" UTF8) Nothing Nothing
 log "testNewWritable Func End"
 where
  _write::Buffer -> String -> Effect Unit -> Effect Unit
  _write d enc callback = do
    str <- (toString UTF8 d)
    log str
    callback
    pure unit

testReadable::Effect Unit
testReadable = do
  r <- createReadStream "test.txt"
  SR.onData r (\a ->  log a)
  newThrough::Duplex String <- S.newPassThrough
  SR.pipe r (toWritable newThrough) Nothing
  SW.onFinish (toWritable newThrough::Writable String) (log "newThrough onFinish")
  log "testReadable end"

testWritable::Effect Unit
testWritable = do
 (w::Writable String) <- createWriteStream "test.txt"
 _ <- SW.onFinish w (log "onFinish")
 _ <- SW.onError w (\str -> log str)
 _ <- SW.write w "one\r\n" Nothing Nothing
 _ <- SW.write w "two\r\n" Nothing Nothing
 _ <- SW.write w "three\r\n" Nothing Nothing
 _ <- SW.end w "write end" Nothing Nothing
 _ <- SW.write w "three\r\n" Nothing Nothing
 log "testWritable end"