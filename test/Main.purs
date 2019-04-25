module Test.Main where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Node.StreamEx.Types (Writable)
import Node.StreamEx.Writable as SW
import Prelude (Unit, bind)


foreign import createWriteStream ::String -> Effect Writable

main :: Effect Unit
main = do
  testWritable


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