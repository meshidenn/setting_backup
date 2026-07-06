{
  description = "hiroki-iida dotfiles — home-manager (standalone flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # ユーザー名は両環境共通。home ディレクトリと OS 差分モジュールだけ変える
      mkHome = { system, homeDirectory, modules }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.username = "hiroki-iida";
              home.homeDirectory = homeDirectory;
            }
          ] ++ modules;
        };
    in
    {
      homeConfigurations."hiroki-iida@mac" = mkHome {
        system = "aarch64-darwin";
        homeDirectory = "/Users/hiroki-iida";
        modules = [ ./home/common.nix ./home/darwin.nix ];
      };

      # TODO: Phase 5 で Linux 実機の arch(x86_64 か aarch64 か)と
      #       home パス(/home/hiroki-iida か /home/hiroki か)を確認して確定する
      homeConfigurations."hiroki-iida@linux" = mkHome {
        system = "x86_64-linux";
        homeDirectory = "/home/hiroki-iida";
        modules = [ ./home/common.nix ./home/linux.nix ];
      };
    };
}
