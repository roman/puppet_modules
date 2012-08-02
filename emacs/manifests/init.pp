class emacs($version=24) {
  class { "emacs::install":
    version => $version
  }
}