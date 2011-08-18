class leiningen($user="vagrant") {
  class { "leiningen::install":
    user => $user
  }
}
