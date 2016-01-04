RImagePalette
=============

### Extract colors from an image, then use them in plots or for fun!

The `RImagePalette` package is a pure R implementation of the median cut algorithm for extracting the dominant colors from an image. This package lets you use the colors from an image you like to create pretty plots, or to swap colors from one image to another.

Install from [CRAN](https://cran.r-project.org/web/packages/RImagePalette/index.html) using:

``` r
install.packages("RImagePalette")
```

Or from github, using:

``` r
devtools::install_github("joelcarlson/RImagePalette")
```

Viewing Palettes
================

It's simple to create palettes from an image using the `image_palette()` function:

``` r
library(RImagePalette)

#Load an image
lifeAquatic <- jpeg::readJPEG("figs/LifeAquatic.jpg")
display_image(lifeAquatic)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/LifeAquaticCrop.jpg" />

``` r
#Create a palette of 9 colors
lifeAquaticPalette <- image_palette(lifeAquatic, n=9)
scales::show_col(lifeAquaticPalette)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticScale.png" height="50%" width="50%" />

Not happy with the results? We can tweak some settings until the scale is to our liking:

``` r
lifeAquaticPalette <- image_palette(lifeAquatic, n=9, choice=median, volume=TRUE)
scales::show_col(lifeAquaticPalette)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticScaleTweak.png" height="50%" width="50%" />

If it contains colors we like, we can pick and choose, and use them as a scale:

``` r
library(ggplot2)
#Create plot
p <- ggplot(data = iris, aes(x=Species, y=Sepal.Width, fill=Species)) + geom_bar(stat="identity")
#Apply scale
p + theme_bw() + scale_fill_manual(values=lifeAquaticPalette[c(2,3,6)])
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/lifeAquaticBars.png" />

Images as Scales
================

`RImagePalette` can create both discrete and continuous scales from images for use with `ggplot2` using the new `scale_color_image` function:

``` r
#Load an image
desert <- jpeg::readJPEG("figs/Desert.jpg")
display_image(desert)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertCrop.png" />

### Discrete Scale

``` r
#Create plot
p <- ggplot(data = iris, aes(x=Sepal.Length, y=Sepal.Width, col=Species)) + geom_point(size=3)
#Add discrete scale from image
p + theme_bw() + scale_color_image(image=desert)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertDiscrete.png" />

### Continuous Scale

``` r
#Create plot
p <- ggplot(data = iris, aes(x=Sepal.Length, y=Sepal.Width, col=Sepal.Length)) + geom_point(size=3)
#Use discrete=FALSE for a continuous scale
p + theme_bw() + scale_color_image(image=desert, discrete=FALSE) 
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/desertContinuous.png" />

Quantizing Images
=================

*Note: This feature is experimental at the moment, and as such is non-optimized, and slow. You must install from github to access the `quantize_image` function*

We can also quantize images using the `quantize_image` function:

``` r
#Load the famous mandrill
mandrill <- png::readPNG("figs/mandrill.png")

#Quantize using 7 colors
quant_mandrill <- quantize_image(mandrill, n=7)
```

When displayed closely reproduces the original image:

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/mandrill_median7.png" width="75% />

Another method for doing so is to use the kmeans approach, as discussed in [this blog post](http://blog.ryanwalker.us/2016/01/color-quantization-in-r.html) by [Ryan Walker](http://www.ms.uky.edu/~rwalker/). Here is the comparison between kmeans (on the left) and median cut (on the right) using 4 colors:

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/mandrill_k4_median4.png" width="75% />

Just for fun
============

We can swap colors across images using the `switch_colors()` function:

``` r
celery <- jpeg::readJPEG("figs/CeleryLunch.jpg")
billMurray <- jpeg::readJPEG("figs/BillMurray.jpg")
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/celeryBill2.png" width="80%" />

``` r
switch_colors(billMurray, celery, source_colors = 10)
```

<img src="https://raw.githubusercontent.com/joelcarlson/RImagePalette/master/figs/celerifiedBill2.png" height="50%" width="50%" />

### Note

There is an element of randomness in the median cut algorithm, so set your seeds carefully, and try running the algorithm a few times if you aren't happy with the results. Other ways to alter the palette: try using `choice = median`, `volume = TRUE` or change the value of `n`.

### Special Thanks

There are a number of projects that inspired or helped this project along, and they deserve some recognition:

[color-thief.js](http://lokeshdhakar.com/projects/color-thief/) by [Lokesh Dhakar](http://lokeshdhakar.com).

[Wes Anderson Palettes](https://github.com/karthik/wesanderson) by [Karthik Ram](http://inundata.org).

[this blog post](http://blenditbayes.blogspot.com/2014/05/towards-yet-another-r-colour-palette.html) from [Jo Fai Chow](http://www.jofaichow.co.uk/).

and [this blog post](http://blog.ryanwalker.us/2016/01/color-quantization-in-r.html) by [Ryan Walker](http://www.ms.uky.edu/~rwalker/)

Thank you all for your great work!
