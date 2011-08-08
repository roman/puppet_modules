class tmux::install {
  package { "tmux":
    ensure => present,
  }
}
