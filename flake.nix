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
                printf "Welcome! \n\nWe will scrape audio from a youtube video.\n"
                printf "You can read the source code on https://github.com/sempruijs/audio-from-yt\n\n"

                printf "\n----- step 1 of 2 -----\n\n"
                printf "enter the url: "
                read -r url

                printf "\n----- step 2 of 2 -----\n\n"
                printf "Please type 1 of the following output formats:\n\n"
                printf " - aac\n"
                printf " - alac\n"
                printf " - flac\n"
                printf " - m4a\n"
                printf " - mp3\n"
                printf " - vorbis\n"
                printf " - wav\n\n"

                printf "format: "
                read -r format

                yt-dlp -x --audio-format "$format" "$url"
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
