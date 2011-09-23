class pacman::config($n_mirrors=6) {

  Exec {
    cwd  => "/etc/pacman.d",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
  }

  # In order to avoid facter breaking
  package { ["net-tools", "python", "curl"]:
    ensure => present,
  }

  exec { "backup-pacman-mirrorlist":
    command => "cat mirrorlist | sed -e \"s/#Server/Server/m\" > mirrorlist.backup",
    creates => "/etc/pacman.d/mirrorlist.backup",
  }

  exec { "rank-mirrorlist":
    command => "rankmirrors -n $n_mirrors mirrorlist.backup > ranked-mirrorlist",
    creates => "/etc/pacman.d/ranked-mirrorlist",
    require => [ Exec["backup-pacman-mirrorlist"],
                 Package["python", "curl"]
               ],
    timeout => 1200
  }

  exec { "remove-unranked-mirrorlist": 
    command => "rm mirrorlist && cp ranked-mirrorlist mirrorlist",
    unless  => "diff mirrorlist ranked-mirrorlist",
    require => Exec["backup-pacman-mirrorlist", "rank-mirrorlist"]
  }

  exec { "update-pacman-mirrorlist":
    command => "pacman -Syy",
    require => Exec["rank-mirrorlist", 
                    "remove-unranked-mirrorlist"],
  }

  file { "/etc/pacman.d/pacman-aliases.sh":
    ensure => present,
    source => "puppet:///modules/pacman/pacman-aliases.sh",
    mode   => 755,
  }

}
