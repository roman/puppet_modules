class java::install {
  include apt

  case $operatingsystem {
    ubuntu: {
      package { ["openjdk-6-jdk", "default-jdk"]:
        ensure => present,
        require => Class["apt::update"],
      }

    }
    default: {
      err("java package supported only for ubuntu")
    }
  }

}
