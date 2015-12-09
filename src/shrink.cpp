#include <Rcpp.h>
using namespace Rcpp;

// Given a matrix, compute the maximum and minimum
//

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}

{
  int i,j;
  for(j=0; j<NUM_DIMENSIONS; j++)
  {
    minCorner.x[j] = maxCorner.x[j] = points[0].x[j];
  }
  for(i=1; i < pointsLength; i++)
  {
    for(j=0; j<NUM_DIMENSIONS; j++)
    {
      minCorner.x[j] = min(minCorner.x[j], points[i].x[j]);
      maxCorner.x[j] = max(maxCorner.x[j], points[i].x[j]);
    }
  }
}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
timesTwo(42)
*/
