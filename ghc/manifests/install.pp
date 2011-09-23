class ghc::install($compile) {

  if $compile {
    ghc::compile { "compile-and-install-haskell-platform": }
  }
  else {

    case $operatingsystem {

      "Ubuntu": {
        include apt

        if versioncmp($operatingsystemrelease, '11.04') < 0 {
          err("Can't install haskell on a release smaller than 11.04")

        }
        else {
          package { "build-essential":
            ensure => installed,
          }

          package { ["haskell-platform"]:
            ensure => installed,
            require => [Package["build-essential"], Class["apt::update"]]
          }
        }


      }

      "Archlinux": {
        include pacman

        package { "haskell-platform":
          ensure => installed
        }

      }

      default: {
        err("Don't know how to build ghc in your machine")
      }

    }
  }

}
