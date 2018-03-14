library(DiagrammeR)
library(DiagrammeRsvg)

knit_gv <- function(code, filename=NULL, width=NULL, height=800){

  assetpath <- "assets"
  dir.create(assetpath, showWarnings = F)

  if (!is.character(knitr::current_input())){
    format <- "png"
  } else {
    if (stringr::str_detect(
      knitr::opts_knit$get("rmarkdown.pandoc.to"), "beamer|latex|pdf")) {
      format <- "pdf"
    } else {
      format <- "png"
    }
  }
  if (!is.character(filename)){
    filename <- file.path(assetpath, paste0(sample(1e6:1e7, 1), ".", format))
  } else {
    filename = paste0(filename, ".", format)
  }

  library('rsvg')
  outfun <- get(paste0("rsvg_", format))
  capture.output({
    g <- grViz(paste("digraph{", code, "}"))
    DiagrammeRsvg::export_svg(g) %>% charToRaw %>% outfun(filename, width=width, height=height)
  },  file='NUL')

  knitr::include_graphics(filename)

}
