class vim::install {
  include apt

  case $operatingsystem {

    "Ubuntu": {
      if versioncmp($operatingsystemrelease, '11.04') < 0 {
        # before natty, we had vim7.2 on the sources
        # we are going to modify the sources and do some 
        # pinning on the vim packages we need.

        # We remove conflicting packages first
        package { ["ubuntu-minimal", "vim-tiny", "vim-common"]:
          ensure => purged,
        }

        # We add the natty source
        apt::source { 
          "deb http://us.archive.ubuntu.com/ubuntu/ natty main restricted":
        }

        # We put a pinning for all packages natty and
        # set a value of -100 so that they are not the 
        # default ones
        apt::release_pinning { "natty": }

        # We do pinning of the packages we need, in this case
        # the vim ones
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


      } # End Older than natty

      package { "vim":
        ensure => latest,
      }

    } # End Ubuntu

    default: { err("vim supported only in ubuntu") }
  }
}
