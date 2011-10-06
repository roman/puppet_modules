class neo4j($source=false) {

  class { "neo4j::install":
    source => $source
  }

}
