class bash::update($user) {
  include git

  $repo = "http://github.com/roman/bashconfig"

  Exec { 
    path => ["/bin", "/usr/bin", "/usr/local/bin"], 
    user => $user,
    group => $user,
    require => Class["git::install"], 
  }

  exec { "bash::update/install-bash-config":
    cwd => "/home/$user",
    command => "git clone $repo .bash",
    creates => "/home/$user/.bash",
  }

  exec { "bash::update/update-bash-config":
    cwd => "/home/$user/.bash",
    command => "git pull origin master",
    onlyif  => "[ -s /home/$user/.bash ]",
    require => Exec["bash::update/install-bash-config"],
  }

  file { "/home/$user/.bashrc":
    owner => $user,
    group => $user,
    ensure => link,
    target => "/home/$user/.bash/bashrc",
    require => Exec["bash::update/install-bash-config"],
  }

}
