# Trophies

An end-of-season awards ballot built from Evolving Hockey metrics rather
than voting convention. `scripts/nhl_trophies.R` produces the chart in
`viz/`.

## What goes into each case

| Trophy | Inputs |
|---|---|
| **Hart** | SPAR, plus expected goal and goal RAPM |
| **Norris** | SPAR, plus expected goal and goal RAPM |
| **Calder** | SPAR, plus expected goal and goal RAPM |
| **Selke** | Even strength and penalty kill expected goal RAPM, defensive zone starts, defensive zone faceoffs |
| **Vezina** | Goals saved above expected |

SPAR is Standings Points Above Replacement; RAPM is Regularized Adjusted
Plus-Minus. Both are Evolving Hockey definitions — see the repository
README for the full glossary.
