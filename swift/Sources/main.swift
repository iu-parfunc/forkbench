import Foundation
import Darwin

// import Glibc


func sayHello(name: String) {
    print("Hello, \(name)!")
}

print("Hello, world!")

sayHello(name: "ryan")

//------------------------------------------------------------------------------

let queue = OperationQueue()

queue.addOperation() {
    // do something in the background

    OperationQueue.main.addOperation() {
        // when done, update your UI and/or model on the main queue
    }
}


func doCalc() {
  let x=100
  let y = x*x
  _ = y/x
}


func performCalculation(iterations: Int, tag: String) 
{
  let start = CFAbsoluteTimeGetCurrent()
  for _ in 0 ... iterations-1 {
      doCalc()
  }
  let end = CFAbsoluteTimeGetCurrent()
  print("time for \(tag):  \(end-start)")
}

let concurrentQueue =
  DispatchQueue(label: "queuename", attributes: .concurrent)


// let queue = dispatch_queue_create("cqueue.hoffman.jon",   
//                                   DISPATCH_QUEUE_CONCURRENT)


let c = { performCalculation(iterations: 1000, tag: "async0") }

// dispatch_async(concurrentQueue, c)
// concurrentQueue.asynchronously(execute: c)



// let qosClass = QOS_CLASS_BACKGROUND
// let backgroundQueue = dispatch_get_global_queue(qosClass, 0)
// dispatch_async(backgroundQueue, {
//     print("Work on background queue")
// })


let fut = DispatchQueue.main.async { print("Main async queue") }


