class vim::install {
  include apt

  case $operatingsystem {

    # This is to install vim from packages, however
    # this won't install ruby extensions, that are needed for some plugins

    "Ubuntu": {
      if versioncmp($operatingsystemrelease, '11.04') < 0 {

        vim::compile { "compile-and-install-vim": }

      }
      else {

        package { ["vim", "vim-nox"]:
          ensure => latest,
          require => Class["apt::update"]
        }

      }


    } # End Ubuntu

    default: {

      vim::compile { "compile-and-install-vim": }

    } # end default
  }
}
