/* tweedie_dev_resid.double
Calculates deviance residuals for the Tweedie model
and plots them
*/
* check if muhat exists (e.g. ran rqr first)
capture confirm variable muhat
if _rc {    
	predict double muhat, mu
}

gen double dev = .

local p = 1.5

replace dev = 2 * ( ///
    (y^(2-`p')) / ((1-`p')*(2-`p')) ///
    - (y * muhat^(1-`p')) / (1-`p') ///
    + (muhat^(2-`p')) / (2-`p') ///
)

gen double rdev = sign(y - muhat) * sqrt(dev)
scatter rdev muhat
qnorm rdev
histogram rdev, normal