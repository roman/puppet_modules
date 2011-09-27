class vim::install($compile) {

  if $compile {

    vim::compile { "compile-and-install-vim": }

  }
  else {

    case $operatingsystem {

      "Ubuntu": {

        package { ["vim", "vim-nox"]:
          ensure => latest,
        }

      } 

      "Archlinux": {

        package { "vim":
          ensure => latest,
        }

      }

    }

  }
}
