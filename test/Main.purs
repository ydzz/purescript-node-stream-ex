module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, notNull, null)
import Effect (Effect)
import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Node.Buffer (Buffer, toString)
import Node.Buffer as Buf
import Node.Encoding (Encoding(..))
import Node.SteamEx.Readable as SR
import Node.StreamEx.Stream as S
import Node.StreamEx.Types (Duplex, defNewWritableOptions, Readable, Writable, toWritable)
import Node.StreamEx.Writable as SW


foreign import createWriteStream ::forall a. String -> Effect (Writable a)

foreign import createReadStream ::forall a. String -> Effect  (Readable a)

foreign import jslog ::forall a. a -> Effect Unit

main :: Effect Unit
main = do
  testNewWritable


testNewWritable::Effect Unit
testNewWritable  = do
 newW::Writable Buffer <- SW.mkWritable (defNewWritableOptions {_write = _write,_destory= notNull _destory,_final = notNull _final})
 SW.onClose newW (log "onClose")
 SW.onError newW (log)
 _ <- SW.write newW  (unsafePerformEffect $ Buf.fromString "abc\r\n" UTF8) Nothing Nothing
 SW.end newW (unsafePerformEffect $ Buf.fromString "end" UTF8) Nothing Nothing
 SW.destroy newW (notNull "123")

 log "testNewWritable Func End"
 where
  _write::Buffer -> String -> (Nullable String -> Effect Unit) -> Effect Unit
  _write d enc callback = do
    str <- (toString UTF8 d)
    --log str
    callback null
  _destory:: String -> Effect Unit -> Effect Unit
  _destory errStr callback = do
    log "_destory"
    callback
  _final::(Nullable String -> Effect Unit) -> Effect Unit
  _final callback = do
   log "_final" 
   callback (notNull "_final error") 

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