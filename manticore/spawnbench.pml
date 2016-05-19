
(* UNFINISHED: quotient doesn't seem to be supported in pmlc:
   "Error: unbound variable: Int.rem"
 *)

fun spawnbench (n: int) : int =
  if n = 1
  then 1
  else let val half = Int.quot (n,2)  
           val half2 = half + Int.rem (n,2)
           (* These two can be pval: *)
           val x = spawnbench (half2-1)
           val y = spawnbench half
       in
          x+y
       end

val args = CommandLine.arguments()
val _ = print ("Spawnbench args: [" ^ String.concatWith ", " args ^ "]\n")

val size =
  case Int.fromString (List.hd args) of
     SOME n => n
   | NONE   => raise Match

val res = spawnbench size
val _ = print (Int.toString res)
