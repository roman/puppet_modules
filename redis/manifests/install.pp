class redis::install {

  case $operatingsystem {

    "Ubuntu" => {
        package {"redis-server":
          ensure => installed,
        }
    }

    default => {
      err("Don't know how to install redis-server in this os")
    }

  }

}
