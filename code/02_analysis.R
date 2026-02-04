# Load necessary libraries
library(readr)
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
# Non-parametric alternatives to t-tests due to the strong negative skew (-2.04) and the ceiling effect (most people choosing the maximum score of 5)
t_test_will_report_on_pjq <- t.test(will_report ~ pjq, data = cleaned_data)
t_test_will_report_on_urgency <- t.test(will_report ~ urgency, data = cleaned_data)
t_test_will_report_on_adsms <- t.test(will_report ~ adsms, data = cleaned_data)


# Baseline regression model with age as predictor
baseline_model <- lm(will_report ~ age, data = cleaned_data)
# Predicting willingness to report using police evaluations
multi_model <- lm(will_report ~ age + pol_eff + pol_dj + pol_pj, data = cleaned_data)

# chi-square test between adsms and Victimisation
contingency_table <- table(cleaned_data$adsms, cleaned_data$victimisation)
chi_results <- chisq.test(contingency_table)

# print results
print(t_test_will_report_on_pjq)
print(t_test_will_report_on_urgency)
print(t_test_will_report_on_adsms)
summary(baseline_model)
summary(multi_model)
print(chi_results)
