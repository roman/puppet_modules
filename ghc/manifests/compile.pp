define ghc::compile() {

  $ghc_folder = "ghc-7.0.3"
  $ghc_compressed = "$ghc_folder-x86_64-unknown-linux.tar.bz2"
  $ghc_url = "http://www.haskell.org/ghc/dist/7.0.3/$ghc_compressed"

  $haskell_platform_folder = "haskell-platform-2011.2.0.1"
  $haskell_platform_compressed = "$haskell_platform_folder.tar.gz"
  $haskell_platform_url = "http://lambda.galois.com/hp-tmp/2011.2.0.1/$haskell_platform_compressed"

  package { ["build-essential",
             "libbsd-dev",
             "libgmp3-dev",
             "zlib1g-dev",
             "freeglut3-dev"]:

    ensure => installed
  }

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"]
  }

  exec { "download-ghc":
    cwd => "/tmp",
    command => "wget $gch_url",
    creates => "/tmp/$ghc_compressed",
    unless => "test -e /usr/local/bin/ghc",
    timeout => 1200, # 20 minutes
  }

  exec { "download-haskell-platform":
    cwd => "/tmp",
    command => "wget $haskell_platform_url",
    creates => "/tmp/$haskell_platform_compressed",
    unless => "test -e /usr/local/bin/caball",
    timeout => 1200, # 20 minutes
  }

  exec { "unpack-ghc":
    cwd => "/tmp",
    command => "tar -xvjf $ghc_compressed",
    creates => "/tmp/$ghc_folder",
    require => Exec["download-ghc"],
  }

  exec { "unpack-haskell-platform":
    cwd => "/tmp",
    command => "tar -xvzf $haskell_platform_compressed",
    creates => "/tmp/something",
    require => Exec["download-haskell-platform"],
  }

  exec { "configure-ghc":
    cwd => "/tmp/$ghc_folder",
    command => "sh -c './configure'",
    creates => "/tmp/$ghc_folder/mk/install.mk",
    require => [Exec["unpack-ghc"],
                Package["build-essential",
                "libbsd-dev", "libgmp3-dev",
                "zlib1g-dev", "freeglut3-dev"]],
  }

  exec { "configure-haskell-platform":
    cwd => "/tmp/$haskell_platform_folder",
    command => "sh -c './configure'",
    creates => "/tmp/$haskell_platform_folder/scripts/config",
    require => Exec["unpack-haskell-platform",
                    "install-ghc"],
  }

  exec { "install-ghc":
    cwd => "/tmp/$ghc_folder",
    command => "make install",
    creates => "/usr/local/bin/ghc",
    require => Exec["configure-ghc"],
    timeout => 7200, # 2 hours
  }

  exec { "install-haskell-platform":
    cwd => "/tmp/$haskell_platform_folder",
    command => "make && make install",
    creates => "/usr/local/bin/cabal",
    require => Exec["configure-haskell-platform"],
    timeout => 7200, # 2 hours
  }

}
