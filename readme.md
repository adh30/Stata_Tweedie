# Stata_Tweedie

Implements a Tweedie family in Stata's glm command. 

## Why the Tweedie Model with Log Link is Appropriate for Modelling White Matter Hyperintensities

White matter hyperintensities (WMH) are widely used as markers of brain small vessel disease. WMH volumes typically exhibit a **highly right-skewed distribution**. In some cases, such as younger people or for regional WMH volumes there may be a substantial proportion of zero volumes. This presents challenges for most Generalized linear models (GLMs).

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

where $\mu$ is the mean, $\phi$ is a dispersion parameter, and $p$ is the **Tweedie power parameter**. [2](https://en.wikipedia.org/wiki/Tweedie_distribution)[3]

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

