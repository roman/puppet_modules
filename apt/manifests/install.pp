class apt::install {

  package { "apt::install/install-ppa-utilities":
    name => "python-software-properties",
    ensure => latest,
    require => Class["apt::update"]
  }

  file { "apt::install/puppet-directory":
    ensure => directory,
    path => "/etc/apt/puppet/"
  }

}