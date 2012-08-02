class emacs($user="vagrant",
            $config_repo_url="https://github.com/roman/emacs.d",
            $use_ppa=false) {

  class { "emacs::install":
    use_ppa => $use_ppa
  }

  class { "emacs::config":
    user => $user,
    config_repo_url => $config_repo_url
  }

}