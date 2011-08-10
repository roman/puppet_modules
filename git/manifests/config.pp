class git::config {
  $serial = "2011_08_06"
  $serialfile = "/var/log/puppet/gitconfig.serial"

  file { "/var/log/puppet": 
    ensure => directory,
  }

  exec { "setup git globals":
    path    => ["/usr/bin", "/usr/local/bin"],
    command => "git config --system alias.st status \
&& git config --system alias.co checkout \
&& git config --system alias.ci commit \
&& git config --system alias.cp cherry-pick \
&& git config --system color.ui auto \
&& echo \"$serial\" > $serialfile",
    creates => $serialfile,
    logoutput => true,
    unless => "test \"`cat $serialfile 2> /dev/null`\" = \"$serial\"",
    require => [Class["git::install"], File["/var/log/puppet"]],
  }

}
