
-- import System.Concurrency.Channels
import System.Concurrency.Raw

-- spawnbench n = do pid0 <- getMyPid
--                   go pid0 n

theChan : Int
theChan = 1

whoami : IO Ptr
whoami = pure prim__vm

mutual
 helper : Ptr -> Int -> IO ()
 helper parentPid half2 = 
   do x <- spawnbench (half2-1)
      putStrLn $ "Hello from child thread! "++show half2
      _ <- sendToThread parentPid theChan x
      return ()

 spawnbench : Int -> IO Int
 spawnbench 0 = return 1
 spawnbench n = 
  do parentPid <- whoami
     let half  = n `div` 2
     let half2 = half + (n `mod` 2)
     
     putStrLn $ "Halving "++show n
     child <- fork (helper parentPid half2)
     y <- spawnbench half
--     Just x <- getMsgFrom child theChan
     (_,_,x) <- getMsgWithSender { a=Int }
     
     return (x+y)


main : IO () 
main = do -- putStrLn "Starting forkbench"
          x <- spawnbench 10
          putStrLn ("Result: " ++ show x)
