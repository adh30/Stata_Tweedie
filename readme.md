# Stata_Tweedie

Implements a Tweedie family in Stata's Generalized linear models (glm) command. 

## Why the Tweedie GLM model with log link may be useful for modelling White Matter Hyperintensity volume

White matter hyperintensities (WMH) are widely used as markers of brain small vessel disease. WMH volumes typically exhibit a **highly right-skewed distribution**. In some instances (e.g. younger people or regional WMH volumes) there may be a substantial proportion of zero volumes. This presents challenges for the most commonly used GLMs.

---

## Distributional issues

WMH volumes are non-negative and typically characterised by:

- Strong positive skewness  
- Heteroskedasticity (variance increasing with the mean)  
- A non-negligible probability mass at zero  

GLMs using the **gamma distribution** are often used with WMH data because the gamma family accommodates continuous, positive, right-skewed outcomes. However, a fundamental limitation is that the gamma distribution is defined  on the strictly positive real line, precluding zero observations. [1](https://arxiv.org/pdf/1804.07780)  

In practice, this leads to undesirable workarounds such as:

- Excluding zero observations  
- Adding arbitrary constants  
- Using mixture or two-part (hurdle) models  

These approaches may introduce bias, inefficiency, or additional modelling complexity.

---

## The Tweedie Distribution

The **Tweedie family of distributions** provides a unified flexible framework for modelling WMH data. Tweedie distributions are exponential dispersion models defined by a power mean–variance relationship:

$$
\mathrm{Var}(Y) = \phi \mu^p
$$

where $\mu$ is the mean, $\phi$ is a dispersion parameter, and $p$ is the **Tweedie power parameter**. [2](https://en.wikipedia.org/wiki/Tweedie_distribution)

Different values of $p$ correspond to standard distributions:

| $p$ | Distribution |
|--------|-------------|
| 0 | Gaussian |
| 1 | Poisson |
| 2 | Gamma |
| 3 | Inverse Gaussian |

The most relevant case for WMH is:

$$
1 < p < 2
$$

In this range, the Tweedie distribution corresponds to a **compound Poisson–gamma distribution**, which has:

- A point mass at zero  
- A continuous, positive, right-skewed distribution for $Y > 0$ [4](https://cran.r-universe.dev/tweedie/doc/tweedie.html)  

This makes it particularly suitable for WMH data.

---

## Interpretation as a Compound Process

In the compound Poisson–gamma representation:

$$
Y = \sum_{i=1}^{N} Z_i
$$

where:

- $N \sim \text{Poisson}(\lambda)$  
- $Z_i$ are independent gamma variables  

If $N = 0$, then $Y = 0$; otherwise, $Y$ is positive and continuous. [5](https://en.wikipedia.org/wiki/Compound_Poisson_distribution)  

This representation provides a natural interpretation for WMH:

- Zero WMH → no underlying lesion processes  
- Positive WMH → accumulation of multiple lesion contributions  

---

## Choice of Link Function

In GLMs, the link function specifies how the mean relates to covariates. The **log link** is defined as:

$$
\log(\mu) = X \beta
\quad \Rightarrow \quad
\mu = \exp(X\beta)
$$

---

## Advantages of the Log Link

### 1. Ensuring Positivity

The log link guarantees:

$$
\mu > 0
$$

This is consistent with the domain of WMH volumes and avoids invalid predictions.

---

### 2. Handling Skewness

Right-skewed outcomes are naturally stabilised on the log scale. This improves numerical behaviour and estimation stability.

---

### 3. Interpretability

Coefficients have a multiplicative interpretation:

$$
\exp(\beta_j) - 1
$$

represents a proportional change in the mean outcome for a one-unit increase in a predictor.

---

### 4. Compatibility with the Tweedie Variance Structure

The log link aligns well with the mean–variance relationship:

$$
\mathrm{Var}(Y) \propto \mu^p
$$

which reflects increasing variability with increasing mean — a common feature of WMH data.

---

### 5. Practical Considerations

Tweedie GLMs are widely used for outcomes that:

- include zeros  
- are otherwise continuous and positive  
- are strongly skewed  

Examples include rainfall, healthcare costs, and income data. [6](https://library.virginia.edu/data/articles/getting-started-tweedie-models-0)  

The log link is the standard choice in these settings due to its robustness and interpretability.

---

## Comparison with Gamma Models

Gamma GLMs (typically with a log link) are a common alternative for skewed biomedical outcomes. However:

- Gamma models require strictly positive data  
- They cannot represent the probability of zero  

As a result, they are misspecified for WMH outcomes when zero values are present.

The Tweedie model resolves this limitation by incorporating both zeros and positive values within a single likelihood framework, avoiding the need for ad hoc solutions.

---

## Conclusion

The Tweedie generalized linear model with a log link provides a principled and flexible approach for modelling white matter hyperintensities. Specifically:

- The Tweedie family with $1 < p < 2$ captures both zero and continuous positive outcomes  
- The compound Poisson–gamma structure provides a natural interpretation for WMH accumulation  
- The log link ensures positivity, improves stability, and yields interpretable effects  

Taken together, these properties make the Tweedie model a compelling alternative to conventional gamma-based approaches when modelling WMH data with zeros.

---

## References

- Dunn, P. K., & Smyth, G. K. (2005, 2008). Tweedie exponential dispersion models  
- Hardin, J.W. and Hilbe, J.M., (2018). Generalized Linear Models and Extensions. 4th Edition, Stata Press, ISBN 978-1-59718-225-6.
- Jørgensen, B. (1987). Exponential dispersion models  
- Smyth, G. K. (1996). Regression modelling of data with exact zeros  
- McCullagh, P., & Nelder, J. A. (1989). *Generalized Linear Models*  
