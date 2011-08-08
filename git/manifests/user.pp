define git::user($email) {
  include git
  $serial = "2011_08_06"
  $serialfile = "/var/log/puppet/git_user.serial"
  Exec { path => ['/usr/bin', '/usr/local/bin'] }
  exec { "define git user":
    command => "git config --system user.name $name \
&& git config --system user.email $email \
&& echo \"$serial\" > $serialfile",
    unless => "test \"`cat $serialfile 2> /dev/null`\" = \"$serial\"",
    logoutput => true,
    require => Class["git::install"],
  }
}
