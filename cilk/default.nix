
{ stdenv ? (import <nixpkgs> {}).stdenv
}:

stdenv.mkDerivation {
  name = "cilk-forkbench-0.0.1";
#  configurePhase = "";
#  builder = make ;
  src = ./. ;
}
