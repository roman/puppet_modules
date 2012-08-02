class vim($user="vagrant",
          $config_repo_url="https://github.com/roman/vimconfig.git") {
  class { "vim::plugins":
    config_repo_url => $config_repo_url,
    user => $user
  }
  include vim:install
}
