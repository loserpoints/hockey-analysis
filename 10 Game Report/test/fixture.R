### synthetic report_data for verifying Team Chart.R refactors
###
### the chart is a pure function of report_data[3] and eight columns, so a
### fixture with the right shape reproduces it without the original scrape.

set.seed(1)

measures <- list(
  "5v5 Offense"  = c("Shot Generation", "Expected Goals For", "Goals For"),
  "5v5 Defense"  = c("Shot Suppression", "Expected Goals Against", "Goals Against"),
  "5v5 Total"    = c("Shot Share", "Expected Goals Share", "Goal Share"),
  "5v5 Results"  = c("Goals Scored Above Exp.", "Save Percentage"),
  "5v4 Offense"  = c("Shot Generation", "Expected Goals For"),
  "4v5 Defense"  = c("Shot Suppression", "Expected Goals Against"),
  "ST Results"   = c("Goals Scored Above Exp.", "Special Teams Index")
)

rows <- do.call(rbind, lapply(seq_along(measures), function(g) {
  grp <- names(measures)[g]
  do.call(rbind, lapply(seq_along(measures[[g]]), function(m) {
    data.frame(
      Team                  = "T.B",
      Group                 = grp,
      Verbose               = measures[[g]][m],
      Group_Order           = g,
      Measure_Order         = m,
      Season_Value_Z_Score  = round(runif(1, -2, 2), 3),
      PU10_Value_Z_Score    = round(runif(1, -2, 2), 3),
      U10_Value_Z_Score     = round(runif(1, -2, 2), 3),
      stringsAsFactors      = FALSE
    )
  }))
}))

## a second team so the Team filter has something to exclude
other <- rows; other$Team <- "BOS"
rows <- rbind(rows, other)

## report_data[3] is what the chart reads
report_data <- list(NULL, NULL, rows)

saveRDS(report_data, "report_data.rds")
cat("fixture:", nrow(rows), "rows,", length(unique(rows$Group)), "groups\n")
