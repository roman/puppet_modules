class apt::update {

  exec { "update packages":
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    command => $operatingsystem ? {
      'Ubuntu' => 'apt-get update',
      default  => err("don't know how to update $operatingsystem"),
    }
  }

}
