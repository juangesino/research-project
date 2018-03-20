/*****      Start Part 0      *****/
// Clear screen.
cls
// Clear memory.
clear all
// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 2.2"
// Initialize random seed
set seed 123
/*****      End Part 0      *****/


/*****      Start Part 1      *****/
// Question 1
// Open data file
use upop_rdraw_20k.dta
// Run provided programs.
run progs.do
// Generate random sample of 1000 observations.
random_sample 1000
// Question 2
sum y if x==0
sum y if x==1
/*
TODO: What are these summary statistics?
*/
// T-test
// H₀: μ₀ = μ₁
// H₁: μ₀ ≠ μ₁
/*
TODO: Do calculations.
*/
/*
TODO: Conclusion.
*/
// Question 3
critvalplot, tstat(2.57) name(tstat) // TODO: Replace 2.57 with the t-stat found.
/*
The obtained t-statistic lies inside the critical region.
From the graph it is clear that there is enough
statistical evidence given the significance level of
5% to reject the null-hypothesis H₀ and conclude
the alternative hypothesis H₁.
*/
// Question 4
ttest y , by(x) unequal
/*
TODO: Your t-statistic may be slightly different, why?
*/
// Question 5
pvalplot, tstat(2.58) name(pval)
/*
TODO: Use the graph to explain what a p-value is and
how it can be used to reject H₀.
TODO: The p-value in the graph is slightly smaller than
in the table of question 4. Can you explain why?
(Hint: look at the slide with remarks about the t-test)
*/
/*****      End Part 1      *****/


/*****      Start Part 2      *****/
// Question 6
ttest y , by(x) unequal
/*
TODO: Is it likely that the true effect is 0.20?
TODO: Would an effect of 0.02 be rejected?
TODO: If JSA is only worth the cost if it reduces
unemployment by 4%-points or more, does this sample
produce conclusive evidence?
*/
// Question 7
twoway (function y = normalden((x-0.303)/0.0220), range(0 1) lc(blue)) ///
	   (function y = normalden((x-0.381)/0.0222), range(0 1) lc(red)), ///
		legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) ///
		xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff)
/*
TODO: Explain what you see.
*/
// Question 8
twoway (function y = normalden((x-0.303)/(sqrt(2)*0.0220)), range(0 1) lc(blue)) ///
	   (function y = normalden((x-0.381)/(sqrt(2)*0.0222)), range(0 1) lc(red)), ///
		legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) ///
		xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff2)
/*
TODO: What will the standard errors now become?
TODO: Is the estimated ATE = 0.077 still significant
with this sample size?
TODO: Compare both graphs.
*/
/*****      End Part 2      *****/
