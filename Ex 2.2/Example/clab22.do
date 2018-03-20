cls
clear all

//change folder
cd "X:\Applied Ectrcs Prop\statalab\clab22"
set seed 123








//q1
use upop
run progs.do
random_sample 1000







//q2
sum y if x==0
sum y if x==1
mata
m0  = 0.304
sd0 = 0.460
n0  = 520
m1  = 0.381
sd1 = 0.486
n1  = 480
atehat = m1-m0
se = sqrt(sd0^2/n0 + sd1^2/n1)
t = (atehat - 0)/se
(atehat, se, t)
end mata




//q3
critvalplot, tstat(2.57) name(tstat)



//q4
ttest y , by(x) unequal
//why slight diff t-stat?


//q5
pvalplot, tstat(2.58) name(pval)
//why slight diff in pval?







//Part 2


//q6
ttest y , by(x) unequal




//q7
twoway (function y = normalden((x-0.303)/0.0220), range(0 1) lc(blue)) ///
	   (function y = normalden((x-0.381)/0.0222), range(0 1) lc(red)), ///
		legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) ///
		xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff)


//q8
twoway (function y = normalden((x-0.303)/(sqrt(2)*0.0220)), range(0 1) lc(blue)) ///
	   (function y = normalden((x-0.381)/(sqrt(2)*0.0222)), range(0 1) lc(red)), ///
		legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) ///
		xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff2)







