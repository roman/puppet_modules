class neo4j::install($source=true) {

  if $source { 

    Exec {
      cwd => "/tmp",
      path => ["/bin", "/usr/bin", "/usr/local/bin"],
    }

    $folder_name = "neo4j-community-1.5.M01"
    $tar_name = "${folder_name}-unix.tar.gz"
    $resource_url = "http://dist.neo4j.org/${tar_name}"

    package { "neo4j-dependencies":
      name => ["lsof"],
      ensure => latest
    }

    file { "ensure-opt-created-for-neo4j":
      path => "/opt/local",
      ensure => directory
    }

    exec { "download-neo4j-tar":
      command => "wget $resource_url",
      creates => "/tmp/$tar_name",
      unless  => "test -s /opt/local/$folder_name",
      require => Package["neo4j-dependencies"]
    }

    exec { "decompress-neo4j-tar":
      command => "tar -xvzf $tar_name",
      creates => "/tmp/$folder_name",
      unless  => "test -s /opt/local/$folder_name",
      require => Exec["download-neo4j-tar"]
    }

    exec { "move-neo4j-to-opt-local":
      command => "mv $folder_name /opt/local",
      creates => "/opt/local/$folder_name",
      unless  => "test -s /opt/local/$folder_name",
      require => [ File["ensure-opt-created-for-neo4j"]
                 , Exec["decompress-neo4j-tar"]]
    }

    exec { "clean-neo4j-install": 
      command => "rm $tar_name",
      onlyif => "test -s /tmp/${tar_name}",
      require => Exec["move-neo4j-to-opt-local"]
    }

    file { "/opt/local/neo4j":
      ensure => link,
      target => "/opt/local/neo4j/$folder_name",
      require => Exec["move-neo4j-to-opt-local"],
    }

  }
  else {
    err("There is no package for neo4j just yet")
  }

}
