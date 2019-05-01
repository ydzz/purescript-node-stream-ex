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
import Node.PullStream.Sink.Log as Sink
import Node.PullStream.Source.Count as SC
import Node.SteamEx.Readable as SR
import Node.StreamEx.Duplex as SD
import Node.StreamEx.PassThrough as S
import Node.StreamEx.Transform as ST
import Node.StreamEx.Types (Duplex, Readable, Writable, defNewDuplexOptions, defNewReadableOptions, defNewTransformOptions, defNewWritableOptions, toReadable, toWritable)
import Node.StreamEx.Writable as SW


foreign import createWriteStream ::forall a. String -> Effect (Writable a)

foreign import createReadStream ::forall a. String -> Effect  (Readable a)

foreign import randomInt ::Effect Int

foreign import jslog ::forall a. a -> Effect Unit

main :: Effect Unit
main = do
  testWritable

testPullStream::Effect Unit
testPullStream = do
  src <- SC.count 5
  --src <- SC.count 100000 会栈溢出pullStream的实现方式是有些问题的
  Sink.sinkLog src
  pure unit

testNewTransform::Effect Unit
testNewTransform = do
 (fw::Writable String) <- createWriteStream "test.txt"
 newTrans <- ST.mkTransform defNewTransformOptions {_transform = _trans,_flush = notNull _flush}
 _ <- SR.pipe (toReadable newTrans::Readable String) fw Nothing
 _ <- SW.write (toWritable newTrans) "123" Nothing Nothing
 _ <- SW.end  (toWritable newTrans) "end" Nothing Nothing
 ST.onFinish newTrans (log "onFinish")
 ST.onEnd newTrans (log "onEnd")
 log "testNewTransform Func End"
 where
  _trans::String -> String -> (Nullable String -> Effect Unit) -> (Nullable String -> Effect Unit) -> Effect Unit
  _trans d enc pushFunc callback = do
   log  $ "-------enter---_trans-----" <> d
   pushFunc $ notNull (d <> "\r\n")
   callback null
  _flush::(Nullable String -> Effect Unit) -> (Nullable String -> Effect Unit) -> Effect Unit
  _flush pushFunc callback = do
   log "run _flush"
   pushFunc (notNull "************************")
   callback null
    
testNewDuplex::Effect Unit
testNewDuplex = do
  pDuplex::Duplex String <-  S.mkPassThrough
  newDuplex::Duplex String <- SD.mkDuplex  defNewDuplexOptions {_write = _write,_read = _read}
  _ <- SR.pipe (toReadable newDuplex::Readable String) (toWritable pDuplex) Nothing
  _ <- SW.write (toWritable newDuplex) "123" Nothing Nothing
  SR.setEncoding (toReadable newDuplex::Readable String) "utf8"
  SR.onData (toReadable newDuplex::Readable String) (\str -> log str)
  log "testNewDuplex Func End"
 where
  _write::String -> String -> (Nullable String -> Effect Unit) -> Effect Unit
  _write d enc callback = do
    log  $ "------Duplex write " <> d <> "--------"
    callback null
  _read::Int -> (Nullable String -> Effect Unit) -> Effect Unit
  _read n pushFunc = do
    num <- randomInt
    log $ "----------Duplex read "<> show num <> "---------"
    if (num > 90) then pushFunc null 
                  else pushFunc (notNull $ show num)

testNewReadable::Effect Unit
testNewReadable = do
 w::Duplex String <- S.mkPassThrough
 let (pw::Writable String) = toWritable w
 newR::Readable String <- SR.mkReadable defNewReadableOptions {_read = _read}
 SR.onData newR (\r -> log $ r <> " SR OnData")
 SW.onPipe pw (\r -> log "pipe")
 _ <- SR.pipe  newR pw Nothing
 _ <- SW.write pw "==============================" Nothing Nothing
 log "testNewReadable Func End"
 where
  _read::Int -> (Nullable String -> Effect Unit) -> Effect Unit
  _read n pushFunc = do
    num <- randomInt
    log $ "read---" <> show num
    if (num > 90) then pushFunc null 
                  else pushFunc (notNull $ show num)
    pure unit

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
  newThrough::Duplex String <- S.mkPassThrough
  SR.pipe r (toWritable newThrough) Nothing
  SW.onFinish (toWritable newThrough::Writable String) (log "newThrough onFinish")
  log "testReadable end"

testWritable::Effect Unit
testWritable = do
 (w::Writable String) <- createWriteStream "test.txt"
 _ <- SW.onFinish w (log "onFinish")
 _ <- SW.onError w (\str -> log str)
 _ <- SW.write w "one\r\n" Nothing (Just (log "???????????????"))
 _ <- SW.write w "two\r\n" Nothing Nothing
 _ <- SW.write w "three\r\n" Nothing Nothing
 _ <- SW.end w "write end" Nothing Nothing
 log "testWritable end"