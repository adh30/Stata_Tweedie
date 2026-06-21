{smcl}
{* *! version 1.0 21jun2026}{...}
{title:tweedie}

{p 4 4 2}
{hi:tweedie} {hline 2} Tweedie variance function for use with {cmd:glim}-style GLM framework

{title:Syntax}

{p 4 8 2}
Internal program called by {cmd:glim} or related routines:

{p 8 8 2}
{cmd:tweedie} {it:todo eta mu ret}

{p 4 4 2}
Not intended for direct use by end users.

{title:Description}

{p 4 4 2}
{cmd:tweedie} implements the Tweedie family variance function and associated
quantities for use within a generalized linear model (GLM) framework.

{p 4 4 2}
The Tweedie family is defined by the mean–variance relationship:

{p 8 8 2}
Var(Y) = phi * mu^p

{p 4 4 2}
where {it:mu} is the mean, {it:phi} is a dispersion parameter, and {it:p}
is the variance power parameter stored in {cmd:$SGLM_fa}.

{p 4 4 2}
For 1 < p < 2, the distribution corresponds to a compound
Poisson–gamma model with support on zero and positive values.

{title:Global macros}

{p 4 4 2}
The program relies on the following globals:

{p 8 8 2}
{cmd:$SGLM_fa} : variance power parameter (p)
{p_end}
{p 8 8 2}
{cmd:$SGLM_p}  : link power parameter
{p_end}
{p 8 8 2}
{cmd:$SGLM_y}  : dependent variable
{p_end}

{title:Operations}

{p 4 4 2}
The behaviour depends on the value of {it:todo}:

{col 8}{hline 50}
{col 8}Value{col 20}Function
{col 8}{hline 50}
{col 8}-1{col 20}Initialisation and family description
{col 8}0{col 20}Link function
{col 8}1{col 20}Variance function V(mu)
{col 8}2{col 20}Derivative dV/dmu
{col 8}3{col 20}Deviance
{col 8}4{col 20}Anscombe residual (not implemented)
{col 8}5{col 20}Log-likelihood (not supported)
{col 8}6{col 20}Deviance adjustment
{col 8}{hline 50}

{title:Link function}

{p 4 4 2}
If {cmd:$SGLM_p} = 0 (default), a log link is used:

{p 8 8 2}
eta = ln(mu)

{p 4 4 2}
Otherwise:

{p 8 8 2}
eta = mu^p

{title:Deviance}

{p 4 4 2}
The deviance is defined as:

{p 8 8 2}
D(y, mu) = 2 * [ y^(2-p)/((1-p)(2-p))
               - y*mu^(1-p)/(1-p)
               + mu^(2-p)/(2-p) ]

{p 4 4 2}
Special cases:

{p 8 8 2}
p = 1 : Poisson deviance
{p_end}
{p 8 8 2}
p = 2 : Not supported
{p_end}

{title:Remarks}

{p 4 4 2}
{cmd:tweedie} is designed for IRLS-based estimation only. Full likelihood
evaluation is not implemented.

{p 4 4 2}
The most common usage for continuous outcomes with zeros is:

{p 8 8 2}
1 < p < 2

{p 4 4 2}
In this range, the model represents a compound Poisson–gamma distribution.

{title:Examples}

{p 4 4 2}
Typical setup with log link:

{cmd}
    global SGLM_p 0
    global SGLM_fa 1.5

    glim y x1 x2, family(tweedie)
{txt}

{title:Author}

{p 4 4 2}
Custom Tweedie implementation for use with Stata GLM framework.

{title:See also}

{p 4 4 2}
{help glm}, {help glim}