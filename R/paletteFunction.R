create_palette <- function(image, n, choice=mean, volume=FALSE){
  image_list <- list("red"=image[,,1], "green"=image[,,2], "blue"=image[,,3])
  cut_image_list <- list()
  if(n == 1) return(rgb(mean(image_list$red), mean(image_list$green), mean(image_list$blue)))

  iter <- 1
  while(iter < n*2 & length(cut_image_list) < n){
    #Get volume box for first iteration
    #to decide which extent to cut
    if(iter == 1){
      vboxes <- vbox(image_list)
      #Cut the image using the median cut algorithm
      cut_image_list <- median_cut(image_list, vboxes, iter = iter)

    } else {

      #---Prepare for next loop---
      #Get vboxes, careful to not recalculate vboxes we already have - too expensive
      if(exists("image_to_split")){
        vboxes <- c(vboxes[which(names(vboxes) %in% names(cut_image_list))],
                    lapply(cut_image_list[which(!names(cut_image_list) %in% names(vboxes))], vbox))

      } else {
        vboxes <- lapply(cut_image_list, vbox)
      }


      #Allow user to choose what to cut on - volume of box, or extent
      if(volume){
        #Choose box to cut based on largest volume
        cut_criteria <- lapply(vboxes, function(x) x$volume)
      } else {
        #Choose box to cut based on largest extent
        cut_criteria <- lapply(vboxes, function(x) max(x$ext$red, x$ext$green, x$ext$blue))
      }



      #Choose which box to split based on highest volume
      image_to_split <- which.max(sample(cut_criteria))

      #Cut the box with the biggest volume using medcut
      image_medcut <- median_cut(cut_image_list[[names(image_to_split)]], vboxes[[names(image_to_split)]], iter=iter)

      #Remove any empty images - only comes into play when we are way down at the end
      image_medcut <- image_medcut[c(unlist(lapply(image_medcut,
                                                   function(x) !any(length(x$red) == 0 | length(x$green) == 0 | length(x$blue) == 0)
                                                   )
                                            ))]

      #Combine r2 medcut with r1, remove the box we cut
      cut_image_list <- c(image_medcut, cut_image_list[which(!names(cut_image_list) %in% names(image_to_split))])

    }


    iter <- iter + 1


  }

  return(unname(unlist(lapply(cut_image_list, function(x) rgb(choice(x$red), choice(x$green), choice(x$blue)) ))))


}


























