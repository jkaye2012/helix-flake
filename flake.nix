{
  description = "Post-modern editing";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
    };
  };

  outputs = { self, nixpkgs, wrapper-manager }:
    let 
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      jk-hx = (pkgs: wrapper-manager.lib.build {
        inherit pkgs;
        modules = [{
          wrappers.helix = {
            basePackage = pkgs.helix;
            flags = [
              "--config"
              ./config.toml
            ];
          };
        }];
      });
    in
    {
      devShell = forAllSystems (pkgs: 
        pkgs.mkShell {
          name = "helix";
          packages = with pkgs; [
            (jk-hx pkgs)
            nil
          ];
        }
      );
    };
}
