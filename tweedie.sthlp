{smcl}
{* *! version 1.0 21jun2026}{...}
{title:tweedie}

{p 4 4 2}
{hi:tweedie} {hline 2} Tweedie variance function for use with {cmd:glm}-style generalized linear models

{title:Syntax}

{p 4 8 2}
Internal program called by {cmd:glm} or related routines:

{p 8 8 2}
{cmd:tweedie} {it:todo eta mu ret}

{p 4 4 2}
Not intended for direct use by end users.

{title:Description}

{p 4 4 2}
{cmd:tweedie} implements the Tweedie family variance function and associated
quantities for use within a generalized linear model (GLM) framework. 
It only supports iteratively reweighted least squares (IRLS) fitting.

{p 4 4 2}
The Tweedie family is defined by the mean–variance relationship:

{p 8 8 2}
Var(Y) = phi * mu^p

{p 4 4 2}
where {it:mu} is the mean, {it:phi} is a dispersion parameter, and {it:p}
is the variance power parameter.

{p 4 4 2}
For 1 < p < 2, the distribution corresponds to a compound
Poisson–gamma model with support on zero and positive values.

{title:Examples}

{p 4 4 2}
Example shows how this user-written variance function can be used be to fit models that are equivalent of Poisson and linear regression (check validity). 
Followed by a model where 1<p<2, a compound Poisson–gamma structure, which would be appropriate for a highly right skewed distribution that includes zeros. 
 

{cmd}
    use http://www.stata-press.com/data/hh4/medpar, clear
    glm los hmo white age, family(poisson) irls nolog
    glm los hmo white age, family(tweedie 1) link(power 0) irls nolog

    glm los hmo white age, family(gauss) irls nolog
    glm los hmo white age, family(tweedie 0) link(power 1) irls nolog
    
    glm los hmo white age, family(tweedie 1.5) link(log) irls nolog
{txt}

{title:Author}
Alun Hughes (alun.hughes@ucl.ac.uk) based on code in Hardin and Hilbe's 
Generalized Linear Models and Extensions. 4th Edition, Stata Press 2018, isbn 978-1-59718-225-6.

{title:See also}

{p 4 4 2}
{help glm}, {help glim}