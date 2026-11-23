{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { system-manager, ... }: {
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [ ./default.nix ];
    };
  };
}
