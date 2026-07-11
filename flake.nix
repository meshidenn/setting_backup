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

      # Linux は arch 違いの実機が複数あるため両方定義(setup.sh が uname -m で自動選択)
      homeConfigurations."hiroki@linux" = mkHome {
        system = "x86_64-linux";
        username = "hiroki";
        homeDirectory = "/home/hiroki";
        modules = [ ./home/common.nix ./home/linux.nix ];
      };
      homeConfigurations."hiroki@linux-aarch64" = mkHome {
        system = "aarch64-linux";
        username = "hiroki";
        homeDirectory = "/home/hiroki";
        modules = [ ./home/common.nix ./home/linux.nix ];
      };
    };
}
