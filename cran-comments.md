## R CMD check results

0 errors | 0 warnings | 0 notes

* This is an update to the CRAN version (0.2.0).

The readers re-exported from 'actiread' are now true re-exports
(documented in `?reexports`) rather than copies with their own Rd files.
This removes the code/documentation mismatch that the upcoming 'actiread'
release (which renames the readers' `file` argument to `path`) would
otherwise cause.  This version passes with both the CRAN 'actiread' (0.5.0)
and the upcoming 'actiread' 0.9.0.
