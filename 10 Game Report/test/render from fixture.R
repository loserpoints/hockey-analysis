### render the team dashboard from the synthetic fixture
###
### usage, from the repository root:
###   Rscript "10 Game Report/test/render from fixture.R" <chart script> <output>
###
### the dashboard is a pure function of report_data[3] and eight columns, so
### it can be rendered without the original naturalstattrick scrape. this is
### how the refactor of Team Chart.R was verified: render before the change,
### render after, and compare checksums. they matched exactly.
###
### the script being rendered is read rather than sourced, because Team
### Chart.R calls its function above the definition and so cannot be sourced
### as written.

args <- commandArgs(trailingOnly = TRUE)
script_path <- args[1]
out_path    <- args[2]

suppressPackageStartupMessages({
  library(dplyr); library(ggplot2); library(tidyr); library(readr)
  library(purrr); library(tibble); library(stringr); library(forcats)
  library(ggthemes); library(scales); library(ggpubr); library(cowplot)
})

## font registration is irrelevant to comparing two renders of the same spec
loadfonts <- function(...) invisible(NULL)

report_data  <- readRDS("report_data.rds")
select_team  <- "T.B"
verbose_team <- "Tampa Bay Lightning"

src <- readLines(script_path, warn = FALSE)
src <- src[!grepl("^\\s*library\\(", src)]
src <- src[!grepl("^\\s*loadfonts\\(", src)]

call_line <- grep("^\\s*generate_team_dashboard\\(\\)\\s*$", src)
stopifnot(length(call_line) == 1)
src <- src[-call_line]

eval(parse(text = paste(src, collapse = "\n")), envir = environment())

dir.create("Viz", showWarnings = FALSE)
before <- list.files("Viz", full.names = TRUE)

generate_team_dashboard()

after <- setdiff(list.files("Viz", full.names = TRUE), before)
stopifnot(length(after) == 1)
invisible(file.rename(after, out_path))
cat("wrote", out_path, "\n")
