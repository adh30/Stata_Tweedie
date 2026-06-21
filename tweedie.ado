program define tweedie
    version 15
    args todo eta mu ret

    /* ------------------------------------------------------------
       Title
    ------------------------------------------------------------ */
    if `todo' == -1 {
        global SGLM_vt "Tweedie"
        global SGLM_vf "phi*u^($SGLM_fa)"
        global SGLM_mu "glim_mu 0 ."
        exit
    }

    /* ------------------------------------------------------------
       Link function
    ------------------------------------------------------------ */
    if `todo' == 0 {
        if $SGLM_p < 1e-7 {
            generate double `eta' = ln(`mu')
        }
        else {
            generate double `eta' = `mu'^$SGLM_p
        }
        exit
    }

    /* ------------------------------------------------------------
       Variance function V(mu)
    ------------------------------------------------------------ */
    if `todo' == 1 {
        generate double `ret' = `mu'^$SGLM_fa
        quietly summarize `ret'
        exit
    }

    /* ------------------------------------------------------------
       Derivative dV/dmu
    ------------------------------------------------------------ */
    if `todo' == 2 {
        generate double `ret' = ($SGLM_fa) * `mu'^($SGLM_fa - 1)
        quietly summarize `ret'
        exit
    }

    /* ------------------------------------------------------------
       Deviance
    ------------------------------------------------------------ */
    if `todo' == 3 {
        local y "$SGLM_y"

        /* Disallow p = 2 */
        if abs($SGLM_fa - 2) < 1e-7 {
            di as err "Tweedie variance does not support p = 2"
            exit 198
        }

        if abs($SGLM_fa - 1) < 1e-7 {
            generate double `ret' = 2 * (`y' * ln(`y' / `mu') - (`y' - `mu'))
        }
        else {
            local p = $SGLM_fa
            generate double `ret' = 2 * ( ///
                (`y'^(2 - `p')) / ((1 - `p') * (2 - `p')) ///
                - (`y' * `mu'^(1 - `p')) / (1 - `p') ///
                + `mu'^(2 - `p') / (2 - `p') ///
            )
        }
        exit
    }

    /* ------------------------------------------------------------
       Anscombe residual (not implemented)
    ------------------------------------------------------------ */
    if `todo' == 4 {
        generate double `ret' = .
        exit
    }

    /* ------------------------------------------------------------
       Log-likelihood (not supported)
    ------------------------------------------------------------ */
    if `todo' == 5 {
        di as err "Tweedie family supported by IRLS only"
        exit 198
    }

    /* ------------------------------------------------------------
       Adjustment to deviance
    ------------------------------------------------------------ */
    if `todo' == 6 {
        generate double `ret' = 0
        exit
    }

    /* ------------------------------------------------------------
       Error fallback
    ------------------------------------------------------------ */
    di as err "Unknown call to glim variance function"
    exit 198

end