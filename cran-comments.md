## Release summary

 - Fixed issue with cran submission where several functions (barplot, colorRampPalette, image, median, rgb) were not imported from their respective packages.
 Specifically, added the following to NAMESPACE:

>  importFrom(grDevices,colorRampPalette)  
>  importFrom(graphics,barplot)  
>  importFrom(graphics,image)  
>  importFrom(stats,median)
  
 - Removed `\dontrun{}` tags from examples

## Test environments

* local Ubuntu 14.04 LTS install, R 3.2.2
* local Windows 7 install, R 3.1.3
* win-builder 

## R CMD check results

There were no NOTES, ERRORs or WARNINGs.

## Downstream dependencies

None to report
