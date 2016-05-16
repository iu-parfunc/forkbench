
{ stdenv ? (import <nixpkgs> {}).stdenv
, hpx    ? (import <nixpkgs> {}).hpx
}:

stdenv.mkDerivation {
  name = "hpx-forkbench-0.0.1"; 
  builder = ./runbench.sh; 
  src = ./. ;
  inherit hpx; 
}
