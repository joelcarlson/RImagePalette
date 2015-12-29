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
#' img <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
#' display_image(img)
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
#' img <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
#' display_palette(image_palette(img, n=5))
#'@importFrom graphics barplot
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
#' @param smoothness Integer The source colors are interpolated such that the image
#' doesn't appear blocky. The value of smoothness determines how many values are interpoloated
#' between the source_colors. That is, smoothness determines the length of the palette used.
#' Higher values return smoother images.
#' @param ... Pass any of the arguments for \code{image_palette}
#' @return The image, but with swapped colors!
#' @export
#' @examples
#' #Trivial example of using only 5 dominant colors
#' # from an image to recolor itself
#' img1 <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
#' img2 <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
#' switch_colors(img1, img2, source_colors=5, smoothness=20)
#'@importFrom graphics image
#'@importFrom grDevices colorRampPalette
switch_colors <- function(target_image, source_image, source_colors=3, smoothness=100, ...){
  #Create palette from image
  palette <- image_palette(source_image, n=source_colors, ...)
  palette <- sort(palette)
  palette <- colorRampPalette(colors=palette)

  #Flop the image about so that it displays in the correct orientation
  target_image <- t(target_image[dim(target_image[,,1])[1]:1,,1])
  image(target_image, col=palette(smoothness), useRaster=TRUE, axes=F, ann=FALSE, asp=dim(target_image)[2]/dim(target_image)[1])
}









