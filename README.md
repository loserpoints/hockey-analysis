# Hockey

NHL analysis in R, with a Tampa Bay Lightning lean. Written 2019–2020, much
of it for posts at [Raw Charge](https://www.rawcharge.com/). Finished work,
kept for reference rather than actively maintained.

## Layout

Each analysis is a self-contained folder:

```
Project Name/
  scripts/   the R that produces the analysis
  viz/       the charts it outputs
```

A few older folders don't follow this yet.

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
| `10 Game Report` | Rolling ten-game team performance, with in-game chart variants |
| `Arena xG Divergence` | Whether shot tracking differs systematically by arena |
| `Draft SPAR` | Value returned by draft slot |
| `EH Shot Data` | Shot-level working data |
| `Goal Droughts`, `Goalie Stuff`, `Playoff Goalies` | Scoring slumps and goaltending |
| `Metric Testing` | How well public metrics predict future results |
| `NHL Power Rankings`, `Team Tiers` | Team strength over a season |
| `PPP T25U25`, `RC T25U25 2020` | Community prospect-vote tabulation and visualisation |
| `Playoff Paths` | Postseason route difficulty |
| `SPAR Impacts` | What drives SPAR at the player level |
| `Single Game Pace`, `Single Period Outliers` | Within-game and within-period extremes |
| `Tanking` | Whether losing deliberately pays off |
| `Team Shooting` | Team-level shooting talent versus variance |
| `Trophies` | Awards cases built from SPAR and RAPM |

## Scraping

Several projects scrape rather than read local files — Hockey Reference,
Natural Stat Trick, ESPN, Spotrac and Wikipedia.

The loops that request many pages in succession are rate limited to one
request every five seconds. Hockey Reference publishes a limit of roughly
twenty requests a minute and blocks addresses that exceed it, and the
historical skater scrape in `Hockey Reference/Hockey Reference Player Data.R`
requests 102 pages in a single run.

**If you add or modify a scraping loop, keep the `Sys.sleep()` in it.** The
one-off fetches — a single Wikipedia or Spotrac page — aren't throttled,
because one request isn't a rate problem.

## Running these

### Working directory

Paths are relative to the repository root. Open `Hockey.Rproj` and run from
there. Five scripts `setwd()` into their own project folder first; running one
of those twice in a session will fail on the second `setwd()`.

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
