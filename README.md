# Hockey

NHL analysis in R, with a Tampa Bay Lightning lean. Written 2019–2020, much
of it for posts at [Raw Charge](https://www.rawcharge.com/). Finished work,
kept for reference rather than actively maintained.

## Layout

Each analysis is a self-contained folder:

```
project_name/
  scripts/   the R that produces the analysis
  viz/       the charts it outputs
```

Names are lowercase with underscores throughout, so nothing needs quoting
in a shell.

## Data

Mostly [Evolving Hockey](https://evolving-hockey.com/), a subscription site,
plus some scraped from [Hockey Reference](https://www.hockey-reference.com/).
CSVs were downloaded by hand into per-project `data/` directories, which are
gitignored — **the scripts will not run without supplying that data yourself.**

Recurring metrics, all Evolving Hockey definitions:

| Term | Meaning |
|---|---|
| **SPAR** | Standings Points Above Replacement |
| **WAR** | Wins Above Replacement |
| **RAPM** | Regularized Adjusted Plus-Minus — isolates a player's impact from teammates, competition and usage |
| **xG** | Expected goals |
| **T25U25** | Top 25 Under 25, an annual community-voted prospect ranking |

## The analyses

| Folder | What it looks at |
|---|---|
| `ten_game_report` | Rolling ten-game team performance, with in-game chart variants |
| `arena_xg_divergence` | Whether shot tracking differs systematically by arena |
| `draft_spar` | Value returned by draft slot |
| `eh_shot_data` | Shot-level working data |
| `goal_droughts`, `goalie_stuff`, `playoff_goalies` | Scoring slumps and goaltending |
| `hockey_reference` | Scrapers for historical skater, draft and standings data |
| `metric_testing` | How well public metrics predict future results |
| `nhl_power_rankings`, `team_tiers` | Team strength over a season |
| `ppp_t25u25`, `rc_t25u25_2020` | Community prospect-vote tabulation and visualisation |
| `playoff_paths` | Postseason route difficulty |
| `spar_impacts` | What drives SPAR at the player level |
| `single_game_pace`, `single_period_outliers` | Within-game and within-period extremes |
| `tanking` | Whether losing deliberately pays off |
| `team_shooting` | Team-level shooting talent versus variance |
| `trophies` | Awards cases built from SPAR and RAPM |

`draft_spar` and `trophies` carry their own READMEs covering data
requirements and methodology.

## Scraping

Several projects scrape rather than read local files — Hockey Reference,
Natural Stat Trick, ESPN, Spotrac and Wikipedia.

The loops that request many pages in succession are rate limited to one
request every five seconds. Hockey Reference publishes a limit of roughly
twenty requests a minute and blocks addresses that exceed it, and the
historical skater scrape in `hockey_reference/scripts/player_data.R`
requests 102 pages in a single run.

**If you add or modify a scraping loop, keep the `Sys.sleep()` in it.** The
one-off fetches — a single Wikipedia or Spotrac page — aren't throttled,
because one request isn't a rate problem.

## Tests

`ten_game_report/test/` holds a synthetic fixture for the two dashboard charts.
Both are pure functions of `report_data[3]` and eight columns, so they can be
rendered without the original Natural Stat Trick scrape, which no longer
exists.

```
Rscript ten_game_report/test/fixture.R
Rscript ten_game_report/test/render_from_fixture.R ten_game_report/scripts/team_chart.R out.jpg
```

Render before and after a change and compare checksums. This is how the
panel extraction in both charts was verified as producing identical output.

`report_data_harness.R` does the same for `data_wrangling.R`, stubbing the
scrape so no request reaches Natural Stat Trick, and saving what
`get_report_data()` returns for comparison with `identical()`.

```
Rscript ten_game_report/test/report_data_harness.R ten_game_report/scripts/data_wrangling.R out.rds
```

Both harnesses shim two things that changed after this code was written:
dplyr removed `funs()`, and `cbind()` on grouped tibbles now de-duplicates
column names where it used to keep them. **These scripts do not run on a
current tidyverse without those shims.** The shims exist so before and after
can be compared under identical conditions, not as fixes.

## Running these

### Packages

```r
install.packages(c("tidyverse", "extrafont", "ggthemes", "hrbrthemes", "rvest",
                   "scales", "RMariaDB", "ggpubr", "ggrepel", "ggalt", "cowplot",
                   "zoo", "reshape2", "mgcv", "ggforce", "fuzzyjoin",
                   "BradleyTerry2", "googledrive", "googlesheets4"))
```

Written against the versions current in 2019–2020 and not updated since.
Two things have changed underneath them: dplyr removed `funs()`, and
`cbind()` on grouped tibbles now de-duplicates column names. **Several
scripts will not run on a current tidyverse without adjustment.** That's
recorded rather than fixed — the code is kept as it was written.

### Working directory

Most scripts read `data/` and write `viz/` relative to **their own project
folder**, so set the working directory to that folder before running one.

Five scripts instead call `setwd("project_name")` at the top, which assumes
the working directory is the repository root. These two conventions
contradict each other — the repo has never settled on one. Running one of
those five twice in a session will also fail on the second `setwd()`.

### Database

The shot-level projects read from a local MariaDB database named
`nhl_shots_eh`. The password comes from an environment variable rather than
being hardcoded. Set it in `~/.Renviron`:

```
HOCKEY_DB_PASSWORD=your_password_here
```

Then restart R.

### Fonts

Written on Windows — scripts call `loadfonts(device = "win")`, which needs
changing on macOS or Linux. Charts use `hrbrthemes` with IBM Plex Sans, so
that font needs installing first.

## License

No license specified — personal analysis work, shared for reference.
