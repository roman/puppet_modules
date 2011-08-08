class java::install {

  case $operatingsystem {
    ubuntu: {
      package { "openjdk-6-jdk":
        ensure => present,
      }

      package { "default-jdk":
        ensure => present,
      }
    }
    default: {
      err("java package supported only for ubuntu")
    }
  }

}
