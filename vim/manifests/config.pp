class vim::config {

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
    timeout => 1200, # 20 minutes
  }

  exec { "update vim config":
    cwd => "/home/$user/.vim",
    command => "git pull origin master",
    onlyif => "[ -s /home/$user/.vim ]",
  }

  file { "/home/$user/.vimrc":
    owner => $user,
    group => $user,
    ensure => link,
    target => "/home/$user/.vim/vimrc",
    require => Exec["install vim config"],
  }

}
