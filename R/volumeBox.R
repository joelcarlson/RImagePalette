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
