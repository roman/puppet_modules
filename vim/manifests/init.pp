class vim($compile=false) {
  class { "vim::install":
    compile => $compile
  }
}
