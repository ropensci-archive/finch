finch
=======



[![Build Status](https://api.travis-ci.org/ropensci/finch.png)](https://travis-ci.org/ropensci/finch)
[![Build status](https://ci.appveyor.com/api/projects/status/rsjg02cbwfbujxn0?svg=true)](https://ci.appveyor.com/project/sckott/finch)
[![codecov.io](https://codecov.io/github/ropensci/finch/coverage.svg?branch=master)](https://codecov.io/github/ropensci/finch?branch=master)

`finch` parses Darwin Core simple and archive files

In the future, we may make it easy to create Darwin Core archive files as well.

* Darwin Core description at Biodiversity Information Standards site [http://rs.tdwg.org/dwc/](http://rs.tdwg.org/dwc/)
* Darwin Core at Wikipedia [https://en.wikipedia.org/wiki/Darwin_Core](https://en.wikipedia.org/wiki/Darwin_Core)

## Install

Stable version, from CRAN (not there yet, but soon..)


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
out <- simple(file)
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

To parse a Darwin Core Archive like can be gotten from GBIF use `dwca()`

There's an example Darwin Core Archive:


```r
file <- system.file("examples", "0000154-150116162929234.zip", package = "finch")
(out <- dwca(file, read = TRUE))
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
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/meta.xml"    
#> [2] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/metadata.xml"
#> 
#> $txt_files
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/citations.txt" 
#> [2] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/multimedia.txt"
#> [3] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/occurrence.txt"
#> [4] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/rights.txt"    
#> [5] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/verbatim.txt"  
#> 
#> $datasets_meta
#>  [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/0214a6a7-898f-4ee8-b888-0be60ecde81f.xml"
#>  [2] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/4bfac3ea-8763-4f4b-a71a-76a6f5f243d3.xml"
#>  [3] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/4edd9396-59df-4b01-9e29-dc21a59f9963.xml"
#>  [4] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/5df38344-b821-49c2-8174-cf0f29f4df0d.xml"
#>  [5] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/7a25f7aa-03fb-4322-aaeb-66719e1a9527.xml"
#>  [6] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/7c93d290-6c8b-11de-8226-b8a03c50a862.xml"
#>  [7] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/851ab8c4-f762-11e1-a439-00145eb45e9a.xml"
#>  [8] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/96ca66b4-f762-11e1-a439-00145eb45e9a.xml"
#>  [9] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/cd875b5a-b3fe-48f2-94c7-371cab1431f3.xml"
#> [10] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/dataset/d7ce3688-e91d-4f26-b2bb-333357c6da9f.xml"
#> 
#> $data_paths
#> $data_paths$core
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/occurrence.txt"
#> 
#> $data_paths$extension
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/multimedia.txt"
#> 
#> $data_paths$extension
#> [1] "/Library/Frameworks/R.framework/Versions/3.2/Resources/library/finch/examples/0000154-150116162929234/verbatim.txt"
```

High level metadata for the whole archive


```r
out$emlmeta
#> dataset:
#>   title: GBIF Occurrence Download 0000154-150116162929234
#>   creator:
#>     individualName:
#>       surName: GBIF Download Service
#>   metadataProvider:
#>     individualName:
#>       surName: GBIF Download Service
#>   associatedParty:
#>     organizationName: OZCAM (Online Zoological Collections of Australian Museums)
#>       Provider
#>     onlineUrl: http://www.ozcam.org.au/
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: MCZ
#>       surName: Harvard University
#>     organizationName: Museum of Comparative Zoology
#>     address:
#>       deliveryPoint: 26 Oxford Street
#>       city: Cambridge
#>       administrativeArea: MA
#>       postalCode: 02138
#>       country: UNITED_STATES
#>     onlineUrl: http://www.mcz.harvard.edu
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Bradley
#>       surName: Millen
#>     organizationName: Royal Ontario Museum
#>     positionName: Database Technician
#>     address:
#>       deliveryPoint: 100 Queen's Park
#>       city: Toronto
#>       administrativeArea: Ontario
#>       postalCode: M5S 2C6
#>       country: CANADA
#>     phone: 1-416-586-5899
#>     electronicMailAddress: bradm@rom.on.ca
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Rick
#>       surName: Feeney
#>     organizationName: Natural History Museum of Los Angeles County
#>     positionName: Fishes Collection Manager
#>     address:
#>       deliveryPoint: 900 Exposition Blvd.
#>       city: Los Angeles
#>       administrativeArea: CA
#>       postalCode: '90007'
#>       country: UNITED_STATES
#>     phone: +01 213 763 3374
#>     electronicMailAddress: rfeeney@nhm.org
#>     onlineUrl: http://www.nhm.org/
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       surName: MNHN
#>     organizationName: MNHN
#>     positionName: Provider
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Ben
#>       surName: Norton
#>     organizationName: North Carolina Museum of Natural Sciences
#>     positionName: Collections Data Curator
#>     address:
#>       deliveryPoint: 11 West Jones Street
#>       city: Raleigh
#>       administrativeArea: NC
#>       postalCode: '27601'
#>       country: UNITED_STATES
#>     phone: 919-707-9947
#>     electronicMailAddress: ben.norton@naturalsciences.org
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Olivia
#>       surName: Lee
#>     organizationName: University of British Columbia Herbarium
#>     positionName: Collections Manager, Bryophytes, Fungi & Lichen
#>     address:
#>       deliveryPoint: 3529-6270 University Boulevard
#>       city: Vancouver
#>       administrativeArea: British Columbia
#>       postalCode: V6T 1Z4
#>       country: CANADA
#>     phone: (604) 822-3344
#>     electronicMailAddress: olivia.lee@botany.ubc.ca
#>     onlineUrl: http://www.biodiversity.ubc.ca/museum/herbarium/
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Tom
#>       surName: Trombone
#>     organizationName: American Museum of Natural History
#>     positionName: Data Manager
#>     address:
#>       deliveryPoint: Central Park West at 79th Street
#>       city: New York
#>       administrativeArea: NY
#>       postalCode: '10024'
#>       country: UNITED_STATES
#>     phone: +01 212-313-7783
#>     electronicMailAddress: trombone@amnh.org
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       givenName: Thomas
#>       surName: Orrell
#>     organizationName: National Museum of National History, Smithsonian Institution
#>     positionName: Branch Chief, NMNH Informatics
#>     address:
#>       deliveryPoint: 12th St. and Constitution Ave. NW, MRC 136
#>       city: Washington
#>       administrativeArea: DC
#>       postalCode: 20013-7012
#>       country: UNITED_STATES
#>     phone: 202-633-2151
#>     electronicMailAddress: orrellt@si.edu
#>     onlineUrl: http://collections.mnh.si.edu
#>     role: CONTENT_PROVIDER
#>   associatedParty:
#>     individualName:
#>       surName: scottcha777
#>     role: AUTHOR
#>   associatedParty:
#>     individualName:
#>       surName: GBIF Download Service
#>     role: ORIGINATOR
#>   associatedParty:
#>     individualName:
#>       surName: GBIF Download Service
#>     role: METADATA_AUTHOR
#>   pubDate: |2
#> 
#>             2015-01-18
#>   language: ENGLISH
#>   abstract: 'A dataset containing all occurrences available in GBIF matching the query:
#>     {"type":"and","predicates":[{"type":"equals","key":"COUNTRY","value":"PR"},{"type":"equals","key":"ISSUE","value":"COORDINATE_INVALID"}]}<br/>The
#>     dataset includes records from the following constituent datasets. The full metadata
#>     for each constituent is also included in this archive:<br/>1 records from Western
#>     Australian Museum provider for OZCAM<br/>1 records from LACM Vertebrate Collection<br/>1
#>     records from AMNH Mammal Collections<br/>1 records from NMNH occurrence DwC-A<br/>2
#>     records from Molluscs collection (IM) of the Muséum national d''Histoire naturelle
#>     (MNHN - Paris)<br/>11 records from Museum of Comparative Zoology, Harvard University<br/>15
#>     records from NCSM Invertebrates Collection<br/>17 records from Herpetology Collection
#>     - Royal Ontario Museum<br/>45 records from UNSM Vertebrate Specimens<br/>349 records
#>     from University of British Columbia Herbarium (UBC) - Bryophytes Collection<br/>'
#>   intellectualRights: CC0, http://creativecommons.org/publicdomain/zero/1.0
#>   .attrs: document
#> additionalMetadata:
#>   metadata:
#>     metadata:
#>       gbif:
#>         citation:
#>           text: GBIF Occurrence Download 0000154-150116162929234
#>           .attrs: 0000154-150116162929234
#>         physical:
#>           objectName: ~
#>           characterEncoding: UTF-8
#>           dataFormat:
#>             externallyDefinedFormat:
#>               formatName: Darwin Core Archive
#>           distribution:
#>             online:
#>               url:
#>                 text: http://api.gbif.org/v1/occurrence/download/request/0000154-150116162929234.zip
#>                 .attrs: download
#> .attrs:
#> - 6cfaaf9c-d518-4ca3-8dc5-f5aadddc0390
#> - http://gbif.org
#> - system
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
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
