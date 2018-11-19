finch
=====



[![Build Status](https://api.travis-ci.org/ropensci/finch.png)](https://travis-ci.org/ropensci/finch)
[![Build status](https://ci.appveyor.com/api/projects/status/rsjg02cbwfbujxn0?svg=true)](https://ci.appveyor.com/project/sckott/finch)
[![cran checks](https://cranchecks.info/badges/worst/finch)](https://cranchecks.info/pkgs/finch)
[![codecov.io](https://codecov.io/github/ropensci/finch/coverage.svg?branch=master)](https://codecov.io/github/ropensci/finch?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/finch)](https://cran.r-project.org/package=finch)

`finch` parses Darwin Core simple and archive files

In the future, we may make it easy to create Darwin Core archive files as well.

* Darwin Core description at Biodiversity Information Standards site [http://rs.tdwg.org/dwc/](http://rs.tdwg.org/dwc/)
* Darwin Core at Wikipedia [https://en.wikipedia.org/wiki/Darwin_Core](https://en.wikipedia.org/wiki/Darwin_Core)

## Install

Stable version


```r
install.packages("finch")
```

Development version, from GitHub


```r
devtools::install_github("ropensci/finch")
```


```r
library("finch")
```

## Parse

To parse a simple darwin core file like

```
<?xml version="1.0" encoding="UTF-8"?>
<SimpleDarwinRecordSet
 xmlns="http://rs.tdwg.org/dwc/xsd/simpledarwincore/"
 xmlns:dc="http://purl.org/dc/terms/"
 xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://rs.tdwg.org/dwc/xsd/simpledarwincore/ ../../xsd/tdwg_dwc_simple.xsd">
 <SimpleDarwinRecord>
  <dwc:occurrenceID>urn:catalog:YPM:VP.057488</dwc:occurrenceID>
  <dc:type>PhysicalObject</dc:type>
  <dc:modified>2009-02-12T12:43:31</dc:modified>
  <dc:language>en</dc:language>
  <dwc:basisOfRecord>FossilSpecimen</dwc:basisOfRecord>
  <dwc:institutionCode>YPM</dwc:institutionCode>
  <dwc:collectionCode>VP</dwc:collectionCode>
  <dwc:catalogNumber>VP.057488</dwc:catalogNumber>
  <dwc:individualCount>1</dwc:individualCount>
  <dwc:locationID xsi:nil="true"/>
  <dwc:continent>North America</dwc:continent>
  <dwc:country>United States</dwc:country>
  <dwc:countryCode>US</dwc:countryCode>
  <dwc:stateProvince>Montana</dwc:stateProvince>
  <dwc:county>Garfield</dwc:county>
  <dwc:scientificName>Tyrannosourus rex</dwc:scientificName>
  <dwc:genus>Tyrannosourus</dwc:genus>
  <dwc:specificEpithet>rex</dwc:specificEpithet>
  <dwc:earliestPeriodOrHighestSystem>Creataceous</dwc:earliestPeriodOrHighestSystem>
  <dwc:latestPeriodOrHighestSystem>Creataceous</dwc:latestPeriodOrHighestSystem>
  <dwc:earliestEonOrHighestEonothem>Late Cretaceous</dwc:earliestEonOrHighestEonothem>
  <dwc:latestEonOrHighestEonothem>Late Cretaceous</dwc:latestEonOrHighestEonothem>
 </SimpleDarwinRecord>
</SimpleDarwinRecordSet>
```

This file is in this package as an example file, get the file, then `simple()`


```r
file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
out <- simple_read(file)
```

Index to `meta`, `dc` or `dwc`


```r
out$dc
#> [[1]]
#> [[1]]$type
#> [1] "PhysicalObject"
#> 
#> 
#> [[2]]
#> [[2]]$modified
#> [1] "2009-02-12T12:43:31"
#> 
#> 
#> [[3]]
#> [[3]]$language
#> [1] "en"
```

## Parse Darwin Core Archive

To parse a Darwin Core Archive like can be gotten from GBIF use `dwca_read()`

There's an example Darwin Core Archive:


```r
file <- system.file("examples", "0000154-150116162929234.zip", package = "finch")
(out <- dwca_read(file, read = TRUE))
#> <gbif dwca>
#>   Package ID: 6cfaaf9c-d518-4ca3-8dc5-f5aadddc0390
#>   No. data sources: 10
#>   No. datasets: 3
#>   Dataset occurrence.txt: [225 X 443]
#>   Dataset multimedia.txt: [15 X 1]
#>   Dataset verbatim.txt: [209 X 443]
```

List files in the archive


```r
out$files
#> $xml_files
#> [1] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/meta.xml"    
#> [2] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/metadata.xml"
#> 
#> $txt_files
#> [1] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/citations.txt" 
#> [2] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/multimedia.txt"
#> [3] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/occurrence.txt"
#> [4] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/rights.txt"    
#> [5] "/Users/sckott/Library/Caches/R/finch/0000154-150116162929234/verbatim.txt"  
...
```

High level metadata for the whole archive


```r
out$emlmeta
#> <eml packageId="6cfaaf9c-d518-4ca3-8dc5-f5aadddc0390" system="http://gbif.org" scope="system" xml:lang="en" xsi:schemaLocation="eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/1.0.2/eml.xsd">
#>   <dataset>
#>     <title>GBIF Occurrence Download 0000154-150116162929234</title>
#>     <creator>
#>       <individualName>
#>         <surName>GBIF Download Service</surName>
#>       </individualName>
#>     </creator>
#>     <metadataProvider>
#>       <individualName>
#>         <surName>GBIF Download Service</surName>
#>       </individualName>
#>     </metadataProvider>
#>     <associatedParty>
#>       <organizationName>OZCAM (Online Zoological Collections of Australian Museums) Provider</organizationName>
#>       <onlineUrl>http://www.ozcam.org.au/</onlineUrl>
#>       <role>CONTENT_PROVIDER</role>
#>     </associatedParty>
#>     <associatedParty>
#>       <individualName>
...
```

High level metadata for each data file, there's many files, but we'll just look at one


```r
hm <- out$highmeta
head( hm$occurrence.txt )
#>   index                                        term delimitedBy
#> 1     0         http://rs.gbif.org/terms/1.0/gbifID        <NA>
#> 2     1           http://purl.org/dc/terms/abstract        <NA>
#> 3     2       http://purl.org/dc/terms/accessRights        <NA>
#> 4     3      http://purl.org/dc/terms/accrualMethod        <NA>
#> 5     4 http://purl.org/dc/terms/accrualPeriodicity        <NA>
#> 6     5      http://purl.org/dc/terms/accrualPolicy        <NA>
```

You can get the same metadata as above for each dataset that went into the tabular dataset downloaded


```r
out$dataset_meta[[1]]
```

View one of the datasets, brief overview.


```r
head( out$data[[1]][,c(1:5)] )
#>      gbifID abstract accessRights accrualMethod accrualPeriodicity
#> 1  50280003       NA                         NA                 NA
#> 2 477550574       NA                         NA                 NA
#> 3 239703844       NA                         NA                 NA
#> 4 239703843       NA                         NA                 NA
#> 5 239703833       NA                         NA                 NA
#> 6 477550692       NA                         NA                 NA
```

You can also give `dwca()` a local directory, or url that contains a Darwin Core Archive.

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/finch/issues).
* License: MIT
* Get citation information for `finch` in R doing `citation(package = 'finch')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
