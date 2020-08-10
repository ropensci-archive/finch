finch 0.4.0
===========

### BUG FIXES

* fix various package imports: `plyr` and `rappdirs` no longer needed; import `EML::read_eml` instead of the whole package; import `digest::digest` instead of whole package; import `hoardr::hoard` instead of whole package (#27)


finch 0.3.0
===========

### BUG FIXES

* fix to unit tests and `dwc_read()` for a new version of `EML` package (v0.2) (#26) thanks @cboettig


finch 0.2.0
===========

### CACHING CHANGES

Caching has changed in `finch`. We changed to using package `hoardr` for managing caching. Now with `hoardr` on the package loading we create an object that holds methods and info about where to cache, with operating specific routes. In addition, you can set your own cache directory (and we do this in examples/tests using a temp dir instead of user dir). 

The old functions `dwca_cache_delete`, `dwca_cache_delete_all`, `dwca_cache_details`, and `dwca_cache_list` are defunct and replaced with the single `dwca_cache` object. The `dwca_cache` object is an `R6` object that has methods/functions and variables. See the `?dwca_cache` and `?finch-defunct` manual files for details.

### BUG FIXES

* fix to `dwca_read()`: `...` wasn't being passed on to `data.table::fread` internally (#18) (#19) thanks @gustavobio !

### MINOR IMPROVEMENTS

* replaced Suggested package `httr` with `crul` (#16)
* using markdown docs now (#24)
* improvement to `dwca_read()` to download zip files as binary because without that wasn't working on Windows machines (#17) thanks @gustavobio !
* fix for failures on CRAN: don't write to user directory in examples/tests (#23)


finch 0.1.0
===========

### NEW FEATURES

* Released to CRAN.
