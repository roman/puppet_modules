class leiningen::install($user) {
  $exec = "https://github.com/technomancy/leiningen/raw/stable/bin/lein"

  package { "wget":
    ensure => present,
  }

  file { "create local bin":
    ensure => directory,
    path => "/home/$user/.bin",
    owner => $user,
    group => $user,
    mode => '755',
  }

  exec { "install leiningen":
    user => $user,
    group => $user,
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd => "/home/$user/.bin",
    command => "wget $exec && chmod 755 lein && ./lein",
    creates => ["/home/$user/.bin/lein",  
                "/home/$user/.lein"],
    require => [Class["java::install"],
                File["create local bin"], 
                Package["wget"]],
  }

}

