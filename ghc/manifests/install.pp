class ghc::install {
  include apt

  case $operatingsystem {

    "Ubuntu": {

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

    default: {
      err("Don't know how to install ghc in this operating system")
    }

  }

}
