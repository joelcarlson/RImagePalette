#Steals from:
#https://github.com/woobe/rPlotter/blob/master/R/extract_colours.R

#Also see:
#https://github.com/lokesh/color-thief/blob/master/src/color-thief.js
read_image <- function(image_path){
  jpeg::readJPEG(image_path)
}

display_image <- function(image){
  graphics::plot(1:2, type="n", axes=F, ylab='n', xlab='n', ann=FALSE)
  graphics::rasterImage(image, 1, 1, 2, 2)
}

display_palette <- function(palette){
  barplot(rep(1, length(palette)), col=palette, names=palette, las=2, axes=F, ann=FALSE)
}










