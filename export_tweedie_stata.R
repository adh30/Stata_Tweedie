library(haven)

# Create clean data frame with explicit names
data <- data.frame(
  y = as.numeric(y),
  x1 = as.numeric(x1),
  x2 = as.numeric(x2)
)

# Ensure no empty column names
stopifnot(all(names(data) != ""))

# Export to Stata
write_dta(data, "tweedie_simulated_data.dta")