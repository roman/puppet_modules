class python-meetup::install {

  package { "python-pip":
    ensure => installed,
  }

  package { ["virtualenv", "lxml", "httplib2", "github2", "tweepy", "redish"]:
    ensure => installed,
    provider => "pip",
    require => Package["python-pip"],
  }

}
