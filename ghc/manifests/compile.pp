define ghc::compile() {

  $ghc_folder = "ghc-7.0.3"
  $ghc_compressed = "$ghc_folder-x86_64-unknown-linux.tar.bz2"
  $ghc_url = "http://www.haskell.org/ghc/dist/7.0.3/$ghc_compressed"

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
    timeout => 60 * 20, # 20 minutes
  }

  exec { "unpack-ghc": 
    cwd => "/tmp",
    command => "tar -xvjf $ghc_compressed",
    creates => "/tmp/$ghc_folder"
    require => Exec["download-ghc"]
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

  #exec { "install-ghc":
  #  cwd => "/tmp/$ghc_folder",
  #  command => "make install",
  #  creates => "/usr/local/bin/ghc",
  #  require => Exec["configure-ghc"],
  #  timeout => 60 * 60 * 2, # 2 hours
  #}

}
