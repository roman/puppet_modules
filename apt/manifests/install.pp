class apt::install {

  package { "apt::install/install-ppa-utilities":
    name => "python-software-properties",
    ensure => latest
  }

  file { "apt::install/puppet-directory":
    ensure => directory,
    path => "/etc/apt/puppet/"
  }

}