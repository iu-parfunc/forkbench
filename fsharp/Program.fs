// Learn more about F# at http://fsharp.org

open System
open System.Threading.Tasks

let rec forkbench (n : int)  =    
//    printfn "forkbench %d..." n
    if (n = 0) then 1 else
      let half1 = n / 2
      let half2 = half1 + (n % 2)
      let t = Task.Run<int>( fun () -> forkbench (half2 - 1) : int)
      let y = forkbench half1
      let x = t.Result
      x + y

[<EntryPoint>]
let main argv = 
    let r = forkbench(int argv.[0])
    printfn "forkbench: %d" r
    0 
