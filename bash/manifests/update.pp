class bash::update($user) {
  include git

  $repo = "http://github.com/roman/bashconfig"

  Exec { 
    path => ["/bin", "/usr/bin", "/usr/local/bin"], 
    user => $user,
    group => $user,
    require => Class["git::install"], 
  }

  exec { "install-bash":
    cwd => "/home/$user",
    command => "git clone $repo .bash",
    creates => "/home/$user/.bash",
  }

  exec { "update-bash":
    cwd => "/home/$user/.bash",
    command => "git pull origin master",
    onlyif  => "[ -s /home/$user/.bash ]",
    require => Exec["install-bash"],
  }

  file { "/home/$user/.bashrc":
    owner => $user,
    group => $user,
    ensure => link,
    target => "/home/$user/.bash/bashrc",
    require => Exec["install-bash"],
  }

}
