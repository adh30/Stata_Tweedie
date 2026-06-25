library(statmod)
library(cplm)

set.seed(123)
n <- 1000

x1 <- runif(n, 0, 10)
x2 <- rnorm(n)

eta <- 0.5 + 0.3 * x1 - 0.2 * x2
mu <- exp(eta)

p <- 1.5
phi <- 1

y <- rtweedie(n, mu = mu, phi = phi, power = p)

# ✅ Put everything in a clean data frame
data <- data.frame(y = y, x1 = x1, x2 = x2)

# ✅ Remove any problematic rows
data <- data[is.finite(rowSums(data)), ]

# ✅ Check validity
stopifnot(all(data$y >= 0))

# ===============================
# GLM Tweedie
# ===============================
model_glm <- glm(
  y ~ x1 + x2,
  data = data,
  family = tweedie(var.power = p, link.power = 0)
)

summary(model_glm)

# ===============================
# Recommended alternative
# ===============================
model_cpglm <- cpglm(y ~ x1 + x2, data = data)

summary(model_cpglm)