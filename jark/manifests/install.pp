class jark::install($user="vagrant", $version="0.3") {

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd  => "/tmp",
  }
  
  if versioncmp($version, "0.4") < 0 {

    Exec {
      user => $user,
      group => $user,
    }

    $binary = "jark-0.3.1"
    $url = "http://github.com/downloads/icylisper/jark/$binary"
    
    exec { "download-jark-binary": 
      cwd => "/home/$user/.bin/",
      command => "wget $url",
      creates => "/home/$user/.bin/$binary",
      unless => "test -s /home/$user/.bin/jark",
    }

    exec { "rename-jark-binary":
      cwd => "/home/$user/.bin",
      command => "mv $binary jark",
      creates => "/home/$user/.bin/jark",
      unless => "test -s /home/$user/.bin/jark",
      require => Exec["download-jark-binary"]
    }

    exec { "make-jark-executable":
      command => "chmod 755 /home/$user/.bin/jark",
      unless => "ls -l /home/$user/.bin/jark | grep \"^...x..x..x\"",
      require => Exec["rename-jark-binary"],
    }

  }
  else {


    $package_name = $kernel ? {
      "Darwin"  => "jark-0.4-x86_64_macosx.tar.gz",
      "Linux"   => "jark-0.4-x86_64.tar.gz"
    }
    $folder_name = regsubst($package_name, "(.+)\.tar\.gz", "\1")
    $package_url = "http://github.com/downloads/icylisper/jark-client/$package_name"

    exec { "download-jark-binary":
      command => "wget $package_url",
      creates => "/tmp/$package_name",
      require => Package["wget"],
      unless  => "test -s /home/$user/.bin/jark",
    }

    exec { "unpack-jark-binary":
      command => "tar -xvzf $package_name",
      creates => "/tmp/$folder_name",
      require => Exec["download-jark-binary"],
      unless => "test -s /home/$user/.bin/jark",
    }

    exec { "move-binary-to-local-bin":
      command => "mv /tmp/$folder_name/$folder_name /home/$user/.bin/",
      creates => "/home/$user/.bin/$folder_name",
      require => Exec["unpack-jark-binary"],
      unless => "test -s /home/$user/.bin/jark || test -s /home/$user/.bin/$folder_name",
    }

    exec { "rename-jark-binary":
      command => "mv /home/$user/.bin/$folder_name /home/$user/.bin/jark",
      creates => "/home/$user/.bin/jark",
      onlyif  => "test -s /home/$user/.bin/$folder_name",
      require => Exec["move-binary-to-local-bin"],
    }

    exec { "clean-jark-install": 
      command => "rm -rf /tmp/$folder_name /tmp/$package_name",
      onlyif  => "test -s /tmp/$package_name && test -s /tmp/$folder_name",
      require => Exec["move-binary-to-local-bin", "rename-jark-binary"],
    }

  }

}
