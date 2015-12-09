library(EBImage); library(rPlotter)
#Steals from:
#https://github.com/woobe/rPlotter/blob/master/R/extract_colours.R

#Also see:
#https://github.com/lokesh/color-thief/blob/master/src/color-thief.js

dress <- extract_colours(,3)
Image <- readImage("Wailua_Falls_Wikipedia.jpg")
display(Image)

extract_colours <- function(img_path, num_col = 5, rsize = 100) {
  
  ##Read image
  img <- readImage(img_path)
  
  ## Resize Image (make it smaller so the remaining tasks run faster)  
  if (max(dim(img)[1:2]) > rsize) {
    if (dim(img)[1] > dim(img)[2]) {
      img <- resize(img, w = rsize)
    } else {
      img <- resize(img, h = rsize)
    }
  }
  
  ## Melt
  img_melt <- melt(img)
  
  ## Reshape
  img_rgb <- reshape(img_melt, timevar = "Var3", idvar = c("Var1", "Var2"), direction = "wide")
  img_rgb$Var1 <- -img_rgb$Var1
  
  ## Detect dominant colours with kmeans (multiple starts)
  col_dom <- kmeans(img_rgb[, 3:5], centers = num_col, nstart = 3, iter.max = 100)
  
  ## Return k-means centers as RGB colours
  cus_pal <- sort(rgb(col_dom$centers))
  return(as.character(cus_pal))
  
}

#this is a start, but the color choices are pretty bad. Need a better method