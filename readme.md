# Stata_Tweedie

Implements a Tweedie family in Stata's Generalized linear models (glm) command. 
## Files
* tweedie.ado - the core program based on Hardin and Hilbe (2018).
* tweedie1.do - runs an example from Hardin and Hilbe
* tweedie.sthlp - stata help file for program
* tweedie_rev_resid.do - calculates deviance residuals and plots them for diagnostics
* tweedie_rqr.do - calculates Randomised Quantile Residual (RQRs) for diagnostics
* tweedie_simulated_data.dta - data generated in R to compare R and Stata analyses. (See below)
* Other code is in R and relates to this comparison.

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

## Comparison between R and Stata
I compared a Tweedie analysis using a compound Poisson–Gamma GLM (`cpglm`) in R on synthetic data (generated using the `statmod`, `cplm`, and `tweedie` packages) with the equivalent implementation in Stata.

The R `cpglm` model uses a **true likelihood-based approach**, converging to maximum likelihood estimates (MLE) for both the regression coefficients and the Tweedie index parameter \(p\).

In contrast, Stata’s `glm` implementation for the Tweedie family uses **iteratively reweighted least squares (IRLS)** with a **quasi-likelihood framework**, where the index parameter \(p\) is fixed at a user-specified value rather than estimated from the data. 
Despite these methodological differences, the resulting parameter estimates in the simulated case are very similar.

---

### Results in R
#### cpglm Model Summary

##### Model Call
| Function | Formula              | Data |
|----------|----------------------|------|
| cpglm    | y ~ x1 + x2          | data |

##### Deviance Residuals
| Min     | 1Q      | Median  | 3Q     | Max    |
|--------|--------|--------|--------|--------|
| -3.1881 | -0.8666 | -0.1653 | 0.5259 | 2.9629 |

##### Coefficients

| Term     | Estimate      | Std Error  | t value  | P    |
|--------|--------|--------|--------|--------|
| x1          | 0.298794  | 0.006728   | 44.41   | <2e-16   | 
| x2          | -0.186876 | 0.018559   | -10.07  | <2e-16   | 
| (Intercept) | 0.514807  | 0.045354   | 11.35   | <2e-16   | 

##### Model Parameters
| Parameter                    | Value  |
|-----------------------------|--------|
| Dispersion parameter        | 1.0171 |
| Index parameter             | 1.5045 |

##### Fit Statistics
| Metric                      | Value   |
|----------------------------|--------|
| Residual deviance (df=997) | 1133.2 |
| AIC                        | 5706.3 |
| Fisher scoring iterations  | 4      |

---

### Results in Stata
##### Model Summary

| Metric                  | Value        |
|------------------------|--------------|
| Number of observations | 1000         |
| Residual df            | 997          |
| Scale parameter        | 1            |
| Deviance               | 1141.2658    |
| Deviance / df          | 1.1447       |
| Pearson                | 1007.544454  |
| Pearson / df           | 1.010576     |
| BIC                    | -5745.766    |


### Model Specification
| Component         | Specification               |
|------------------|----------------------------|
| Family           | Tweedie (p = 1.5)          |
| Variance         | V(u) = φ·u^1.5             |
| Link function    | Log (ln)                   |
| Estimation       | IRLS (MQL Fisher scoring)  |

### Coefficients
| Term        | Estimate  | Std Error | z value | P | 95% CI |
|-------------|-----------|------------|---------|------|----------------|
| x1          | 0.2988052 | 0.0067286  | 44.41   | 0.000| 0.2856174      | 0.3119929      |
| x2          | -0.1868688| 0.018546   | -10.08  | 0.000| -0.2232183     | -0.1505193     |
| _cons       | 0.5147366 | 0.0454147  | 11.33   | 0.000| 0.4257254      | 0.6037478      |

---

## Conclusion

The Tweedie generalized linear model with a log link provides a principled and flexible approach for modelling white matter hyperintensities. Specifically:

- The Tweedie family with $1 < p < 2$ captures both zero and continuous positive outcomes  
- The compound Poisson–gamma structure provides a natural interpretation for WMH accumulation  
- The log link ensures positivity, improves stability, and yields interpretable effects  

Taken together, these properties make the Tweedie model an attractive alternative to conventional gamma-based approaches when modelling WMH data with zeros. 

---

## References

- Dunn, P.K. and Smyth, G.K., 2005. Tweedie exponential dispersion models. In: Encyclopedia of Environmetrics. Chichester: John Wiley & Sons. ISBN-13: 978-0-41789-997-6 
- Hardin, J.W. and Hilbe, J.M., 2018. Generalized Linear Models and Extensions. 4th Edition, Stata Press, ISBN-13: 978-1-59718-225-6.
- Jørgensen, B., 1987. Exponential dispersion models. Journal of the Royal Statistical Society: Series B (Methodological), 49(2), pp.127-145.  
- Smyth, G.K., 1996. Regression modelling of data with exact zeros. Proceedings of the Australian & New Zealand Statistical Conference. Sydney, pp.322-323.  
- McCullagh, P. and Nelder, J.A., 1989. Generalized linear models. 2nd ed. London: Chapman and Hall. ISBN-13: 978-0-41231-760-6
