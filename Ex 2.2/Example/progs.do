qui {

// PROGS *************
cap program drop random_sample
program random_sample
qui {
	cap drop random s x y
	gen  random = rnormal()
	sort random
	gen s = (_n<=`1')
	gen x = (runiform()<0.5) if s==1
	gen y = x*y1+(1-x)*y0
	}
end program



cap program drop critvalplot
program critvalplot 
	syntax [anything] [, Alpha(real 5) Tstat(real 0) ONEsided NEGative *]
	
	local l 2
	if ("`negative'"!="") {
		local tcrit = round(invnormal(`alpha'/(100)), 0.01)
		local gr (function y = normalden(x), range(-4 `tcrit') color(sand) recast(area))
		local gropt xlabel( `tcrit' `""`tcrit'" "t-crit""' 0 )
	}
	else if ("`onesided'"!="") {
		local tcrit = round(-invnormal(`alpha'/(100)), 0.01)
		local gr (function y = normalden(x), range(`tcrit' 4) color(sand) recast(area))
		local gropt xlabel(0 `tcrit' `""`tcrit'" "t-crit""' )
	}
	else {
		local tcrit = round(-invnormal(`alpha'/(2*100)), 0.01)
		local gr (function y = normalden(x), range(-4 -`tcrit') color(sand) recast(area)) ///
				(function y = normalden(x), range(`tcrit' 4) color(sand) recast(area))
		local gropt xlabel(-`tcrit' `""-`tcrit'" "t-crit""'  0  `tcrit' `""`tcrit'" "t-crit""' )
		local l 3
	}
	if (`tstat'!=0) {
		local gropt `gropt' xline(`tstat') xlabel(`tstat' `""`tstat'" "t-stat""', add)
	}
	
	local r = max(4, abs(`tstat')+0.5)
	twoway  `gr' (function y = normalden(x), range(-`r' `r') lc(red)  ), ///
			legend(order(1 "`alpha'% area " `l' "Normal distribution")) ///
			xtitle(t-stat) ytitle(density) `gropt' `options'
end program



cap program drop pvalplot
program pvalplot 
	syntax [anything],  Tstat(real) [ONEsided NEGative *]
	
	local l 2
	if ("`negative'"!="") {
		local pval = round(100*(normal(`tstat')), 0.01)
		local gr (function y = normalden(x), range(-4 `tstat') color(sand) recast(area))
		local gropt xline(`tstat') xlabel(`tstat' `""`tstat'" "t-stat""' 0  )
		}
	else if ("`onesided'"!="") {
		local pval = round(100*(1-normal(`tstat')), 0.01)
		local gr (function y = normalden(x), range(`tstat' 4) color(sand) recast(area))
		local gropt xline(`tstat') xlabel(0 `tstat' `""`tstat'" "t-stat""' )
	}
	else {
		local gropt xline(`tstat')
		local tstat = abs(`tstat')
		local pval = round(200*(1-normal(`tstat')), 0.01)
		local gr (function y = normalden(x), range(-4 -`tstat') color(sand) recast(area)) ///
				(function y = normalden(x), range(`tstat' 4) color(sand) recast(area))
		local gropt `gropt' xlabel(-`tstat' `""-`tstat'" "t-stat""'  0  `tstat' `""`tstat'" "t-stat""' )
		local l 3
	}
	local r = max(4, abs(`tstat')+0.5)
	twoway  `gr' (function y = normalden(x), range(-`r' `r') lc(red)  ), ///
			legend(order(1 `"P-value: `=string(`pval',"%4.2f")'% area "' `l' "Normal distribution")) ///
			xtitle(t-stat) ytitle(density) `gropt' `options'
end program



// *********


}



