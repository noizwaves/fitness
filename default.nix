# pin for Ruby 2.7.3
# https://lazamar.co.uk/nix-versions/?package=ruby&version=2.7.3&fullName=ruby-2.7.3&keyName=ruby&revision=860b56be91fb874d48e23a950815969a7b832fbc&channel=nixpkgs-unstable#instructions
with import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "my-old-revision";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/860b56be91fb874d48e23a950815969a7b832fbc.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "07i03028w3iak0brdnkp79ci8vqqbrgr5p5i9sk87fhbg3656xhw";
}) {};

stdenv.mkDerivation {
  name = "fitness";

  buildInputs = [
    stdenv

    ruby_2_7

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
