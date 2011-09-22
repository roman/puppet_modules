class redis::install {

  case $operatingsystem {

    "Ubuntu": {
      package {"redis-server":
        ensure => installed,
      }
    }

    "Archlinux": {
      package {"redis": 
        ensure => installed,
      }
    }

    default: {
      err("Don't know how to install redis in this os")
    }

  }

}
