Ever wonder what Bill Murray might look like if he were the same colors as a bowl of celery?

Perhaps you've been curious about how that bowl of celery might look if it was, say, the color of the American flag...

What if I told you these daily quandaries had been solved?

**Search no more for you answers! Read on to discover the answers to these, and more!**

RImagePalette: Extract colors from an image, and use it in plots or for fun!
============================================================================

The `RImagePalette` package lets you use the colors from an image you like to create pretty plots.

This package is available from [CRAN](https://cran.r-project.org/web/packages/RImagePalette/index.html) using:

``` r
install.packages("RImagePalette")
library(RImagePalette)
```

Just for fun
============

``` r
america <- jpeg::readJPEG("figs/AmericanFlag.jpg")
obama <- jpeg::readJPEG("figs/Obama.jpg")
switch_colors(obama, america, source_colors=5, smoothness=500)
```

![](figs/README-unnamed-chunk-4-1.png)

``` r
celery <- jpeg::readJPEG("figs/Lunch.jpg")
billMurray <- jpeg::readJPEG("figs/LifeAquatic.jpg")
set.seed(10)
switch_colors(billMurray, celery, source_colors = 5, choice=median)
```

![](figs/README-unnamed-chunk-5-1.png)

Inspiration:
============

<https://github.com/lokesh/color-thief/blob/master/src/color-thief.js>

<https://github.com/karthik/wesanderson>

<http://www.r-bloggers.com/towards-yet-another-r-colour-palette-generator-step-one-quentin-tarantino/>
