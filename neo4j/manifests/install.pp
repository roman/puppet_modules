class neo4j::install {

  case $operatingsystem {

    Exec {
      cwd => "/tmp",
      path => ["/bin", "/usr/bin", "/usr/local/bin"],
    }

    "Archlinux": {
      $tar_name = "neo4j.tar.gz"
      $resource_url = "http://aur.archlinux.org/packages/ne/neo4j/$tar_name"

      exec { "download-neo4j-aur-tar":
        command => "wget $resource_url",
        creates => $tar_name,
      }
      
      exec { "decompress-neo4j-aur-tar":
        command => "tar -xvzf $tar_name",
        creates => "neo4j",
        requires => Exec["download-neo4j-aur-tar"]
      }

      exec { "create-neo4j-pacman-package": 
        cwd => "/tmp/neo4j",
        command => "makepkg -s",
        requires => Exec["decompress-neo4j-aur-tar"],
      }

    }

    default: {
      $folder_name = "neo4j-community-1.5.M01"
      $tar_name = "$folder_name-unix.tar.gz"
      $resource_url = "http://dist.neo4j.org/$tar_name"


      exec { "download-neo4j-tar":
        command => "wget $resource_url",
        creates => $tar_name,
      }

      exec { "decompress-neo4j-tar":
        command => "tar -xvzf $tar_name",
        creates => $folder_name,
      }
    }

  }
}
