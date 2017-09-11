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
  'DAAG',
  'DiagrammeR', 
  'DiagrammeRsvg',
  'ez',
  'gapminder',
  'GGally',
  'granova',
  'ggthemes',
  'ggrepel',
  'gridExtra',
  'haven',
  'Hmisc',
  'ggjoy',
  'knitr',
  'lavaan',
  'lmerTest',
  'lsr',
  'lubridate',
  'margins',
  'mediation',
  'merTools',
  'mi',
  'mice',
  'multcomp',
  'MuMIn',
  'pander',
  'png',
  'psych',
  'pwr',
  'repmis',
  'reshape2',
  'rgl',
  'rstanarm',
  'rsvg',
  'semPlot',
  'simr',
  'statcheck',
  'tidyverse', 
  'tufte',
  'waffle'
)

install.packages(pkgs)



devtools::install_github("ropenscilabs/skimr")
devtools::install_github("mjskay/tidybayes")
devtools::install_github("rmcelreath/rethinking")
devtools::install_github('ralfer/apa_format_and_misc', subdir='apastats')


# install dev version otherwise fails on R 3.3.3
install.packages("MuMIn", repos="http://R-Forge.R-project.org")
