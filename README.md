# Toy Simulation: HLA Mismatch Thresholds, Matching Rates and Group Equity

## Overview
A simple R simulation exploring how different donor-recipient mismatch thresholds affect matching rates and matching-rate differences between two hypothetical recipient groups under limited donor availability.

The project is a learning exercise inspired by research on molecular HLA immunogenicity and kidney allocation.

**Note:** All data are synthetic. The mismatch scores are fictional profile-distance measures, not actual HLA, HMS, EMS or eplet mismatch measurements. They are not clinically validated.

## Methodology
- Simulates 60 hypothetical recipients (30 per group) and 40 donors.
- Generates three fictional profile features for each donor and recipient.
- Calculates a separate mismatch score for every donor-recipient pair using absolute differences across the three features.
- Introduces a small artificial profile shift for Group B.
- Tests allowable mismatch thresholds from 0.5 to 4.0, in increments of 0.25.
- Uses a greedy matching approach: recipients are considered in a randomised order, and each is assigned the available donor with the lowest qualifying mismatch score. Each donor can be assigned only once.

## Key Measures
- **Overall match rate:** Proportion of all 60 recipients matched.
- **Group match rates:** Proportion of recipients matched within each group.
- **Group matching-rate gap:** Absolute difference between the two group-specific matching rates.

## Results
The simulation illustrates how matching rates change as the allowable mismatch threshold is relaxed. Because there are only 40 donors for 60 recipients, the overall matching rate cannot exceed 66.7%.

Any differences between the two groups reflect the artificial assumptions and randomised allocation order in this simulation, not real-world transplant inequalities.

## Limitations
- Uses synthetic data and simplified mismatch scores, not actual HLA compatibility or immunogenicity measurements.
- Uses a simple greedy algorithm rather than formal kidney allocation optimisation.
- Uses one randomised recipient order and one simulated dataset.
- Does not model clinical priority, kidney exchange chains, graft survival or actual transplant outcomes.

## Requirements and Usage
Requires R and `ggplot2`.

Install the package and run:

```r
install.packages("ggplot2")
source("simulation.R")
```

The script prints a summary table, displays the matching-rate plot and saves it as `match_rates_by_threshold.png`.
