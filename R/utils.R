#' Display color image
#'
#' Convenience wrapper to create a raster image of the image
#' you wish to extract the palette from.
#'
#' @param image Matrix The image from which the palette will be extracted from. Should
#' be a 3 (or more) dimensional matrix. The output of functions such as \code{readJPG()}
#' are suitable as \code{image}.
#' @return A raster image in the plot window.
#' @export
#' @examples
#' \dontrun{
#' library(jpeg)
#' your_image <- readJPEG("path/to/your/image.jpg")
#' display_image(your_image)
#' }
display_image <- function(image){
  graphics::plot(1:2, type="n", axes=F, ylab='n', xlab='n', ann=FALSE)
  graphics::rasterImage(image, 1, 1, 2, 2)
}

#' Display color palette
#'
#' Displays the created palette as a barchar with axis labels
#' representing hex values of the colors. A more attractive method
#' for doing so would be to use \code{show_cols()} from
#' \code{library(scales)}.
#'
#' @param palette Vector The output of \code{create_palette}.
#' @return A plot of the colors extracted from the image
#' @seealso \code{scales::show_cols()}
#' @export
#' @examples
#' \dontrun{
#' library(jpeg)
#' your_image <- readJPEG("path/to/your/image.jpg")
#' display_palette(create_palette(your_image, n=5))
#' }
display_palette <- function(palette){
  barplot(rep(1, length(palette)), col=palette, names=palette, las=2, axes=F, ann=FALSE)
}










