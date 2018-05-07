/*****      Start Part 0      *****/
// Clear screen.
cls
// Clear memory.
clear all
// Change directory to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 4.1"
/*****      End Part 0      *****/


/*****      Start Part 1      *****/
// Question 1
use gt_data
desc
sum
/* HITOGRAMS */
hist cohort, name(hist_cohort)
hist male, name(hist_male)
hist age, name(hist_age)
hist ist_norm, name(hist_ist_norm)
hist cito, name(hist_cito)
hist resmath, name(hist_resmath)
hist reslang, name(hist_reslang)
hist gt, name(hist_gt)
/*
TODO: What variables do you think are realized prior to,
and what are realized post of the GT progam?
*/
// Question 2
tabstat *, by(gt) format(%6.2f)
/*
TODO: Are both groups comparable?
TODO: Do we have apples to apples or apples to oranges here?
TODO: If there is selection, is it positive or negative?
*/
// Question 3
reg resmath male age ist cito, r
/*
TODO: Is gender predictive?
TODO: So, is imbalance with respect to gender a problem?
*/
// Question 4
reg resmath male age ist cito, r beta
/*
TODO: What does this reveal?
TODO: Is the coefficient of age really that big, or are
some of the others bigger?
*/
// Question 5
twoway (scatter ist_norm cito if gt==0, ms(Oh) mc(blue) ) (scatter ist_norm cito if gt==1, ms(X) mc(black)), name(overlap)
/*
TODO: Do we have overlap?
TODO: Can we use the RC design here? Explain.
*/
/*****      End Part 1      *****/


/*****      Start Part 2      *****/
// Question 6
twoway (scatter resmath ist_norm if gt==0, ms(Oh) mc(blue) ) (scatter resmath ist_norm if gt==1, ms(X) mc(black)), name(rd0_ist)
// Question 7
twoway (scatter resmath ist_norm if gt==0, ms(Oh) mc(blue) ) (scatter resmath ist_norm if gt==1, ms(X) mc(black)) (lfit resmath ist_norm if gt==0, lc(red) range(. 0)) (lfit resmath ist_norm if gt==1, lc(red) range(0 .)), name(rd1_ist)
// Question 8
qui eststo a: reg resmath gt, r
eststo b: reg resmath gt ist_norm c.gt#c.ist_norm , r
/*
TODO: What is the estimated effect β1?
TODO: What are β2 and β3, and what do they measure?
*/
// Question 9
run progs.do
grrd resmath
// Question 10
eststo c: reg resmath gt ist_norm c.gt#c.ist_norm age male cito i.cohort, r
esttab a b c, b(a2) se nogap star(* 0.10 ** 0.05 *** 0.01)
/*
TODO: Look at columns (1) – (3) and explain the differences
and similarities.
TODO: Do you believe it is credible to assume that students
around ist_norm=0 are similar?
*/
// Question 11
qui eststo d: reg reslang gt ist_norm c.gt#c.ist_norm age male cito i.cohort,r
grrd reslang
esttab a b c d, b(a2) se nogap star(* 0.10 ** 0.05 *** 0.01)
/*
TODO: Do we see an effect on language skills as well?
TODO: How large?
*/
/*****      End Part 2      *****/
