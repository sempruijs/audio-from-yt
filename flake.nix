{
  description = "Scrape audio from youtube";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # add more inputs here
  };
  # pass inputs to output function
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
        in {
          packages = {
            # add build phases here
            default = pkgs.writeShellApplication {
              name = "audio-from-yt";
              runtimeInputs = with pkgs; [ yt-dlp ffmpeg_6 ];
              text = ''
                printf "Paste the url here below:\n\n"
                read -r url
                yt-dlp -x --audio-format "mp3" "$url"
              '';
            };
          };
          devShells = {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [ yt-dlp ffmpeg_6 ];
            };
          };
        };
    };
}
