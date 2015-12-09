read_image <- function(image_path){
  jpeg::readJPEG(image_path)
}

#-----------------------------------------------------------------------#
#    Stuff works below here
#-----------------------------------------------------------------------#
#Things i want to be able to do:
# specify if i want to return the mean, median, or random color from
# the final vboxes

test <- read_image("tests/testthat/test.jpg")
testlist <- list("red"=test[,,1], "green"=test[,,2], "blue"=test[,,3])

vbox <- function(im){
  #Red
  r1 <- min(im$red)
  r2 <- max(im$red)
  rmed <- median(im$red)
  rext <- r2- r1
  #Green
  g1 <- min(im$green)
  g2 <- max(im$green)
  gmed <- median(im$green)
  gext <- g2 - g1
  #Blue
  b1 <- min(im$blue)
  b2 <- max(im$blue)
  bmed <- median(im$blue)
  bext <- b2 - b1

  volume <- rext * gext * bext
  return(list("min"=list("red" = r1, "green" = g1, "blue" = b1),
              "max"=list("red" = r2, "green" = g2, "blue" = b2),
              "med"=list("red" = rmed, "green" = gmed, "blue" = bmed),
              "ext"=list("red" = rext, "green" = gext, "blue" = bext),
              "volume"=volume))
}

#Need function to take an im, build the vbox, and return the two (split on largest extent) images
#' param im list of r g b arrays (e.g. testlist <- list("red"=test[,,1], "green"=test[,,2], "blue"=test[,,3]))
median_cut <- function(im){
  im_vbox <- vbox(im)
  #split vbox on largest extent
  #Sample to randomly shuffle,
  #meaningful when there is a tie in maximum extents
  cut_color <- which.max(sample(im_vbox[["ext"]]))

  #Cut the extent along the median value
  #from the rgb values we make a new set that is lower than the median of the largest exent group, and one that is higher
  aboveList <- lapply(im, function(color_channel){
    color_channel[which(im[[names(cut_color)]] > im_vbox$med[[names(cut_color)]])]
  })
  belowList <- lapply(im, function(color_channel){
    color_channel[which(im[[names(cut_color)]] < im_vbox$med[[names(cut_color)]])]
  })

  return(list("A" = aboveList, "B" = belowList))
}

testmedcut <- median_cut(testlist)
