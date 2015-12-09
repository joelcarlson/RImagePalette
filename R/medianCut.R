median_cut <- function(im, im_vbox, iter=1){

  #find color which splits vbox on largest extent
  #Sample to randomly shuffle,
  #meaningful when there is a tie in maximum extents
  cut_color <- which.max(sample(im_vbox[["ext"]]))

  #Cut the extent along the median value
  #from the rgb values we make a new set that is lower than the median of the largest exent group, and one that is higher
  aboveList <- lapply(im, function(color_channel){
    color_channel[which(im[[names(cut_color)]] >= im_vbox$med[[names(cut_color)]])]
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
