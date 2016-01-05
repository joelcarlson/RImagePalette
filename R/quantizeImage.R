#' Quantize image
#'
#' Quantize image into discrete colors using the median cut algorithm
#'
#' Note: This function is extremely slow for large images.
#' Takes up to 20 seconds for 500x500 image on a desktop with 2.7GHz processor and 4Gb ram.
#' @param image Matrix The image from which the palette will be extracted from. Should
#' be a 3 (or more) dimensional matrix. The output of a function such as \code{readJPG()}
#' or \code{readPNG()} are suitable as \code{image}.
#' @param n Integer The number of discrete colors to be extracted from the image.
#' @param ... Pass any of the arguments for \code{image_palette}
#' @seealso \code{\link{image_palette}}
#' @export
#' @examples
#' img <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
#' quant_img <- quantize_image(img, n=3)
#' display_image(img)
#' display_image(quant_img)
#' @importFrom grDevices col2rgb
quantize_image <- function(image, n, ...){
  dims <- dim(image)
  #convert to hex values
  hex_image <- rgb(image[,,1], image[,,2], image[,,3])
  #create image palette using median cut algorithm
  pal <- image_palette(image, n, ...)

  #Function to extract euclidean distance between
  #palette colors, and each pixel of the image
  distances <- function(palette, pixel){
    apply(palette, 2, function(x) sqrt(sum((x - pixel)^2)))

  }

  #convert hex palette to rgb
  rgb_palette <- col2rgb(pal)


  #extract the appropriate palette color based on minimum euclidean distance
  hex_values <- lapply(hex_image, function(x) pal[which.min(distances(rgb_palette, col2rgb(x)))])
  #back to rgb to compile into image
  rgb_values <- col2rgb(hex_values)

  #Extract components
  red_channel <- matrix(rgb_values[seq(1,dims[1]*dims[2]*3,3)], nrow=dims[1], ncol=dims[2], byrow=FALSE)
  green_channel <- matrix(rgb_values[seq(2,dims[1]*dims[2]*3,3)], nrow=dims[1], ncol=dims[2], byrow=FALSE)
  blue_channel <- matrix(rgb_values[seq(3,dims[1]*dims[2]*3,3)], nrow=dims[1], ncol=dims[2], byrow=FALSE)
  #Compile into image
  rgb_image = array(dim=dims)
  rgb_image[,,1] = red_channel
  rgb_image[,,2] = green_channel
  rgb_image[,,3] = blue_channel

  return(rgb_image/255)
}
