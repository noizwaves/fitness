# with import <nixpkgs> {};

with import (builtins.fetchGit {
    # pin for Ruby 2.7.3
    # https://lazamar.co.uk/nix-versions/?package=ruby&version=2.7.3&fullName=ruby-2.7.3&keyName=ruby&revision=860b56be91fb874d48e23a950815969a7b832fbc&channel=nixpkgs-unstable#instructions
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "860b56be91fb874d48e23a950815969a7b832fbc";
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
  '';
}
