class java::install($java_version="oracle") {

  case $operatingsystem {

    "Ubuntu": {
      include apt

      if $java_version == "oracle" {
        apt::ppa { "java_ppa":
          ppa_name => "ppa:webupd8team/java"
        }
        package { ["oracle-jdk7-installer"]:
          ensure => present,
          require => [Apt::Ppa["java_ppa"],
                      Class["apt::update"]]
        }
      }
      else {
        package { ["openjdk-6-jdk", "default-jdk"]:
          ensure => present,
          require => Class["apt::update"],
        }
      }
    }

    "Archlinux": {
      include pacman
      if $java_version == "oracle" {
        err("java oracle module not supported for $operatingsystem")
      }
      else {
        package { "openjdk6":
          ensure => present,
          require => Class["pacman::config"],
        }
      }
    }

    default: {
      err("java module not supported for $operatingsystem")
    }

  }
}
