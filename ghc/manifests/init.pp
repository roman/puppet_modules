class ghc($compile=false) {
  class { "ghc::install":
    compile => $compile
  }
}
