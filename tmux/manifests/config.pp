class tmux::config($user) {
  file { "/home/$user/.tmux.conf":
    ensure  => present,
    source  => "puppet:///modules/tmux/tmux.conf",
    require => Class["tmux::install"],
  }
}
