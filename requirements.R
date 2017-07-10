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


# see https://github.com/s-u/PKI/issues/17
install.packages('PKI',,'http://www.rforge.net/')

# Install other packages I often use
## Dependencies include reshape2, dplyr
pkgs <- c(
  'AER',
  'afex',
  'apa',
  'apaTables',
  'arm', 
  'bayesplot',
  'blme',
  'bookdown', 
  'brms',
  'broom',
  'car',
  'caret',
  'coin',
  'corrgram',
  'cowplot',
  'data.table',
  'devtools',
  'DiagrammeR', 
  'DiagrammeRsvg',
  'ez',
  'GGally',
  'gridExtra',
  'haven',
  'Hmisc',
  'knitr',
  'lavaan',
  'lmerTest',
  'lsr',
  'lubridate',
  'margins',
  'merTools',
  'mi',
  'multcomp',
  'MuMIn',
  'pander',
  'png',
  'psych',
  'pwr',
  'repmis',
  'reshape2',
  'rstanarm',
  'simr',
  'statcheck',
  'tidyverse', 
  'tufte',
  'waffle'
)

install.packages(pkgs)