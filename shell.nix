{ pkgs ? import <nixpkgs> {}, ...}:

with pkgs;

let
  darwin_packages = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreServices
    ApplicationServices
    Security
  ]);
  ruby = ruby_3_1;

  # Issue with using gemspec files
  #
  #gems = bundlerEnv {
    #name = "veracodeRubyEnv";
    #inherit ruby;
    #gemdir  = ./.;
    #gemConfig = defaultGemConfig;
  #};

in mkShell rec {
  name = "veracode_api_signing";

  buildInputs = [
    libressl
    #(lowPrio gems.wrappedRuby)
    autoconf
    automake
    bash-completion
    bison
    cairo
    coreutils
    gdbm
    #gems
    git
    gnumake
    groff
    libffi
    libiconv
    libtool
    libunwind
    libxml2
    libxslt
    libyaml
    msgpack
    ncurses
    netcat
    openssl
    pkg-config
    pkgconfig
    postgresql
    postgresql_13
    readline
    (lowPrio ruby)
    shared-mime-info # Required for the mime gem
    sqlcipher
    sqlite
    swagger-codegen3
    zlib
  ] ++ (lib.optionals stdenv.isDarwin darwin_packages);

  shellHook = ''
    export FREEDESKTOP_MIME_TYPES_PATH=${shared-mime-info}/share/mime/packages/freedesktop.org.xml

    mkdir -p .gems
    export GEM_HOME=$PWD/.gems
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH

    # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
    for p in ''${buildInputs}; do
      if [ -d "$p/share/bash-completion" ]; then
        if [ -z ''${XDG_DATA_DIRS} ]; then
          XDG_DATA_DIRS="$p/share"
        else
          XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
        fi
      fi
    done

    source ${bash-completion}/etc/profile.d/bash_completion.sh
  '';
}
