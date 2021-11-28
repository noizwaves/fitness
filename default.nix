with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "fitness";

  buildInputs = [
    stdenv

    (pkgs.callPackage ./ruby_2-7-3.nix {})

    nodejs-14_x
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
