{ system ? builtins.currentSystem, pkgs ? import <nixpkgs> { inherit system; } }:

  with pkgs;
let
  pkgs = import pkgs {
    overlays = [ (import ./overlay.nix) ];
  } { inherit system;
  };
in
  stdenv.mkDerivation {
    name = "openvdb";
    version = "10.0.0";

  # https://nixos.org/nix/manual/#builtin-filterSource
  src = builtins.filterSource
  (path: type: lib.cleanSourceFilter path type
  && baseNameOf path != "doc/*"
  && baseNameOf path != "openvdb_houdini/*"
  && baseNameOf path != "openvdb_maya/*"
  && baseNameOf path != "pendingchanges/*"
  && baseNameOf path != "tsc/*") ./.;

  cmakeFlags =["-DOPENVDB_BUILD_VDB_VIEW=ON"];

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];

    # required dependencies for downstream development
    propagatedBuildInputs = [
      openexr
      tbb
      c-blosc
      boost175
    ];

    buildInputs = [
      unzip jemalloc ilmbase
      # for the optional VDB_VIEW binary opengl related dependencies:
      libGL glfw3 x11 libGLU xorg.libXdmcp
    ];

  }
