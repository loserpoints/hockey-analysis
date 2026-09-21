### run Data Wrangling.R with the scrape stubbed out, and save what it returns
###
### usage: Rscript harness.R <script> <output rds>
###
### read_html and html_table are replaced with stubs returning a synthetic
### games table, so no request is made to naturalstattrick.

args <- commandArgs(trailingOnly = TRUE)

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2); library(purrr)
  library(tibble); library(stringr); library(readr); library(forcats)
  library(ggthemes); library(scales)
})

## dplyr removed funs() in 1.0, so these scripts cannot run on a modern
## tidyverse. shimmed here so both versions are compared under identical
## conditions - this is a harness detail, not a fix.
funs <- function(...) {
  exprs <- as.list(substitute(list(...)))[-1]
  nms <- names(exprs)
  out <- lapply(exprs, function(e) {
    if (is.symbol(e)) {
      f <- tryCatch(match.fun(as.character(e)), error = function(...) NULL)
      if (!is.null(f)) return(f)
    }
    lam <- ~ .
    lam[[2]] <- e
    environment(lam) <- parent.frame(3)
    lam
  })
  if (!is.null(nms)) names(out) <- nms
  out
}

## modern dplyr de-duplicates column names when cbind-ing grouped tibbles;
## the 2020 behaviour kept duplicates, which is what the positional column
## selection that follows depends on. emulated here, again as a harness
## detail rather than a fix.
cbind <- function(...) {
  parts <- lapply(list(...), function(x) as.data.frame(dplyr::ungroup(x)))
  do.call(base::data.frame, c(parts, list(check.names = FALSE, stringsAsFactors = FALSE)))
}

set.seed(42)

full_names <- c("Anaheim Ducks","Arizona Coyotes","Boston Bruins","Buffalo Sabres",
  "Calgary Flames","Carolina Hurricanes","Chicago Blackhawks","Colorado Avalanche",
  "Columbus Blue Jackets","Dallas Stars","Detroit Red Wings","Edmonton Oilers",
  "Florida Panthers","Los Angeles Kings","Minnesota Wild","Montreal Canadiens",
  "Nashville Predators","New Jersey Devils","New York Islanders","New York Rangers",
  "Ottawa Senators","Philadelphia Flyers","Pittsburgh Penguins","San Jose Sharks",
  "St Louis Blues","Tampa Bay Lightning","Toronto Maple Leafs","Vancouver Canucks",
  "Vegas Golden Knights","Washington Capitals","Winnipeg Jets")
stopifnot(length(full_names) == 31, !is.unsorted(full_names))

n_games <- 24

make_table <- function(url) {
  seed_off <- sum(utf8ToInt(url)) %% 1000
  set.seed(1000 + seed_off)
  rows <- do.call(rbind, lapply(full_names, function(tm) {
    data.frame(
      Game = paste0(format(as.Date("2019-10-02") + seq_len(n_games) * 2),
                    " - ABC 3, DEF 2"),
      Team = tm,
      CF = as.character(sample(20:80, n_games, TRUE)),
      CA = as.character(sample(20:80, n_games, TRUE)),
      FF = as.character(sample(15:60, n_games, TRUE)),
      FA = as.character(sample(15:60, n_games, TRUE)),
      xGF = as.character(round(runif(n_games, 0.5, 4), 2)),
      xGA = as.character(round(runif(n_games, 0.5, 4), 2)),
      GF = as.character(sample(0:7, n_games, TRUE)),
      GA = as.character(sample(0:7, n_games, TRUE)),
      TOI = as.character(round(runif(n_games, 40, 55), 2)),
      Attendance = as.character(sample(15000:21000, n_games, TRUE)),
      stringsAsFactors = FALSE
    )
  }))
  rownames(rows) <- NULL
  rows
}

read_html  <- function(url, ...) structure(list(url = url), class = "stub_html")
html_table <- function(x, ...) list(make_table(x$url))

src <- readLines(args[1], warn = FALSE)
src <- src[!grepl("^\\s*library\\(|^\\s*require\\(", src)]
call_line <- grep("^\\s*report_data <- get_report_data\\(\\)\\s*$", src)
stopifnot(length(call_line) == 1)
src <- src[-call_line]

eval(parse(text = paste(src, collapse = "\n")), envir = environment())

report_data <- get_report_data()
saveRDS(report_data, args[2])
cat("saved", args[2], "- list of", length(report_data), "\n")
