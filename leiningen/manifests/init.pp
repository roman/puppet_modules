class leiningen($user="vagrant") {
  include java

  class { "leiningen::install":
    user => $user
  }
}
