
(* UNFINISHED: quotient doesn't seem to be supported in pmlc:
   "Error: unbound variable: Int.rem"
 *)

fun spawnbench (n: int) : int =
  if n = 0
  then 1
  else let val half = n div 2
           val half2 = half + n mod 2
	   (* Use parallel tuples instead of pval because the former
	      is currently better optimized by Manticore -- Mike
           pval x = spawnbench (half2-1)
           pval y = spawnbench half *)
	   val (x, y) = (| spawnbench (half2-1), spawnbench half |)
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

(*

[2016.05.22] I was having some trouble with this:

$ ../bin/spawnbench-manticore.exe 1000
Spawnbench args: [1000]
Segmentation fault (core dumped)
*)
