## Release summary

Fixed issue with cran submission where several functions (barplot, colorRampPalette, image, median, rgb) were not imported from their respective packages.

Specifically, added:

  importFrom(grDevices,colorRampPalette)

  importFrom(grDevices,rgb)

  importFrom(graphics,barplot)

  importFrom(graphics,image)

  importFrom(stats,median)

to NAMESPACE.

## Test environments

* local Ubuntu 14.04 LTS install, R 3.2.2
* win-builder 

## R CMD check results

There were no NOTES, ERRORs or WARNINGs.

## Downstream dependencies

None to report
