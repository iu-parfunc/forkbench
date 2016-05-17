

module Main where

import Data.Word
import Control.Concurrent
import Control.Concurrent.MVar
import Criterion.Main
import Criterion.Types

spawnbench :: Word64 -> IO Word64
spawnbench 0 = return 1
spawnbench n =
  do let (half,rm) = n `quotRem` 2
         half2 = half+rm
     mv <- newEmptyMVar
     forkIO $ do x <- spawnbench (half2-1)
                 putMVar mv x
     y <- spawnbench half
     x <- takeMVar mv
     return $! x+y

main :: IO ()
main = do 
     defaultMain [
       bench "io-threads/spawnbench"
        (Benchmarkable $ \n -> (spawnbench (fromIntegral n)) >>= print)
      ]
