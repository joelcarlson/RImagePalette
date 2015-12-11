#' The median cut algorithm
#'
#' Cut an rgb cube into two color cubes, each with as imilar number of
#' elements.
#'
#' Represents the rgb colorspace as a cube, with side lengths
#' based on the red, green, and blue extents (difference between
#' maximum and minimum within-color values).
#'
#' The algorithm takes the side with the largest extent (extent information
#' is passed in via the \code{vbox()} parameter),
#' and splits the cube along the median value.
#'
#' Both halves of the cube are then returned.
#'
#'  @param image List An image in list form, with three components: red, green, blue
#'  @param vbox List The output of \code{vbox()} for the given image. A list of image parameters ("min", "max", "med", "ext" and "volume")
#'  @param iter Integer The number attached to the names of the two new images.
#'  @return Two new images in a list, each separated into rgb components
#'  @seealso \code{\link{vbox}} \code{\link{image_palette}}
median_cut <- function(image, vbox, iter=1){

  #find color which splits vbox on largest extent
  #Sample to randomly shuffle,
  #meaningful when there is a tie in maximum extents
  cut_color <- which.max(sample(vbox[["ext"]]))

  #Cut the extent along the median value
  #from the rgb values we make a new set that is lower than the median of the largest exent group, and one that is higher
  aboveList <- lapply(image, function(color_channel){
    color_channel[which(image[[names(cut_color)]] >= vbox$med[[names(cut_color)]])]
  })
  belowList <- lapply(image, function(color_channel){
    color_channel[which(image[[names(cut_color)]] < vbox$med[[names(cut_color)]])]
  })

  above <- paste0("A", iter)
  below <- paste0("B", iter)
  cut_image <- list()
  cut_image[[above]] <- aboveList
  cut_image[[below]] <- belowList
  return(cut_image)
}
