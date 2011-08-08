class tmux::config {
  file { "/home/vagrant/.tmux.conf":
    ensure  => present,
    source  => "puppet:///modules/tmux/tmux.conf",
    require => Class["tmux::install"],
  }
}
