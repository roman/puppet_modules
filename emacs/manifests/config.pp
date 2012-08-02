class emacs::config($user, $config_repo_url) {
  include git::install

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    user => $user,
    group => $user
  }

  exec { "emacs::config/download-emacsd-repo":
    cwd => "/home/${user}/",
    command => "git clone ${config_repo_url} .emacs.d",
    creates => "/home/${user}/.emacs.d",
    require => Class["git::install"]
  }

  exec { "emacs::config/update-emacsd-repo":
    cwd => "/home/$user/.emacs.d",
    command => "git pull origin master",
    onlyif => "[ -s /home/$user/.emacs.d ]",
  }

}