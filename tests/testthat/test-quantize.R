context("test-quantize")
img <- jpeg::readJPEG(system.file("img", "Rlogo.jpg", package="jpeg"))
set.seed(10)
quant_img <- quantize_image(img, n=3)

# set.seed(10)
# dput(unique(as.vector(quant_img)))

bench <- sort(c(0.937254901960784, 0.525490196078431, 0.329411764705882, 0.945098039215686,
                0.568627450980392, 0.349019607843137, 0.952941176470588, 0.63921568627451,
                0.36078431372549))

test_that("quantize image works", {
  expect_equal(sort(unique(as.vector(quant_img))), bench)
  expect_that(dim(quant_img), equals(c(76L, 100L, 3L)))
})
