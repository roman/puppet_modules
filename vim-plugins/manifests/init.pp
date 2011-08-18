class vim-plugins($user="vagrant") {
  class { "vim-plugins:install":
    user => $user 
  }
}
