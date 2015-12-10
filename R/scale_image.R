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

#' @rdname scale_image
#' @export
scale_colour_image <- scale_color_image


#' Image color scales
#'
#' Uses the image color scale.
#'
#' For \code{discrete == TRUE} (the default) the function will return a \code{discrete_scale} with the plot-computed
#' number of colors. All other arguments are as to
#' \link[ggplot2]{scale_fill_gradientn} or \link[ggplot2]{scale_color_gradientn}.
#'
#' See \link{create_palette} for more information on the color scale.
#'
#' @param ... parameters to \code{discrete_scale} or \code{scale_fill_gradientn}
#' @param image pass through parameter to \code{create_palette}
#' @param n For continuous color scales, you may optionally pass in an integer, n.
#' This allows some control over the scale, if n is too large the scale has too many
#' colors and ceases to be meaningul. n = 3 to n = 5 is recommended.
#' @param choice pass through parameter to \code{create_palette}
#' @param volume pass through parameter to \code{create_palette}
#' @param discrete generate a discrete palette? (default: \code{FALSE} - generate continuous palette)
#' @rdname scale_image
#' @seealso \code{\link{median_cut}} \code{\link{create_palette}} \code{\link{vbox}}
#' \code{\link{display_image}}
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#'
#' # ripped from the pages of ggplot2
#' your_image <- readJPEG("path/to/your/image.jpg")
#' display_image(your_image)
#' p <- ggplot(mtcars, aes(wt, mpg))
#' p + geom_point(size=4, aes(colour = factor(cyl))) +
#'     scale_color_image(image = your_image) +
#'     theme_bw()
#'
#' dsub <- subset(diamonds, x > 5 & x < 6 & y > 5 & y < 6)
#' dsub$diff <- with(dsub, sqrt(abs(x-y))* sign(x-y))
#' d <- ggplot(dsub, aes(x, y, colour=diff)) + geom_point()
#' d + scale_color_image(image = your_image, discrete=FALSE) + theme_bw()
#'
#'
#' }
scale_fill_image <- function (..., image, n=5, choice=mean, volume=FALSE, discrete=TRUE) {
  if (discrete) {
    discrete_scale("fill", "image", image_pal(image, choice, volume), ...)
  } else {
    scale_fill_gradientn(colours = sort(create_palette(image, n, choice, volume)), ...)
  }
}
