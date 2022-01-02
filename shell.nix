with import <nixpkgs> {};
let
  ruby = pkgs.callPackage ./ruby_2-7-3.nix {};
in
pkgs.mkShell {
  name = "fitness";

  nativeBuildInputs = [
    stdenv
    zlib

    ruby

    nodejs-14_x
    yarn

    postgresql
    sqlite

    redis

    # TODO: move this to the Docker image
    tmux
  ];

  shellHook = ''
    # TODO: this setup probably belongs in the ruby package
    mkdir -p "$(pwd)/.gem"
    export GEM_HOME="$(pwd)/.gem/ruby/2.7.0"
    export GEM_PATH="''${GEM_HOME}:${ruby}/lib/ruby/gems/2.7.0"

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
