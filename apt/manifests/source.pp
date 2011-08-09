define apt::source {
  exec { "adding source $name":
    path => ["/bin", "/usr/bin", "/usr/local/bin"],
    cwd => "/etc/apt/",
    command => "printf \"$name\n\" | tee -a sources.list",
    unless => "cat sources.list | grep '$name'",
    before => Class["apt::update"],
  }
}
