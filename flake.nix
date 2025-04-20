{
  description = "A develop environment for LLVM Pass";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { self, nixpkgs, }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true; # Allow unfree packages
              };
            };
          });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override {
          # Override stdenv in order to change compiler:
          stdenv = pkgs.llvmPackages_19.stdenv;
        } {
          packages = with pkgs;
            [ cmake klee z3 lit ]
            ++ (with pkgs.llvmPackages_19; [ llvm clang lld ]);

          # Set LLVM_DIR to point to the LLVM installation
          shellHook = ''
            #export LLVM_DIR=${pkgs.llvmPackages_19.llvm.dev}/lib/cmake/llvm
            #export LLVM_CONFIG_BINARY=${pkgs.llvmPackages_19.llvm.dev}/bin/llvm-config
            #export LLVMCC=${pkgs.llvmPackages_19.llvm}/bin/clang
            #export LLVMCXX=${pkgs.llvmPackages_19.llvm}/bin/clang++
          '';
        };
      });
    };
}
