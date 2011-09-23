class git($user="vagrant", $username, $email) {
  include git::install

  file { "/home/$user/.gitconfig":
    ensure => present,
    owner => $user,
    group => $user,
  }

  git::config { "user.name":
    user  => $user,
    value => $username,
  }

  git::config { "user.email": 
    user => $user,
    value => $email,
  }

  git::config { "alias.co":
    user => $user,
    value => "checkout",
  }

  git::config { "alias.ci":
    user => $user,
    value => "commit",
  }

  git::config { "alias.cp":
    user => $user,
    value => "cherry-pick",
  }

  git::config { "alias.st":
    user => $user,
    value => "status",
  }

  git::config { "color.ui":
    user => $user,
    value => "auto",
  }

}
