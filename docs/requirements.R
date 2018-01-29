

# see https://github.com/s-u/PKI/issues/17
install.packages('PKI',,'http://www.rforge.net/')

# Install other packages often used
pkgs <- c(
  'AER',
  'afex',
  'apa',
  'apaTables',
  'arm', 
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
  'rsvg',
  'semPlot',
  'servr',
  'simr',
  'statcheck',
  'tidyverse', 
  'tufte',
  'waffle'
)

install.packages(pkgs)



devtools::install_github("ropenscilabs/skimr")
devtools::install_github('ralfer/apa_format_and_misc', subdir='apastats')
