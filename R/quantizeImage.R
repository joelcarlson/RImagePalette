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
#' @importFrom RANN nn2
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
  idx <- RANN::nn2(matrix(as.numeric(rgb_palette), ncol = 3, byrow = TRUE),
                   matrix(as.numeric(col2rgb(hex_image)), ncol = 3, byrow = TRUE), k = 1)

  ## if we used nabor it would go like this:
  #lookup <- nabor::WKNNF(matrix(as.numeric(rgb_palette), ncol = 3, byrow = TRUE))
  #idx <- lookup$query(matrix(as.numeric(col2rgb(hex_image)), ncol = 3, byrow = TRUE), k = 1, eps = 0, radius = 0)

  #back to rgb to compile into image
  rgb_values <- col2rgb(pal[idx$nn.idx])

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
