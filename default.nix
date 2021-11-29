with import <nixpkgs> {};
let
  ruby_2-7-3 = pkgs.ruby.overrideAttrs (oldAttrs: rec {
    version = "2.7.3";
    src = fetchurl {
      url = "https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.3.tar.gz";
      sha256 = "8925a95e31d8f2c81749025a52a544ea1d05dad18794e6828709268b92e55338";
    };
  });

  nodejs_14-15-5 = pkgs.ruby.overrideAttrs (oldAttrs: rec {
    version = "14.15.5";
    src = fetchurl {
      url = "https://nodejs.org/dist/v14.15.5/node-v14.15.5.tar.xz";
      sha256 = "e19b1d40e958fe30c224f5a67af4ee4081e7f9d6fb586fb4bbc8d94aab39655b";
    };
  });
in stdenv.mkDerivation {
  name = "fitness";

  buildInputs = [
    stdenv

    # (pkgs.callPackage ./ruby_2-7-3.nix {})
    ruby_2-7-3

    nodejs-14_x
    # nodejs_14-15-5
    yarn

    postgresql
    sqlite

    redis

    # TODO: move this to the Docker image
    tmux
  ];

  shellHook = ''
    export PGHOST=$(pwd)/postgres
    export PGDATA=$PGHOST/data
    export PGLOG=$PGHOST/postgres.log

    mkdir -p $PGHOST

    if [ ! -d $PGDATA ]; then
      initdb --auth=trust --no-locale --encoding=UTF8
    fi

    export DB_USERNAME=adam

    # Fix sassc build on darwin+nix
    # https://github.com/sass/sassc-ruby/issues/148#issuecomment-644450274
    bundle config --local build.sassc --disable-lto
  '';
}
