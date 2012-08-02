class emacs::config($user, $config_repo_url) {
  include git::install

  exec { "emacs::config/download-emacsd-repo":
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd => "/home/${user}/",
    command => "git clone ${config_repo_url} .emacs.d",
    creates => "/home/${user}/.emacs.d"
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