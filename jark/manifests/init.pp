class jark($user="vagrant", $version="0.3") {
  include java

  class { "jark::install": 
    user    => $user,
    version => $version,
    require => Class["java::install", "leiningen::install"]
  }

}
