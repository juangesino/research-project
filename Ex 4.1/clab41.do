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
Prior: male, age, id, ist_norm, gt
Post: cito, resmath, reslang
*/
// Question 2
tabstat *, by(gt) format(%6.2f)
/*
The main difference seems to be in ist_norm.
This does not make for a 'fruitful' comparison.
The selection is possitive, we are compairing students
that are well below the IST threshold, with students that
are well above thise threshold.
*/
// Question 3
reg resmath male age ist cito, r
/*
Gender doesn't seem to be significantly predictive on resmath
score. This means that gender imbalance is not a problem.
*/
// Question 4
reg resmath male age ist cito, r beta
/*
It reveals that a change in age, does not necessarily
cause a big change in resmath. Also, the change in resmath
may be negative as age is incresed.
The coefficient of age is not big, specially compared to
the coefficient for cito and ist_norm.
*/
// Question 5
twoway (scatter ist_norm cito if gt==0, ms(Oh) mc(blue) ) (scatter ist_norm cito if gt==1, ms(X) mc(black)), name(overlap)
/*
There appears to be no overlap.
We can't use RC design because there is no overlap, we can't
compared the data points when there is no overlap.
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
The estimated effect of β1 is about 0.297
β2 accounts for the difference in ist_norm. It indicates
what is the effect of each of the distance to the IST
threshold on the math results.
β3 measures change in slope after the threshold.
*/
// Question 9
run progs.do
grrd resmath
// Question 10
eststo c: reg resmath gt ist_norm c.gt#c.ist_norm age male cito i.cohort, r
esttab a b c, b(a2) se nogap star(* 0.10 ** 0.05 *** 0.01)
/*
The first two regressions don't take into account age, sex,
CITO and cohorts.
The first regression only accounts for gt, thus the
coefficient is much higher than in the next two.
It's credible to assume students around ist_norm=0 are
similar because these students are more similar with
respect to the grades they obtain.
*/
// Question 11
qui eststo d: reg reslang gt ist_norm c.gt#c.ist_norm age male cito i.cohort,r
grrd reslang
esttab a b c d, b(a2) se nogap star(* 0.10 ** 0.05 *** 0.01)
/*
There seems to be a significant effect of 0.14 on language
sills. However, this effect is much lower than the effect
on math skills.
*/
/*****      End Part 2      *****/
