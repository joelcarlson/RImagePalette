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

scale_fill_image <- function (..., image, n=5, choice=mean, volume=FALSE, discrete=TRUE) {
  if (discrete) {
    discrete_scale("fill", "image", image_pal(image, choice, volume), ...)
  } else {
    scale_fill_gradientn(colours = sort(create_palette(image, n, choice, volume)), ...)
  }
}
