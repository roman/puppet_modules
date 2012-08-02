define apt::ppa($ppa_name) {

   Exec {
     path => ["/bin", "/usr/bin", "/usr/local/bin"],
     cwd => "/etc/apt"
   }

   exec { "apt::ppa/update-packages-for-${name}":
     command => "apt-get update"
   }

   exec { "apt::ppa/apppend-${name}-to-ppa-list":
     command => "add-apt-repository ${ppa_name}",
     unless => "ls /etc/apt/puppet | grep '${name}_installed'",
   }

   file { "apt::ppa/${name}-installed":
     path => "/etc/apt/puppet/${name}_installed",
     ensure => present,
     content => "",
   }
   
   Class["apt::install"] -> Exec["apt::ppa/apppend-${name}-to-ppa-list"]
   Exec["apt::ppa/apppend-${name}-to-ppa-list"] -> File["apt::ppa/${name}-installed"]
   Exec["apt::ppa/apppend-${name}-to-ppa-list"] -> Exec["apt::ppa/update-packages-for-${name}"]

}