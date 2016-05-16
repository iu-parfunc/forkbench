
{ stdenv ? (import <nixpkgs> {}).stdenv
}:

stdenv.mkDerivation {
  name = "hpx-forkbench-0.0.1"; 
  builder = ./runbench.sh; 
  src = ./. ;
#  inherit perl; 
}
