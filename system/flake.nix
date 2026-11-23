{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    voidsddm = {
      url = "github:talyamm/voidsddm/d83e217bac17ed768681e4f741ae255f4a76ca60";
      flake = false;
    };
  };

  outputs = { nixpkgs, voidsddm, ... }: {
    packages.x86_64-linux.default = import ./default.nix {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      inherit voidsddm;
    };
  };
}
