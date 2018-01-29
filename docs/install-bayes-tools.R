# This installs all dependencies successfully on OS X and Linux
# provided you have a working GCC.
# sudo apt-get install GCC R

dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, "Makevars")
if (!file.exists(M)) file.create(M)
cat("\nCXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function", 
    file = M, sep = "\n", append = TRUE)

cat("\nCXXFLAGS+=-flto -ffat-lto-objects  -Wno-unused-local-typedefs", 
    file = M, sep = "\n", append = TRUE)

Sys.setenv(MAKEFLAGS = "-j4") 
install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies=TRUE)


install.packages('rstanarm')
install.packages('bayesplot')
devtools::install_github("mjskay/tidybayes")
devtools::install_github("rmcelreath/rethinking")
