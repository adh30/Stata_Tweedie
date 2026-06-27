/* rqr plot
Computes randomised quantile residuals (RQRs) for a Tweedie GLM in Stata without a likelihood. This involves a Monte Carlo approximation of the CDF, then map to Normal via Φ⁻¹. 
*/

* Step 1: fitted values
predict double muhat, mu
scalar phi = e(dispers)
local p = 1.5

* Step 2: initialise
gen double u = .
set seed 123

local R = 200
tempvar count simy

gen double `count' = 0

forvalues r = 1/`R' {

    * Poisson rate
    gen double lambda = (muhat^((2-`p'))) / (phi*(2-`p'))

    * Draw Poisson
    gen int N = rpoisson(lambda)

    * Approximate Tweedie:
    gen double `simy' = N * rgamma(1/( `p'-1 ), phi*( `p'-1 )* (muhat^((1-`p'))))

    * Update empirical CDF
    replace `count' = `count' + (`simy' <= y)

    drop `simy' lambda N
}

* Randomised CDF
replace u = (`count' + runiform()) / (`R' + 1)
drop `count'

* RQR
gen double rqr = invnormal(u)

* Plots
histogram rqr, normal
qnorm rqr
scatter rqr muhat, yline(0)