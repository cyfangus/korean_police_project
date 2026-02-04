# Load necessary libraries
library(readr)
library(ggplot2)
library(MASS)
library(broom)
library(ggplot2)

# --- 1. Read the raw data ---
# Use the 'here' package to construct file paths robustly
cleaned_data_path <- here("data/processed/first_wave_cleaned.csv")
cleaned_data <- readr::read_csv(cleaned_data_path)

# Exploratory Data Analysis
describe(cleaned_data)


# Plot willingess to report to show its strong negative skewness and ceiling effect
willingess_to_report_plot <- 
  ggplot(cleaned_data, aes(x = factor(will_report))) +
  geom_bar(fill = "steelblue", color = "white") +
  stat_count(geom = "text", aes(label = after_stat(count)), vjust = -0.5) +
  labs(
    title = "Distribution of Willingness to Report",
    subtitle = "Categorical view removes empty space between scores",
    x = "Willingness to report crime in future",
    y = "Number of Respondents"
  ) +
  # Expand the y-axis slightly so the labels don't get cut off at the top
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  theme_minimal(base_size = 14)

# save the plot to the output folder
ggsave(
  filename = "output/willingness_report_ceiling_effect.png", 
  plot = willingess_to_report_plot, 
  width = 8,      # Width in inches
  height = 6,     # Height in inches
  dpi = 300       # High resolution for reports
)


# --- 2. Statistical Analyses ---
# --- a. Non-parametric alternatives to t-tests ---
# due to the strong negative skew (-2.04) and the ceiling effect (most people choosing the maximum score of 5)
wilcox_will_report_pjq <- t.test(will_report ~ pjq, data = cleaned_data)
wilcox_will_report_urgency <- t.test(will_report ~ urgency, data = cleaned_data)
wilcox_will_report_adsms <- t.test(will_report ~ adsms, data = cleaned_data)

# --- b. Adjusted Regression (Ordinal Logistic Regression) ---
# Because will_report is an ordinal variable (1 to 5) with a massive ceiling effect, a Proportional Odds Model is more robust than lm().

# Ensure will_report is an ordered factor for the model
cleaned_data$will_report_ordered <- factor(cleaned_data$will_report, ordered = TRUE)

# 1. Baseline model (Ordinal Logistic Regression)
baseline_model <- polr(will_report_ordered ~ age, data = cleaned_data, Hess = TRUE)

# 2. Multi-predictor model
multi_model <- polr(will_report_ordered ~ age + pol_eff + pol_dj + pol_pj, 
                        data = cleaned_data, Hess = TRUE)


# chi-square test between adsms and Victimisation
contingency_table <- table(cleaned_data$adsms, cleaned_data$victimisation)
chi_results <- chisq.test(contingency_table)

# print results
# Wilcoxon Test Results
print(wilcox_will_report_pjq)
print(wilcox_will_report_urgency)
print(wilcox_will_report_adsms)

# Ordinal Logistic Regression Results
summary(baseline_model)
summary(multi_model)
exp(coef(multi_model))

# Chi-square Test Results
print(chi_results)

# --- 3. Visulisation ---
# --- Forest Plot of Willingness to Report --- 
# Tidy the model
tidy_model <- tidy(multi_model, conf.int = TRUE, exponentiate = TRUE)
# Filter using the correct column name 'coef.type'
tidy_plot_data <- tidy_model |> 
  filter(coef.type == "coefficient") |>
  mutate(term = reorder(term, estimate))
# Create the Forest Plot
forest_plot_willingness_to_report <- 
  ggplot(tidy_plot_data, aes(x = estimate, y = term)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red", size = 0.8) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2, color = "gray40") +
  geom_point(size = 4, color = "steelblue") +
  # Adding text labels for the Odds Ratios to make it easier to read
  geom_text(aes(label = round(estimate, 2)), vjust = -1, size = 3.5) +
  labs(
    title = "Predictors of Willingness to Report",
    subtitle = "Values > 1 indicate increased likelihood (Odds Ratios)",
    x = "Odds Ratio (95% CI)",
    y = "Predictor"
  ) +
  theme_minimal(base_size = 14)

# save the plot to the output folder
ggsave(
  filename = "output/forest_plot_willingness_to_report.png",
  plot = forest_plot_willingness_to_report,
  width = 10,
  height = 6,
  dpi = 300
)