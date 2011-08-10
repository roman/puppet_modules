define git::user($email) {
  include git

  Exec { 
    path => ['/bin', '/usr/bin', '/usr/local/bin'],
    require => Class["git::install"],
  }

  exec { "define git user":
    command => "git config --system user.name $name",
    unless => "cat /etc/gitconfig | grep 'name = $name'",
  }

  exec { "define git email":
    command => "git config --system user.email $email",
    unless => "cat /etc/gitconfig | grep 'email = $email'",
  }

}
