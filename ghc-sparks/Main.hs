

module Main where

import Data.Word
import Control.Parallel
import Control.Monad
import Control.Exception
import Criterion.Main
import Criterion.Types

spawnbench :: Word64 -> Word64
spawnbench 0 = 1
spawnbench n =
   let (half,rm) = n `quotRem` 2
       half2 = half+rm
       x = spawnbench (half2-1)
       y = spawnbench half
   in 
      x `par`
      y `pseq`
      x + y

main :: IO ()
main = do 
     defaultMain [
       bench "ghc-sparks/spawnbench"
        (Benchmarkable $ \n -> print (spawnbench (fromIntegral n)))
      ]
