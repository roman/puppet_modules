class vim::install {
  package { "vim":
    ensure => latest,
  }
}
