class python-meetup::install {

  package { "python-pip":
    ensure => installed,
  }

  package { ["libxml2-dev", "libxslt-dev", "python-dev", "python-setuptools"]:
    ensure => installed,
  }

  package { "lxml":
    ensure => installed,
    provider => "pip",
    require => Package["python-pip",
                       "libxml2-dev",
                       "libxslt-dev",
                       "python-dev",
                       "python-setuptools"],
  }

  package { ["virtualenv", "httplib2", "github2", "tweepy", "redish"]:
    ensure => installed,
    provider => "pip",
    require => Package["python-pip"],
  }

}
