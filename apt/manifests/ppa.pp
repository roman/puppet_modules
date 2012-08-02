define apt::ppa($ppa_name) {

   Exec {
     path => ["/bin", "/usr/bin", "/usr/local/bin"],
     cwd => "/etc/apt"
   }

   exec { "apt-ppa/apppend-${name}-to-ppa-list":
     command => "add-apt-repository ${ppa_name}",
     unless => "ls /etc/apt/puppet | grep '${name}_installed'",
     require => Class["apt::install"]
   }

   file { "apt-ppa/${name}-installed":
     path => "/etc/apt/puppet/${name}_installed",
     ensure => present,
     content => "",
     require => Class["apt::install"]
   }

   Exec["apt-ppa/apppend-${name}-to-ppa-list"] ->
   Class["apt::update"] ->
   File["apt-ppa/${name}-installed"]

}