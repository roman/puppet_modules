class vim::install {

  case $operatingsystem {

    "Ubuntu": {
      if versioncmp($operatingsystemrelease, '11.04') < 0 {

        file { "/tmp/vim_install":
          ensure => directory,
        }

        file { "/tmp/vim_install/vim73.deb":
          ensure => present,
          source => "puppet:///modules/vim/packages/vim_7.3.035+hg~8fdc12103333-1ubuntu7_i386.deb",
          require => File["/tmp/vim_install/vim_common.deb"],
        }

        file { "/tmp/vim_install/vim_common.deb":
          ensure => present,
          source => "puppet:///modules/vim/packages/vim-common_7.3.035+hg~8fdc12103333-1ubuntu7_i386.deb",
          require => File["/tmp/vim_install/vim_runtime.deb"],
        }

        file { "/tmp/vim_install/vim_runtime.deb":
          ensure => present,
          source => "puppet:///modules/vim/packages/vim-runtime_7.3.035+hg~8fdc12103333-1ubuntu7_all.deb",
          require => File["/tmp/vim_install"],
        }
        
        package { "vim":
          provider => dpkg,
          ensure => latest,
          source => ["/tmp/vim_install/vim_common.deb",
                     "/tmp/vim_install/vim_runtime.deb",
                     "/tmp/vim_install/vim73.deb"],
          require => File["/tmp/vim_install/vim73.deb"],
        }

      }
      else {

        package { "vim":
          ensure => purged,
        }

      }

    }

    default: { err("vim supported only in ubuntu") }
  }
}
