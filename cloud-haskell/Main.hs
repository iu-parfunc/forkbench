{-# LANGUAGE TemplateHaskell #-}

module Main where

import Control.Concurrent (threadDelay)
import Control.Monad
import Control.Distributed.Process
import Control.Distributed.Process.Closure
import Control.Distributed.Process.Node
import Network.Transport.TCP (createTransport, defaultTCPParameters)

remotableDecl [
  [d| spawnbench :: (SendPort Int, Int) -> Process ()
      spawnbench (sp, 0) = sendChan sp 1
      spawnbench (sp, n) = do
          nid <- getSelfNode
          let half1 = n `div` 2
              half2 = half1 + (n `mod` 2)
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

main :: IO ()
main = do
  Right transport <- createTransport "127.0.0.1" "10501" defaultTCPParameters
  node <- newLocalNode transport myRemoteTable
  let iters = 1000
  runProcess node $ do
    us <- getSelfNode
    (sp,rp) <- newChan
    _ <- spawnLocal $ spawnbench (sp, iters)
    ans <- receiveChan rp
    liftIO . putStrLn $ "Result: " ++ show ans
