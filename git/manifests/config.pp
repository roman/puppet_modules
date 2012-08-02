define git::config($user, $value) {
  include git::install

  $section   = regsubst($name, '(\w+)\.(\w+)', '\[\1\]')
  $attribute = regsubst($name, '(\w+)\.(\w+)', '\2 = ${value}')

  exec { "git::config/git-config-${name}":
    path => ["/bin", "/usr/bin"],
    cwd => "/home/$user/",
    user => $user,
    group => $user,
    command => "git config --file /home/$user/.gitconfig ${name} '${value}'",
    unless  => "cat /home/$user/.gitconfig | grep -A5 \"$section\" | grep \"$attribute\"",
    require => Class["git::install"],
  }
}
