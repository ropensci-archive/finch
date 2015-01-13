docplyr
=======



`docplyr` is an R client for Simplified document database manipulation and analysis.

## Installation


```r
# install.packages("devtools")
devtools::install_github("sckott/docplyr")
```


```r
library("docplyr")
```

## Setup connection to database

Elasticsearch


```r
src_elastic()
#> src: elasticsearch 1.4.0 [http://127.0.0.1/9200]
#> indices: leothedog, gbif, gbifnewgeo, leothelion, plosmore, leotheadfadf, plos,
#>      mapuris, shakespeare
```

CouchDB


```r
src_couchdb()
#> src: couchdb 1.6.0 [localhost/5984]
#> databases: _replicator, _users, alm_couchdb, cachecall, hello_earth,
#>      leothelion, leothelion2, mapuris, mran, mydb, newdbs, newnew, sofadb
```
