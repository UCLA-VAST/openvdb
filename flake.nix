{
  description = "openvdb";
  inputs = {
    # pick latest commit from stable branch and test it so no suprises
    # nixpkgs.url = "github:NixOS/nixpkgs/d53978239b265066804a45b7607b010b9cb4c50c";
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = import ./openvdb.nix {
          inherit pkgs system;
        };
      });
}
