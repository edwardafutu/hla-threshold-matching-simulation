
# Toy Simulation: HLA Mismatch Thresholds, Match Rates, and Group Equity
# Goal: Illustrate how changing an allowable mismatch threshold can affect
#       overall matching and matching-rate differences between two
#       hypothetical recipient groups.
#
# IMPORTANT:
# This is a learning demonstration using synthetic data.
# The mismatch score is NOT a real HLA immunogenicity measure.

library(ggplot2)

set.seed(42)

# 1. Create a small fictional pool of recipients and donors

n_rec <- 60
n_don <- 40
n_features <- 3

# Divide recipients equally between two hypothetical groups
recipients <- data.frame(
  rec_id = 1:n_rec,
  group = rep(c("Group A", "Group B"), each = n_rec / 2)
)

# Create three fictional molecular profile features for each donor
donor_profiles <- matrix(
  rnorm(n_don * n_features),
  nrow = n_don,
  ncol = n_features
)

# Create three fictional profile features for each recipient
recipient_profiles <- matrix(
  rnorm(n_rec * n_features),
  nrow = n_rec,
  ncol = n_features
)

# Introduce a small artificial shift in the first feature for Group B.
# This is an illustrative assumption, NOT a real biological claim.
recipient_profiles[recipients$group == "Group B", 1] <-
  recipient_profiles[recipients$group == "Group B", 1] + 0.5

# 2. Calculate a separate mismatch score for every donor-recipient pair.
# The score is the sum of absolute differences across the three features.
# Lower scores indicate closer profiles in this toy simulation.

mismatch_matrix <- matrix(
  NA,
  nrow = n_don,
  ncol = n_rec
)

for (i in seq_len(n_rec)) {
  feature_differences <- sweep(
    donor_profiles,
    MARGIN = 2,
    STATS = recipient_profiles[i, ],
    FUN = "-"
  )
  
  mismatch_matrix[, i] <- rowSums(abs(feature_differences))
}

# 3. Test different allowable mismatch thresholds
thresholds <- seq(0.5, 4, by = 0.25)

# Randomise recipient order once.
# The same order is used for every threshold to make comparisons fairer.
recipient_order <- sample(seq_len(n_rec))

results <- do.call(rbind, lapply(thresholds, function(cut) {
  
  # Each donor can be assigned to only one recipient
  available_donors <- rep(TRUE, n_don)
  
  # Record the group of each successfully matched recipient
  matched_group <- character(0)
  
  # Consider recipients in the randomised order
  for (i in recipient_order) {
    
    # Find available donors whose pair-specific score meets the threshold
    compatible <- which(
      available_donors & mismatch_matrix[, i] <= cut
    )
    
    if (length(compatible) > 0) {
      
      # Choose the available donor with the lowest mismatch score
      chosen <- compatible[
        which.min(mismatch_matrix[compatible, i])
      ]
      
      # Mark this donor as no longer available
      available_donors[chosen] <- FALSE
      
      # Record the recipient's group
      matched_group <- c(matched_group, recipients$group[i])
    }
  }
  
  # Calculate matching rates for each group
  rate_A <- sum(matched_group == "Group A") / (n_rec / 2)
  rate_B <- sum(matched_group == "Group B") / (n_rec / 2)
  
  # Calculate overall matching rate
  overall_rate <- length(matched_group) / n_rec
  
  data.frame(
    threshold = cut,
    overall_match_rate = overall_rate,
    group_A_rate = rate_A,
    group_B_rate = rate_B,
    equity_gap = abs(rate_A - rate_B)
  )
}))

# 4. Print the summary table
print(round(results, 2))

# 5. Prepare data for plotting
plot_df <- data.frame(
  threshold = rep(results$threshold, 3),
  rate = c(
    results$overall_match_rate,
    results$group_A_rate,
    results$group_B_rate
  ),
  metric = rep(
    c("Overall Match Rate", "Group A Match Rate", "Group B Match Rate"),
    each = nrow(results)
  )
)

# 6. Create the plot
match_plot <- ggplot(
  plot_df,
  aes(x = threshold, y = rate, color = metric)
) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  labs(
    title = "Toy Simulation: Mismatch Threshold and Matching Rates",
    subtitle = "Synthetic data: 60 recipients and 40 donors",
    x = "Allowable Mismatch Threshold",
    y = "Proportion of Recipients Matched",
    color = ""
  ) +
  theme_minimal()

print(match_plot)

# 7. Save the plot in the project folder
ggsave(
  filename = "match_rates_by_threshold.png",
  plot = match_plot,
  width = 8,
  height = 5,
  dpi = 300
)
