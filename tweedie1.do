/* 
This do file uses the support file tweedie.ado.  It illustrates estimation of this user-written variance function to fit models that are equivalent of linear regression and Poisson regression. This illustration merely captures those particular instances where the Tweedie variance is the same as other known variance functions to give the reader a foundation for understanding Tweedie variance when it falls between or outside of these known variances. 
The Tweedie distribution with power 1 is equivalent to Poisson variance. Because the canonical link function for the Tweedie family is the power link, we specify power = 0, which is the same as the log link.
The Tweedie distribution with power 0 is equivalent to Gaussian variance. We specify power =1, which is the same a the Gaussian family canonical identity-link.

The example is taken from Hardin and Hilbe's Generalized Linear Models and Extensions. 4th Edition, Stata Press 2018, isbn 978-1-59718-225-6.

The implementation gives the same results as shown in the Hardin and Hilbe book.
*/

* Book examples
use http://www.stata-press.com/data/hh4/medpar, clear
glm los hmo white age, family(poisson) irls nolog
glm los hmo white age, family(tweedie 1) link(power 0) irls nolog

glm los hmo white age, family(gauss) irls nolog
glm los hmo white age, family(tweedie 0) link(power 1) irls nolog

/* Gamma with zeros [e.g. WMH]
p determines the member of the Tweedie family where ) = normal, 1 = Poisson, 1<p<2 Compound Poisson-Gamma, 2 = gamma, 3 = inverse Gaussian. In essence p controls the variance mean relationship - small p variance grows slowly large p variance grows quickly. A log link is used assuming a multiplicaitve effect. I prefer it as it should be more stable and is easily interpretable as well as being mechanistically plausible. 
*/
glm los hmo white age, family(tweedie 1.5) link(log) irls nolog