Ever wonder what Bill Murray might look like if he consisted of the same colors as a plate of celery?

Perhaps you've been curious as to how you might make your ggplots resemble your favorite desert vista...

*Search no more, for here lay your answers! Read on to discover the solutions to these daily quandaries!*

RImagePalette
=============

### Extract colors from an image, then use them in plots or for fun!

The `RImagePalette` package is a pure R implementation of the median cut algorithm for extracting the dominant colors from images. This package lets you use the colors from an image you like to create pretty plots, or to swap colors from one image to another.

Note: There is an element of randomness in the median cut algorithm, so set your seeds carefully, and try running the algorithm a few times if you aren't happy with the results.

This package is available from [CRAN](https://cran.r-project.org/web/packages/RImagePalette/index.html) using:

``` r
install.packages("RImagePalette")
```

Or from github, using:

``` r
devtools::install_github("joelcarlson/RImagePalette")

library(RImagePalette)
```

\`\`\`

Viewing Palettes
================

It's simple to create palettes from an image using the `image_palette()` function. Let's use the `show_col` function from `scales` to take a look:

``` r
library(scales)
lifeAquatic <- jpeg::readJPEG("figs/LifeAquatic.jpg")
display_image(lifeAquatic)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/LifeAquaticCrop.jpg" />

``` r
lifeAquaticPalette <- image_palette(lifeAquatic, n=9)
lifeAquaticPalette
#> [1] "#D0DFDB" "#E1D56F" "#AAAC98" "#AD8A57" "#ADA033" "#826A2A" "#3B7976"
#> [8] "#373E2C" "#1A170E"
```

``` r
scales::show_col(lifeAquaticPalette)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticScale.png" height="50%" width="50%" />

Not happy with the results? We can tweak some settings until the scale is to our liking:

``` r
lifeAquaticPalette <- image_palette(lifeAquatic, n=9, choice=median, volume=TRUE)
scales::show_col(lifeAquaticPalette)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticScaleTweak.png" height="50%" width="50%" />

If it contains colors we like, we can pick and choose, and use them in a manual scale:

``` r
p <- ggplot(data = iris, aes(x=Species, y=Sepal.Width, fill=Species)) + geom_bar(stat="identity")
p + theme_bw() + scale_fill_manual(values=lifeAquaticPalette[c(2,3,6)])
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticBars.png" />

Images as Scales
================

Here's a common situation: you've just made a plot using your favorite plotting package, `ggplot2`, but just can't find the right colors to represent the points. While contemplating your dilemma, your mind drifts off to a wonderful photo of the desert you took last week. What should you do?

Why not combine the two thoughts? The `RImagePalette` package let's you do just that:

First, load your image:

``` r
desert <- jpeg::readJPEG("figs/Desert.jpg")
display_image(desert)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertCrop.png" />

Then plot it using the new `scale_color_image`:

``` r
#Create your plot, and use scale_color_image:
library(ggplot2)
p <- ggplot(data = iris, aes(x=Sepal.Length, y=Sepal.Width, col=Species)) + geom_point(size=3)
p + theme_bw() + scale_color_image(image=desert)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertDiscrete.png" />

Images as Continuous Scales
===========================

Often times, discrete scales aren't what you need. Using `discrete = FALSE` in the scale, we can use linear interpolation to create a reasonable scale.

``` r
p <- ggplot(data = iris, aes(x=Sepal.Length, y=Sepal.Width, col=Petal.Length)) + geom_point(size=3)
# n is the (optional) number of colors extracted from the image
p + theme_bw() + scale_color_image(image=desert, discrete=FALSE, n=3) 
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertContinuous.png" />

Just for fun
============

You didn't think I forgot about old Bill and his celery plate complexion, did you?

We can swap colors across images using the `switch_colors()` function:

``` r
celery <- jpeg::readJPEG("figs/CeleryLunch.jpg")
billMurray <- jpeg::readJPEG("figs/BillMurray.jpg")
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/celeryBill2.png" height="60%" width="60%" />

``` r
switch_colors(billMurray, celery, source_colors = 10)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/celerifiedBill2.png" height="50%" width="50%" />

Well, maybe more "carrots and plate" complexion...

Let's see what Barack Obama might look like on the 4th of July this year:

``` r
america <- jpeg::readJPEG("figs/AmericanFlag.jpg")
obama <- jpeg::readJPEG("figs/Obama.jpg")
switch_colors(obama, america, source_colors=4, smoothness=100)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/Obamerica.png" height="50%" width="50%" />

### Special Thanks

There are a number of projects that inspired, and helped this project along, and they deserve some recognition:

[color-thief.js](http://lokeshdhakar.com/projects/color-thief/) by [Lokesh Dhakar](http://lokeshdhakar.com).

[Wes Anderson Palettes](https://github.com/karthik/wesanderson) by [Karthik Ram](http://inundata.org).

And [this post](http://blenditbayes.blogspot.com/2014/05/towards-yet-another-r-colour-palette.html) from [Jo Fai Chow](http://www.jofaichow.co.uk/).

Thank you all for your great work!
