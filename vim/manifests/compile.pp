define vim::compile() {
  $source_url = "ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2"

  Exec {
    path => ["/bin", "/usr/bin", "/usr/local/bin", "/opt/ruby/bin"],
    logoutput => true,
  }

  package { "build-essential":
    ensure => installed,
  }

  exec { "download-vim":
    cwd  => "/tmp",
    command => "wget $source_url",
    creates => "/tmp/vim-7.3.tar.bz2",
    unless  => "test -s /usr/local/bin/vim && vim --version | head -n1 | grep '7.3'",
    require => Package["build-essential"],
  }

  exec { "extract-vim":
    cwd => "/tmp",
    command => "tar -xvjf vim-7.3.tar.bz2",
    creates => "/tmp/vim73",
    require => Exec["download-vim"],
  }

  exec { "remove-vim-default-config":
    cwd => "/tmp/vim73/src/auto",
    command => "rm config.h",
    onlyif => "test -e /tmp/vim73/src/auto/config.h",
    before => Exec["configure-vim"],
    require => Exec["extract-vim"],
  }

  exec { "configure-vim":
    cwd => "/tmp/vim73",
    command => "bash -c './configure --with-features=huge \
--enable-multibyte --enable-rubyinterp \
--enable-pythoninterp=yes --disable-netbeans'",
    creates => "/tmp/vim73/src/auto/config.h",
    require => Exec["extract-vim"],
  }

  exec { "install-vim":
    cwd => "/tmp/vim73",
    command => "make && make install",
    creates => "/usr/local/bin/vim",
    require => Exec["configure-vim"],
  }

  exec { "clean-vim-installation":
    cwd => "/tmp",
    command => "rm -rf vim73 && rm vim-7.3.tar.bz2",
    require => Exec["install-vim"],
  }

}
