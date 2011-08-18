class tmux($user="vagrant") {
  include tmux::install, tmux::config
}
