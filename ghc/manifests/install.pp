class ghc::install {
  case $operatingsystem: {

    "Ubuntu": {
      package { ["ghc", "ghc6-ghci", "ghc-dynamic"]:
        ensure => installed,
      }

    }

    default: {
      err("Don't know how to install ghc in this operating system")
    }

  }
}
