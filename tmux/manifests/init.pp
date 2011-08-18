class tmux($user="vagrant") {
  include tmux::install
  class { tmux::config:
    user => $user
  }
}
