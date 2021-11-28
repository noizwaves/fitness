{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};

# Ruby pinned to 2.7.3
# Based upon https://dmitryrck.com/compile-ruby-using-nix/
pkgs.stdenv.mkDerivation {
  name = "ruby_2-7-3";
  version = "2.7.3";

  src = pkgs.fetchurl {
    url = "https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.3.tar.gz";
    sha256 = "8925a95e31d8f2c81749025a52a544ea1d05dad18794e6828709268b92e55338";
  };

  phases = [
    "unpackPhase"
    "configurePhase"
    "buildPhase"
    "installPhase"
  ];

  buildInputs = [
    openssl
    zlib
    readline
    gdbm
  ];

  unpackPhase = ''
    tar xfz $src -C /build
  '';

  configurePhase = ''
    cd ruby-$version
    ./configure --prefix=$out --disable-install-doc --disable-install-rdoc
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';
}