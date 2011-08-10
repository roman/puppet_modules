class vim::install {
  include apt

  case $operatingsystem {

    # This is to install vim from packages, however
    # this won't install ruby extensions, that are needed for some plugins

    "Ubuntu": {
      if versioncmp($operatingsystemrelease, '11.04') < 0 {

        # before natty, we had vim7.2 on the sources
        # we are going to modify the sources and do some
        # pinning on the vim packages we need.

        # We remove conflicting packages first
        package { ["ubuntu-minimal", "vim-tiny"]:
          ensure => purged,
          before => [Apt::Source["deb http://us.archive.ubuntu.com/ubuntu/ natty main restricted"],
                     Apt::Source["deb http://us.archive.ubuntu.com/ubuntu/ natty universe"]
                    ],
        }

        # We add the natty source
        apt::source {
          "deb http://us.archive.ubuntu.com/ubuntu/ natty main restricted":
        }
        apt::source {
          "deb http://us.archive.ubuntu.com/ubuntu/ natty universe":
        }

        # We put a pinning for all packages natty and
        # set a value of -100 so that they are not the
        # default ones
        apt::release_pinning { "natty": }

        # We do pinning of the packages we need, in this case
        # the vim ones and ruby ones
        apt::pinning { "vim":
          release  => "natty",
          priority => "900",
        }
        apt::pinning { "vim-runtime":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "vim-common":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "vim-nox":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "ruby1.8":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "libruby1.8":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "ncurses-bin":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "libncurses5":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "libncurses5-dev":
          release => "natty",
          priority => "900",
        }
        apt::pinning { "libssl0.9.8":
          release => "natty",
          priority => "900",
        }

        package { ["vim", "vim-nox"]:
          ensure => latest,
          require => [Apt::Pinning["vim"],
                      Apt::Pinning["vim-runtime"],
                      Apt::Pinning["vim-common"],
                      Apt::Pinning["vim-nox"],
                      Apt::Pinning["ruby1.8"],
                      Apt::Pinning["libruby1.8"],
                      Apt::Pinning["ncurses-bin"],
                      Apt::Pinning["libncurses5"],
                      Apt::Pinning["libncurses5-dev"],
                      Apt::Pinning["libssl0.9.8"],
                      Apt::Release_pinning["natty"]],
        }

      } # End Older than natty
      else {

        package { ["vim", "vim-nox"]:
          ensure => latest,
        }

      }


    } # End Ubuntu

    default: {
      # Do it from source
      $source_url = "ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2"

      Exec {
        path => ["/bin", "/usr/bin", "/usr/local/bin", "/opt/ruby/bin"],
        logoutput => true,
      }

      package { "build-essential":
        ensure => installed,
      }

      exec { "download vim":
        cwd  => "/tmp",
        command => "wget $source_url",
        creates => "/tmp/vim-7.3.tar.bz2",
        unless  => "test -s /usr/local/bin/vim && vim --version | head -n1 | grep '7.3'",
        require => Package["build-essential"],
      }

      exec { "extract vim":
        cwd => "/tmp",
        command => "tar -xvjf vim-7.3.tar.bz2",
        creates => "/tmp/vim73",
        require => Exec["download vim"],
      }

      exec { "remove vim default config":
        cwd => "/tmp/vim73/src/auto",
        command => "rm config.h",
        onlyif => "test -e /tmp/vim73/src/auto/config.h",
        before => Exec["configure vim"],
        require => Exec["extract vim"],
      }

      exec { "configure vim":
        cwd => "/tmp/vim73",
        command => "bash -c './configure --with-features=huge \
--enable-multibyte --enable-rubyinterp \
--enable-pythoninterp=yes --disable-netbeans'",
        creates => "/tmp/vim73/src/auto/config.h",
        require => Exec["extract vim"],
      }

      exec { "install vim":
        cwd => "/tmp/vim73",
        command => "make && make install",
        creates => "/usr/local/bin/vim",
        require => Exec["configure vim"],
      }

      exec { "clean vim installation":
        cwd => "/tmp",
        command => "rm -rf vim73 && rm vim-7.3.tar.bz2",
        require => Exec["install vim"],
      }

    } # end default
  }
}
