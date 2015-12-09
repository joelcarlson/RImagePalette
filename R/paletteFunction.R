image<- read_image("tests/testthat/test.jpg")
image<- readPNG("tests/testthat/fivethirtyeight-1.png")
testlist <- list("red"=image[,,1], "green"=image[,,2], "blue"=image[,,3])

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


#Function to loop over n_colors to generate palette

create_palette <- function(image, n_colors=5, choice=median){
  image_list <- list("red"=image[,,1], "green"=image[,,2], "blue"=image[,,3])

  iter <- 1
  while(iter < n_colors){
    #Get volume box for first iteration
    #to decide which extent to cut
    if(iter == 1){
      vboxes <- vbox(image_list)
      #Cut the image using the median cut algorithm
      cut_image_list <- median_cut(image_list, image_vbox, iter = iter)
    } else {

      #---Prepare for next loop---
      #Get vboxes
      vboxes <- lapply(cut_image_list, vbox)

      #Get volumes
      image_volumes <- lapply(vboxes, function(x) x$volume)
      #image_volumes <- lapply(vboxes, function(x) max(x$ext$red, x$ext$green, x$ext$blue)) #cut on largest extent

      #Choose which box to split based on highest volume
      image_to_split <- which.max(image_volumes)

      #Cut the box with the biggest volume using medcut
      image_medcut <- median_cut(cut_image_list[[names(image_to_split)]], vboxes[[names(image_to_split)]], iter=iter)

      #Combine r2 medcut with r1, remove the box we cut
      cut_image_list <- c(image_medcut, cut_image_list[which(!names(cut_image_list) %in% names(image_to_split))])

    }


    iter <- iter + 1


  }

  return(lapply(cut_image_list, function(x) rgb(choice(x$red), choice(x$green), choice(x$blue)) ))


}

#http://hex.colorrrs.com/

























