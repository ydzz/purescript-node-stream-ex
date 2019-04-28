module Node.PullStream.Source.Count (
  count
) where
import Effect (Effect)
import Effect.Ref as Ref
import Node.PullStream.Types (ReadFunc(..))
import Prelude


count::Int -> Effect　(ReadFunc Int)
count max = do
  ei <- Ref.new 0
  pure $ ReadFunc (\end cb -> do
                     i::Int <- Ref.read ei
                     if end then (cb end 0)
                            else (if i >= (max + 1) then cb true 0 
                                                    else do 
                                                     _ <- Ref.modify (\ai -> ai + 1) ei
                                                     cb false i
                                 )
       )