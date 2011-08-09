class git::config {
  $serial = "2011_08_06"
  $serialfile = "/var/log/puppet/gitconfig.serial"

  exec { "Setup git globals":
    require => Class["git::install"],
    path    => ["/usr/bin", "/usr/local/bin"],
    unless => "test \"`cat $serialfile 2> /dev/null`\" = \"$serial\"",
    logoutput => true,
    command => "git config --system alias.st status \
&& git config --system alias.co checkout \
&& git config --system alias.ci commit \
&& git config --system alias.cp cherry-pick \
&& git config --system color.ui auto \
&& echo \"$serial\" > $serialfile",
  }

}
