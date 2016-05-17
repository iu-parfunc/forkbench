
{ stdenv ? (import <nixpkgs> {}).stdenv
, hpx    ? (import <nixpkgs> {}).hpx
, hwloc  ? (import <nixpkgs> {}).hwloc
}:

stdenv.mkDerivation {
  name = "hpx-forkbench-0.0.1"; 
  builder = ./builder.sh; 
  src = ./. ;
  inherit hpx;
  inherit hwloc;
}
