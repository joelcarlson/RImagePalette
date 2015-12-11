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
#' Displays the created palette as a barchart with axis labels
#' representing hex values of the colors. A more attractive method
#' for doing so would be to use \code{show_cols()} from
#' \code{library(scales)}.
#'
#' @param palette Vector The output of \code{image_palette}.
#' @return A plot of the colors extracted from the image
#' @seealso \code{scales::show_cols()}
#' @export
#' @examples
#' \dontrun{
#' library(jpeg)
#' your_image <- readJPEG("path/to/your/image.jpg")
#' display_palette(image_palette(your_image, n=5))
#' }
display_palette <- function(palette){
  barplot(rep(1, length(palette)), col=palette, names=palette, las=2, axes=F, ann=FALSE)
}

#' Swap Colors in an Image
#'
#' Swap the palette of an image!
#'
#' @param target_image Matrix The image you wish to transfer colors into.
#' The output from \code{readJPEG} is of suitable format.
#' @param source_image Matrix The image you wish to transfer colors from.
#' @param source_colors Integer The number of colors you wish to extract from the
#' source image.
#' @param smoothness Integer The source colors get interpolated so that the image
#' doesn't appear blocky. The higher the value, the smoother the output.
#' @param ... Pass any of the arguments for \code{image_palette}
#' @return The image, but with swapped colors!
#' @export
#' @examples
#' \dontrun{
#' library(jpeg)
#' america <- jpeg::readJPEG("path/to/flagImage/AmericanFlag.jpg")
#' obama <- jpeg::readJPEG("path/to/obamaImage/Obama.jpg")
#' switch_colors(obama, america)
#' }
switch_colors <- function(target_image, source_image, source_colors=3, smoothness=100, ...){
  #Create palette from image
  palette <- image_palette(source_image, n=source_colors, ...)
  palette <- sort(palette)
  palette <- colorRampPalette(colors=palette)

  #Flop the image about so that it displays in the correct orientation
  target_image <- t(target_image[dim(target_image[,,1])[1]:1,,1])
  image(target_image, col=palette(smoothness), useRaster=TRUE, axes=F, ann=FALSE, asp=dim(target_image)[2]/dim(target_image)[1])
}









