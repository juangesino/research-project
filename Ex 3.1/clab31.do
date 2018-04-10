/*****      Start Part 0      *****/
// Clear screen.
cls
// Clear memory.
clear all
// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 3.1"
/*****      End Part 0      *****/


/*****      Start Part 1      *****/
// Question 1
use docsim
// Variable descriptions and labels.
desc
// Summary statistics
sum
// Histogram of students who attended medschool.
hist x
// Histogram of high school GPA.
hist hsgpa
// Histogram of Earnings at age 35.
hist y
/*
The histogram for GPA looks counterintuitive because it
show only two options 0 or 1. However, this is due to
not using real GDP but rather a measure of GDP low (0)
or high (1).
The histogram for y (earnings at age 35) seems to resemble
a normal distribution. However, there seems to be two bells,
one around 40 and another around 100. At first sight, it
seems that the non-doctors may be responsible for the first
bell (lower average income) and the doctors responsible for
the second bell (higher average income). This information
is not conclusive by only looing at this graph.
*/
// Question 2
tab group apply
tab group hsgpa
// Question 3
ttest y, by(x)
/*
The conclusion would be to reject the null-hypothesis
in favour of the alternative hpyothesis. Therefore,
we would conclude that doctors earn more than non-doctors.
However, this is not a "fruitful" comparison as we are
comparing different groups of people.
Slide 37: Non-fruitful comparisons
*/
// Question 4
gen x_shft = x + 0.01*(group==1)+ 0.02*(group==2)
gen y_1 = y if group==1
gen y_2 = y if group==2
gen y_34 = y if inlist(group,3,4)
twoway (scatter y_34 y_1 y_2 x_shft , ms(o o o) mc(gs8 red orange)) (lfit y x), xtitle("Medschool") xlabel(0 "No" 1 "Yes") name(all) ytitle(Yearly income age 35 (1000 euro)) legend(order(1 "Groups 3/4" 2 "Group 1" 3 "Group 2" 4 "Comparison uncontrolled)") cols(3))
/*
The left dots are the people who did not attend medschool.
The dots on the right are the students who attended medschool.
Group 1 (red): Low GPA students that applied to medschool.
Group 2 (orange): High GPA students that applied to medschool.
Groups 3/5 (grey): Students who did not applied to medschool.
The line shows the relation between the average
wage (at age 35) of people who did not attend medschool and
people who did.
*/
// Question 5
tab x apply
tabstat y hsgpa if x==0, by(apply)
drop if apply == 0
count
/*
The first table shows the number of students that applied
to medschool and those who attended medschool.
We can see that from those who applied to medschool (788),
502 of them attended medschool and 286 did not.
All of the students that did not applied to medschool (3212)
did not attended medschool (obvious).

The second table shows the average y (wage at age 35)
for students that applied to medschool and those who
did not. We can see that the average wage for students
that applied to medschool is higher thant for those who
didn't.

This table also shows the average GPA for this two groups.
It seems to be higher for people that applied to medschool.
*/
// 788 observations remain.
// Question 6
ttest y, by(x)
tabstat y hsgpa , by(x)
/*
It still isn't a 'fruitful' comparison because we are
comparing people with low and high GPA. It may be the
case that these people are more hard-woring in general
and so their high wage is a consequence of this.
Slide 38.
*/
// Question 7
twoway (scatter y_1 y_2 x_shft , ms(o o) mc(red orange)) (lfit y x , lc(gs8)) , xlabel(0 "No" 1 "Yes") xtitle("Medschool") ytitle(Yearly income age 35 (1000 euro)) legend(order(1 "Group 1" 2 "Group 2" 3 "Comparison (uncontrolled)") rows(1)) name(applall)
/*
We can see that even for those students who did not attend
medschool and had a high GPA, their average wage is higher
than those with low GPA. The same is true for students
who attended medschool.
*/
// Question 8
bys hsgpa: ttest y , by(x)
/*
The command runs the t-test for the two groups: low GPA
and high GPA.

For low GPA students:
We get an ATE 95% confidence interval of [-42.06; -36.15]
and a t-value of -26.10. This means that our t-value is not
inside the confidence interval and thus we reject the
null-hypothesis, assuming the alternative hypothesis.


For high GPA students:
We get an ATE 95% confidence interval of [-40.55; -36.61]
and a t-value of -38.42. This means that our t-value is
inside the confidence interval and thus we do not reject
the null-hypothesis.


Slides 40 and 41.
*/
// Question 9
twoway (scatter y_1 y_2 x_shft , ms(o o) mc(red orange)) (lfit y_1 x , lc(red)) (lfit y_2 x , lc(orange)), xtitle("Medschool") ytitle(Yearly income age 35 (1000 euro)) xlabel(0 "No" 1 "Yes") legend(order(3 "Comparison within Group 1" 4 "Comparison within Group 2") rows(1)) name(applby)
/*
In this case, we see the comparison separated for each
group (high and low GPA). In this way, we can compare
students with high GPA who did not attend medschool
with other students with high GPA who did. In the same
way, se compare students with low GPA who did not attended
medschool with students who also had low GPA but attended
medschool. This eliminates the bias produced by comparing
two different types of people.
*/
/*****      End Part 1      *****/


/*****      Start Part 2      *****/
// Question 10
ssc install estout, replace
eststo r1: reg y x, r
eststo r2: reg y x hsgpa, r
/*
These are linear regression between the wage (y) and the
value x (if they attended medschool or didn't). The
coefficient for x is the effect that attending medschool
has on the wage.

The second regression also takes into account the GPA
of the students, and its coeffient explains the effect
that GPA has on the wage (which seems to be significant).

The _cons coeffient captures all unobserved influences
on the wage. Because this is lower in the second regression,
this one is more accurate.
*/
// Question 11
eststo r3: reg y x if hsgpa==0, r
eststo r4: reg y x if hsgpa==1, r
/*
We obtain two different regressions, one for low GPA
and another for high GPA. Both of them give the same
results we obtained in question 8 when we did the
t-test for the different GPA.
*/
// Question 12
esttab r1 r3 r4 r2, b(a2) se
/*
The table shows each linear regression that we made
with its coeffients, and their standard error in
between parenthesis. The value for N show the sample
size used in each regression.
*/
/*****      End Part 2      *****/
