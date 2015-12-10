#' Image palette
#'
#' Image palette function
#'
#' @param image Matrix The image from which the palette will be extracted from. Should
#' be a 3 (or more) dimensional matrix. The output of functions such as \code{readJPG()}
#' are suitable as \code{image}.
#' @param choice Function Defines how the color will be chosen from the final color cubes.
#' The default choice is to take the \code{mean} value of the image cube, but other choices
#' may return a subjectively superior scale. Try \code{median}, or \code{min}, or \code{max}, or
#' whatever summary statistic suits your fancy.
#' @param volume Logical volume controls the method for choosing which color cube to split
#' at each iteration of the algorithm. The default choice (when \code{volume = FALSE}) is to
#' choose the cube based on which cube contains the largest extent (that is, the largest range
#' of some color). When \code{volume = TRUE}, the cube with the largest volume is chosen to split.
#' Occasionally, setting to \code{TRUE} returns a better palette.
#' @export
#' @examples
#' \dontrun{
#' library(scales); library(jpeg)
#' your_image <- readJPEG("path/to/your/image.jpg")
#' show_col(image_pal(your_image)(10))
#' }
image_pal <- function(image, choice=mean, volume=FALSE) {
  function(n) {
    create_palette(image, n, choice, volume)
  }
}

#' @rdname scale_image
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#' @export
scale_color_image <- function(..., image, n=5, choice=mean, volume=FALSE, discrete=TRUE) {
  if (discrete) {
    discrete_scale("colour", "image", image_pal(image, choice, volume), ...)
  } else {
    scale_color_gradientn(colours = sort(create_palette(image, n, choice, volume)), ...)
  }
}


#' Image color scales
#'
#' Uses the image color scale.
#'
#' For \code{discrete == FALSE} (the default) all other arguments are as to
#' \link[ggplot2]{scale_fill_gradientn} or \link[ggplot2]{scale_color_gradientn}.
#' Otherwise the function will return a \code{discrete_scale} with the plot-computed
#' number of colors.
#'
#' See \link[RImagePalette]{RImagePalette} for more information on the color scale.
#'
#' @param ... parameters to \code{discrete_scale} or \code{scale_fill_gradientn}
#' @param alpha pass through parameter to \code{viridis}
#' @param discrete generate a discrete palette? (default: \code{FALSE} - generate continuous palette)
#' @rdname scale_image
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # ripped from the pages of ggplot2
#' p <- ggplot(mtcars, aes(wt, mpg))
#' p + geom_point(size=4, aes(colour = factor(cyl))) +
#'     scale_color_viridis(discrete=TRUE) +
#'     theme_bw()
#'
#' # ripped from the pages of ggplot2
#' dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
#' dsub$diff <- with(dsub, sqrt(abs(x-y))* sign(x-y))
#' d <- ggplot(dsub, aes(x, y, colour=diff)) + geom_point()
#' d + scale_color_viridis() + theme_bw()
#'
#'
#' # from the main viridis example
#' dat <- data.frame(x = rnorm(10000), y = rnorm(10000))
#'
#' ggplot(dat, aes(x = x, y = y)) +
#'   geom_hex() + coord_fixed() +
#'   scale_fill_viridis() + theme_bw()
#'
#' library(ggplot2)
#' library(MASS)
#' library(gridExtra)
#'
#' data("geyser", package="MASS")
#'
#' ggplot(geyser, aes(x = duration, y = waiting)) +
#'   xlim(0.5, 6) + ylim(40, 110) +
#'   stat_density2d(aes(fill = ..level..), geom="polygon") +
#'   theme_bw() +
#'   theme(panel.grid=element_blank()) -> gg
#'
#' grid.arrange(
#'   gg + scale_fill_viridis(option="A") + labs(x="Virdis A", y=NULL),
#'   gg + scale_fill_viridis(option="B") + labs(x="Virdis B", y=NULL),
#'   gg + scale_fill_viridis(option="C") + labs(x="Virdis C", y=NULL),
#'   gg + scale_fill_viridis(option="D") + labs(x="Virdis D", y=NULL),
#'   ncol=2, nrow=2
#' )
#' }
scale_fill_image <- function (..., image, n=5, choice=mean, volume=FALSE, discrete=TRUE) {
  if (discrete) {
    discrete_scale("fill", "image", image_pal(image, choice, volume), ...)
  } else {
    scale_fill_gradientn(colours = sort(create_palette(image, n, choice, volume)), ...)
  }
}
