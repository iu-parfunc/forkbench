

module Main where

import Data.Word
import Control.Monad.Par
import System.Environment
import Criterion.Main
import Criterion.Types

spawnbench :: Word64 -> Par Word64
spawnbench 0 = return 1
spawnbench n =
  do let (half,rm) = n `quotRem` 2
         half2 = half+rm
     x <- spawn_ (spawnbench (half2-1))
     y <- spawnbench half
     x' <- get x
     return $! x'+y

main :: IO ()
main = do 
  -- args <- getArgs
  -- case args of 
  --  [n] ->

     defaultMain [
       bench "monad-par-trace/spawnbench"
        (Benchmarkable $ \n -> runParIO (spawnbench (fromIntegral n)) >>= print)
      ]

--   _ -> error$ "Expected one numeric command line argument (numForks), got: "++show args

