class vim-plugin::install {
  include git, vim

  $repo = "http://github.com/roman/vimconfig"

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    user => $user,
    group => $user,
    require => Class["git::install", "vim::install"],
  }

  exec { "install vim config":
    cwd => "/home/$user",
    command => "git clone $repo .vim --recursive",
    creates => "/home/$user/.vim",
    # give it a lot of time (20 min), sometimes github is sloow
    timeout => 1200,
  }

  exec { "update vim config":
    cwd => "/home/$user/.vim",
    command => "git pull origin master",
    onlyif => "[ -s /home/$user/.vim ]",
  }

  # This will make tools like vimshell work
  exec { "create vimproc binary":
    cwd => "/home/$user/.vim/bundle/vimproc",
    command => $operatingsystem ? {
      "Darwin" => "make -f make_mac.mak",
      "Ubuntu" => "make -f make_gcc.mak",
    },
    creates => "/home/$user/.vim/bundle/vimproc/autoload/proc.so",
  }

  file { "/home/$user/.vimrc":
    owner => $user,
    group => $user,
    ensure => link,
    target => "/home/$user/.vim/vimrc",
    require => Exec["install vim config"],
  }

}
