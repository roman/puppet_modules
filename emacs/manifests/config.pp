class emacs::config($user, $config_repo_url) {
  include git::install

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"]
  }

  exec { "emacs::config/download-emacsd-repo":
    cwd => "/home/${user}/",
    command => "git clone ${config_repo_url} .emacs.d",
    creates => "/home/${user}/.emacs.d"
  }

  exec { "emacs::config/update-emacsd-repo":
    cwd => "/home/$user/.emacs.d",
    command => "git pull origin master",
    onlyif => "[ -s /home/$user/.emacs.d ]",
  }

  file { "emacs::config/set-mode-and-owner-for-emacsd":
    path => "/home/${user}/.emacs.d",
    mode => 755,
    owner => $user,
    group => $user
  }

  Exec["emacs::config/download-emacsd-repo"] ->
  File["emacs::config/set-mode-and-owner-for-emacsd"]

}