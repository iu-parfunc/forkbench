{-# LANGUAGE BangPatterns    #-}
{-# LANGUAGE TemplateHaskell #-}
module Main where

import Control.Concurrent (threadDelay)
import Control.DeepSeq (NFData(..))
import Control.Monad
import Control.Distributed.Process
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Node

import Criterion.Main
import Criterion.Types

import Network.Transport (Transport(..))
import Network.Transport.TCP (createTransport, defaultTCPParameters)

remotableDecl [
  [d| spawnbench :: (SendPort Int, Int) -> Process ()
      spawnbench (sp, 0) = sendChan sp 1
      spawnbench (sp, n) = do
          nid <- getSelfNode
          let (half1,rm) = n `quotRem` 2
              half2      = half1 + rm
          (sp' ,rp')  <- newChan
          (sp'',rp'') <- newChan
          _ <- spawn nid ($(mkClosure 'spawnbench) (sp', half2-1))
          spawnbench (sp'', half1)
          n'  <- receiveChan rp'
          n'' <- receiveChan rp''
          sendChan sp (n' + n'')
  |] ]

myRemoteTable :: RemoteTable
myRemoteTable = Main.__remoteTableDecl initRemoteTable

newTransport :: IO Transport
newTransport = do
  Right transport <- createTransport "127.0.0.1" "10501" defaultTCPParameters
  return transport

launch :: Transport -> Int -> IO ()
launch transport iters = do
  node <- newLocalNode transport myRemoteTable
  runProcess node $ do
    us <- getSelfNode
    (sp,rp) <- newChan
    _ <- spawnLocal $ spawnbench (sp, iters)
    ans <- receiveChan rp
    liftIO . putStrLn $ "Result: " ++ show ans

instance NFData Transport where
  rnf !_ = ()

main :: IO ()
main = defaultMain
  [ env newTransport $ \tp ->
        bench "cloud-haskell/spawnbench" (Benchmarkable $ launch tp . fromIntegral)
  ]
