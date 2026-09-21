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

## Running these

Written on Windows — scripts call `loadfonts(device = "win")`, which needs
changing on macOS or Linux. Charts use `hrbrthemes` with IBM Plex Sans, so
that font needs installing first.

## License

No license specified — personal analysis work, shared for reference.
