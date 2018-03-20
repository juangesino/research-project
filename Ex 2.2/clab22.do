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
The first table gives us the summary for when there
was no JSA. We can see that 520 observations were made
from the 1000 sample, the mean for getting a job after 8
months is 0.3038462 with a standard deviation of 0.4603599.
The second table gives us the same statistics for the
cases were there was JSA in our sample. There were 480
observations, with a mean of 0.38125 (slightly larger
than the result for no JSA) and a standard deviation
of 0.4862005.

T-test
H₀: μ₀ = μ₁
H₁: μ₀ ≠ μ₁
For computation see attached file `clab22.pdf`
t-test = -2.57
|t-test| > 1.96 (t-critical given ⍺ = 5%)
=> Reject H₀

Given this sample and a significance level of 5%
there is enough statistical evidence to reject H₀
and conclude H₁.
*/
// Question 3
critvalplot, tstat(2.57) name(tstat)
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
The difference in t-statistic computation is explained
by the rounding of numbers (3 decimal places).
rounding
*/
// Question 5
pvalplot, tstat(2.58) name(pval)
/*
The p-value is the probability of obtaining H₁ given
H₀. If this value is lower than our significance level
of 5% (⍺), it means that the outcome is rare and H₀
should be rejected in favour of H₁.
The values are not exactly the same becasue t-stat
is not exactly normally distributed, it tends to a
normal distribution as n gets larger.
*/
/*****      End Part 1      *****/


/*****      Start Part 2      *****/
// Question 6
ttest y , by(x) unequal
/*
TODO: Is it likely that the true effect is 0.20?
An effect of 0.02 would be inside the 95% CI
and not be rejected.
TODO: If JSA is only worth the cost if it reduces
unemployment by 4%-points or more, does this sample
produce conclusive evidence?
*/
// Question 7
twoway (function y = normalden((x-0.303)/0.0220), range(0 1) lc(blue)) (function y = normalden((x-0.381)/0.0222), range(0 1) lc(red)), legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff)
/*
The graph shows the mean employment distribution
for both the cases when there was JSA and when there
was not. We can see both means; 0.303 for no JSA
and 0.381 when JSA was present.
*/
// Question 8
twoway (function y = normalden((x-0.303)/(sqrt(2)*0.0220)), range(0 1) lc(blue)) (function y = normalden((x-0.381)/(sqrt(2)*0.0222)), range(0 1) lc(red)), legend(order(1 "JSA=0" 2 "JSA=1")) xlabel(0 0.303 0.381 1) xline(0.303 0.381, lp(dash)) xtitle(mean employement) ytitle(density) name(diff2)
/*
TODO: What will the standard errors now become?
TODO: Is the estimated ATE = 0.077 still significant
with this sample size?
In the second graph we can see how we lost accuracy
as the bell of the curves becomes wider than in the
first graph.
*/
/*****      End Part 2      *****/
