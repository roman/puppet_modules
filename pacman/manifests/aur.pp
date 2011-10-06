define pacman::aur($user, $resource_url) {
  
  $tar_title    = regsubst($resource_url, "^.+/(.+)$", "\1")
  $folder_title = regsubst($tar_title, "^(.+)\.tar\.gz$", "\1")

  Exec {
    cwd => "/tmp",
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    user => $user
  }

  exec { "${title}-download-aur":
    command => "wget -c $resource_url",
    creates => "/tmp/$tar_title",
  }

  exec { "${title}-decompress-aur":
    command => "tar -xzf $tar_title",
    creates => "/tmp/$folder_title",
    require => Exec["${title}-download-aur"]
  }

  exec { "${title}-install-aur":
    cwd => "/tmp/$folder_title",
    command => "makepkg -si",
    require => Exec["${title}-decompress-aur"],
    logoutput => true
  }

  exec { "${title}-clean-aur":
    command => "rm -rf /tmp/$folder_title*",
    require => Exec["${title}-install-aur"],
  }

}
