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

  #convert hex palette to rgb
  rgb_palette <- col2rgb(pal)

  #extract the appropriate palette color based on minimum euclidean distance
  nn.idx <- index_palette(matrix(image, ncol = 3) * 255, t(rgb_palette))
  #back to rgb to compile into image
  rgb_values <- col2rgb(pal[nn.idx])

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


#' Index a palette from existing colour values
#'
#' Returns the index of the nearest RGB value from a given palettized version.
#'
#' @param rgb_val matrix of RGB values
#' @param rgb_pal matrix of RGB palette
#'
#' @return index of `rgb_val` in `rgb_pal`
#' @export
#' @importFrom RANN nn2
index_palette <- function(rgb_val, rgb_pal) {
  as.vector(RANN::nn2(matrix(as.numeric(rgb_pal), ncol = 3, byrow = FALSE),
                   matrix(as.numeric(rgb_val), ncol = 3, byrow = FALSE), k = 1)$nn.idx)

  ## if we used nabor it would go like this:
  #lookup <- nabor::WKNNF(matrix(as.numeric(rgb_pal), ncol = 3, byrow = TRUE))
  #idx <- lookup$query(matrix(as.numeric(rgb_pal), ncol = 3, byrow = TRUE), k = 1, eps = 0, radius = 0)

}
