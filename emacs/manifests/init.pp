class emacs($user="vagrant",
            $config_repo_url="https://github.com/roman/emacs.d",
            $version=24) {

  class { "emacs::install":
    version => $version
  }

  class { "emacs::config":
    user => $user,
    config_repo_url => $config_repo_url
  }

}