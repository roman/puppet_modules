class vim::plugins($user,
                   $config_repo_url) {

  include git::install, vim::install

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    user => $user,
    group => $user,
    require => Class["git::install", "vim::install"]
  }

  exec { "vim::plugins/clone-vim-config-repo":
    cwd => "/home/$user",
    command => "git clone ${config_repo_url} .vim --recursive",
    creates => "/home/${user}/.vim",
    # give it a lot of time (20 min), sometimes github is sloow
    timeout => 1200,
  }

  exec { "vim::plugins/update-vim-config":
    cwd => "/home/$user/.vim",
    command => "git pull origin master",
    onlyif => "[ -s /home/$user/.vim ]"
  }

  exec { "vim::plugins/update-vim-plugins":
    cwd => "/home/$user/.vim",
    command => "git submode update --init",
    require => Exec["vim::plugins/update-vim-config"]
  }

  exec { "vim::plugins/create-vimproc-binary":
    cwd => "/home/$user/.vim/bundle/vimproc",
    command => $operatingsystem ? {
      "Ubuntu" => "make -f make_unix.mak",
      "Darwin" => "make -f make_mac.mak"
    },
    creates => "/home/$user/.vim/bundle/vimproc/autoload/proc.so",
    require => Exec["vim::plugins/update-vim-config",
                    "vim::plugins/update-vim-plugins"],
  }

  file { "/home/$user/.vimrc":
    owner => $user,
    group => $user,
    ensure => link,
    target => "/home/$user/.vim/vimrc",
    require => Exec["vim::plugins/clone-vim-config-repo"],
  }

}