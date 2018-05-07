qui {

cap program drop grrd
program define grrd
	preserve
	global index ist_norm

	reg `1' c.$index##gt,
	predict yfitrd
	
	
	egen ist_b=cut($index), at(-80(4)40)
	replace ist_b = ist_b+2
	

	collapse (mean) mres=`1' yfitrd (count) n=`1', by(ist_b gt)
	gen miss=.
	
	
	global gropt ytitle(`1' score average (grades 2-6)) xtitle(Baseline IST distance to threshold) ylabel(5(1)10)


	//ALTERNATIVE Flex in red
  	cap gen mres0 = mres if gt==0
	cap gen mres1 = mres if gt==1
	global sopt mc(blue blue black black) xline( 0, lp(dash) lc(red)) xlabel(-60(15)30) xsc(r(-75 45))

  	twoway (scatter miss mres0 miss mres1 ist_b  [fw=n], msize(*1 *0.50 *1 *0.50) $sopt m(Oh Oh X X) ) ///
  		(lfit yfitrd ist_b if gt==0, lc(blue) range(. 0)) (lfit yfitrd ist_b if gt==1, lc(black) range(0 .)),  ///
		legend(order(1 "Control child" 3 "Treated child (GT)" ) pos(0) col(1) bplacement(nw))  name(rd_`1', replace) $gropt

	restore 

end





}



