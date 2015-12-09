# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
#' @useDynLib rPalette
#' @importFrom Rcpp sourceCpp

read_image <- function(image_path){
  jpeg::readJPEG(image_path)
}

display_image <- function(image){
  graphics::plot(1:2, type="n", axes=F, ylab='n', xlab='n', ann=FALSE)
  graphics::rasterImage(image, 1, 1, 2, 2)
}

get_hex <- function(image, x, y, length=5){
  rgb(image[x,y,1], image[x,y,2], image[x,y,3])
}

get_hex_sequence <- function(from, to, length=5){
  ramp <- colorRamp(c(from, to))
  rgb( ramp(seq(0, 1, length = length)), max = 255)
}

shrink <- function(matrix){
  return(list("max"=max(matrix), "min"=min(matrix)))
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
#' param im_vbox a vbox of the image
#'

test_im_vbox <- vbox(testlist)
median_cut <- function(im, im_vbox, iter=1){

  #find color which splits vbox on largest extent
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

  above <- paste0("A", iter)
  below <- paste0("B", iter)
  cut_image <- list()
  cut_image[[above]] <- aboveList
  cut_image[[below]] <- belowList
  return(cut_image)
}

r1_medcut <- median_cut(testlist, test_im_vbox)

#------Round 2-------#
#Now need to calc vboxes for each of the new images
r2_vboxes <- lapply(r1_medcut, vbox)

# Question: Decide the next cut based on the largest extent in all the boxes?
# or based on the largest extent in the box with the largest volume...
# I choose option 2

#Get volumes
r2_volumes <- lapply(r2_vboxes, function(x) x$volume)
r2_box_to_split <- which.max(r2_volumes)

#Cut the box with the biggest volume using medcut
r2_medcut <- median_cut(r1_medcut[[names(r2_box_to_split)]], r2_vboxes[[names(r2_box_to_split)]], iter=2)

#Combine r2 medcut with r1, remove the box we cut
r2_medcut <- c(r2_medcut, r1_medcut[which(!names(r1_medcut) %in% names(r2_box_to_split))])

#-----Round 3------#

r3_vboxes <- lapply(r2_medcut, vbox)
#Get volumes
r3_volumes <- lapply(r3_vboxes, function(x) x$volume)
r3_box_to_split <- which.max(r3_volumes)

r3_medcut <- median_cut(r2_medcut[[names(r3_box_to_split)]], r3_vboxes[[names(r3_box_to_split)]], iter=3)

#Combine r2 medcut with r1, remove the box we cut
r3_medcut <- c(r3_medcut, r2_medcut[which(!names(r2_medcut) %in% names(r3_box_to_split))])

#----Round 4-----#

r4_vboxes <- lapply(r3_medcut, vbox)
#Get volumes
r4_volumes <- lapply(r4_vboxes, function(x) x$volume)
r4_box_to_split <- which.max(r4_volumes)

r4_medcut <- median_cut(r3_medcut[[names(r4_box_to_split)]], r4_vboxes[[names(r4_box_to_split)]], iter=4)

#Combine r2 medcut with r1, remove the box we cut
r4_medcut <- c(r4_medcut, r3_medcut[which(!names(r3_medcut) %in% names(r4_box_to_split))])

#----Round 5-----#

r5_vboxes <- lapply(r4_medcut, vbox)
#Get volumes
r5_volumes <- lapply(r5_vboxes, function(x) x$volume)
r5_box_to_split <- which.max(r5_volumes)

r5_medcut <- median_cut(r4_medcut[[names(r5_box_to_split)]], r5_vboxes[[names(r5_box_to_split)]], iter=5)

#Combine r2 medcut with r1, remove the box we cut
r5_medcut <- c(r5_medcut, r4_medcut[which(!names(r4_medcut) %in% names(r5_box_to_split))])


#NOTE: I think in the above we may be unnecessarily calculating vboxes multiple times for images
#, this isn't necessary (see the call to rX_vboxes - we only need the newest two vboxes)
# One possibility is to set up the list before hand, because we know how many color levels the user will
# want, then we can just keep adding on to the list.
# R really needs push and pop functionality



#Results - Looks good! mean and median return different results, not sure which is pref
lapply(r5_medcut, function(x) rgb(median(x$red), median(x$green), median(x$blue)) )
lapply(r5_medcut, function(x) rgb(mean(x$red), mean(x$green), mean(x$blue)) )










