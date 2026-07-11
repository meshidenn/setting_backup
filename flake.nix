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
      # ユーザー名・home ディレクトリ・OS 差分モジュールを環境ごとに指定する
      mkHome = { system, username, homeDirectory, modules }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ] ++ modules;
        };
    in
    {
      homeConfigurations."hiroki-iida@mac" = mkHome {
        system = "aarch64-darwin";
        username = "hiroki-iida";
        homeDirectory = "/Users/hiroki-iida";
        modules = [ ./home/common.nix ./home/darwin.nix ];
      };

      # TODO: Phase 5 で Linux 実機の arch(x86_64 か aarch64 か)を確認して確定する
      homeConfigurations."hiroki@linux" = mkHome {
        system = "x86_64-linux";
        username = "hiroki";
        homeDirectory = "/home/hiroki";
        modules = [ ./home/common.nix ./home/linux.nix ];
      };
    };
}
