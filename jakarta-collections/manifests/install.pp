class jakarta-collections::install {
  case $operatingsystem {
    "Archlinux": {
      
      Exec {
        cwd => "/tmp",
        path => ["/bin", "/usr/bin", "/usr/local/bin"]
      }

      $folder_name = "jakarta-commons-collections"
      $tar_name = "$folder_name.tar.gz" 
      $resource_url = "http://aur.archlinux.org/packages/ja/jakarta-commons-collections/$tar_name"

      exec { "download-jakarta-commons-collections-aur-tar":
        command => "wget $resource_url",
        creates => $tar_name,
      }

      exec { "decompress-jakarta-commons-collections-aur-tar":
        command => "tar -xvzf $tar_name",
        creates => $folder_name,
        require => Exec["download-jakarta-commons-collections-aur-tar"],
      }

      exec { "makepkg-jakarta-commons-collections-aur":
        cwd => "/tmp/$folder_name",
        command => "makepkg -s",
        require => Exec["decompress-jakarta-commons-collections-aur-tar"]
      }

    }

    default {
      errlog("Don't know how to build jakarta-collections in $operatingsystem")
    }
  }
}
