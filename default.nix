let
  pinned_release = builtins.fetchTarball {
    # https://github.com/NixOS/nixpkgs/tree/21.05
    name = "nixpkgs-92bff24dc157218068c10300f4b8af7db7af0fd6";
    url = "https://github.com/NixOS/nixpkgs/archive/92bff24dc157218068c10300f4b8af7db7af0fd6.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1hk664l92nba1dampmrs69sdfdvbhf51jpdnfgwkrqmcr5rsbygj";
  };
in
with (import pinned_release {});
# with import <nixpkgs> {};
let
  # pull in RVM patchsets directly
  # https://www.reddit.com/r/NixOS/comments/6xg5aa/comment/dmjlgqb/?utm_source=share&utm_medium=web2x&context=3
  patchSet = import <nixpkgs/pkgs/development/interpreters/ruby/rvm-patchsets.nix> { inherit fetchFromGitHub; };
  doNotRegenerateRevisionH = <nixpkgs/pkgs/development/interpreters/ruby/do-not-regenerate-revision.h.patch>;

  # ruby_2-7-3 = pkgs.ruby_2_7;
  ruby_2-7-3 = pkgs.ruby_2_7.overrideAttrs (oldAttrs: rec {
    version = "2.7.3";
    src = fetchFromGitHub {
      owner = "ruby";
      repo = "ruby";
      rev = "2.7.3";
      sha256 = "0vxg9w4dgpw2ig5snxmkahvzdp2yh71w8qm49g35d5hqdsql7yrx";
    };
    patches = [
      "${patchSet}/patches/ruby/2.7/head/railsexpress/01-fix-broken-tests-caused-by-ad.patch"
      "${patchSet}/patches/ruby/2.7/head/railsexpress/02-improve-gc-stats.patch"
      "${patchSet}/patches/ruby/2.7/head/railsexpress/03-more-detailed-stacktrace.patch"
      doNotRegenerateRevisionH
      (fetchpatch {
        url = "https://github.com/ruby/ruby/commit/261d8dd20afd26feb05f00a560abd99227269c1c.patch";
        sha256 = "0wrii25cxcz2v8bgkrf7ibcanjlxwclzhayin578bf0qydxdm9qy";
      })
    ];
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
