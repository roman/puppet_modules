class bash($user="vagrant") {
  class { "bash::update":
    user => $user
  }
}
