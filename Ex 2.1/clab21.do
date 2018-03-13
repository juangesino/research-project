// Start Part 0

// Clear screen.
cls
// Clear memory.
clear all
// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 2.1"
// Initialize random seed
set seed 6774
// Set variables precision
set type double, perm

// Start Part 1

// Question 1
// Open potential ourcomes file
use upop.dta
/*
The data file contains 3 variables (id, y0 and y1).
The varaible id is an identifier number for each person.
The other variables determines if the person got a job
after 8 months when there was JSA and when there wasn't.
*/
// Question 2
tab y0 y1, cell
/*
The table shows the number of people that have that got
a job after 8 months with and without JSA.
The effect of JSA is not positive for everyone.
*/
// Question 3
egen y0popav = mean(y0)
egen y1popav = mean(y1)
gen ate = y1popav - y0popav
sum y0 y1 y0popav y1popav ate
/*
TODO:
What do the summary statistics tell you?
Number of obs., std. dev., average, min and max.

What does ate stand for, and how can we interpret it?
ATE means 'Average Treatment Effect'. It's the difference
between the averages of the two potential outcomes
*/
// Question 4
hist y0, frac name(gry0) nodraw
hist y1, frac name(gry1) nodraw
graph combine gry0 gry1

// Start Part 2

// Question 5
program random_sample
qui {
  cap drop random s x y
  gen random = rnormal() //generates random normal number
  sort random //sorts on the random number
  gen s = (_n<=`1') //first `1’ obs equal 1, others 0
  gen x = (runiform()<0.5) if s==1 //random x=0 or x=1
  gen y = x*y1+(1-x)*y0 //you observe only y0 or y1
}
end program
random_sample 1000
sum y0 y1 s x y
/*
TODO: Can you explain these statistics?
s is a binary variable that determines if the obs. is part
of the sample or not.
*/
// Question 6
sum y if x==0
return list
gen y0mean = r(mean)
gen y0sd = r(sd)
gen n0 = r(N)
sum y if x==1
return list
gen y1mean = r(mean)
gen y1sd = r(sd)
gen n1 = r(N)
/*
TODO: What is your guess of the effect of JSA based on this sample?
*/
// Question 7
sort id
gen rdraw = _n
qui foreach v of varlist y0mean y0sd n0 y1mean y1sd n1 {
  replace `v' = . if rdraw!=1
}
// Question 8
timer on 1
qui forv s = 2 / 500 {
  random_sample 1000
  sum y if x==0
  replace y0mean = r(mean) if rdraw==`s'
  replace y0sd = r(sd) if rdraw==`s'
  replace n0 = r(N) if rdraw==`s'
  sum y if x==1
  replace y1mean = r(mean) if rdraw==`s'
  replace y1sd = r(sd) if rdraw==`s'
  replace n1 = r(N) if rdraw==`s'
}
timer off 1
timer list 1
sort id
order rdraw y0mean - n1, last
/*
It took the program 40s to run 500 simulations.
This means it took 0.08s for each simulation.
For 10,000 simulations the expected time is 800s (13min).
*/
// Question 9
sum rdraw
sum y0mean y1mean
hist y0mean, kdensity name(gry0mean_sim05k)
/*
TODO: What do these statistics and the graph tell you? Is it unlikely to observe only 25%
employment amongst the no JSA group?
*/
// Question 10
merge 1:1 rdraw using urdraw, update nogen
hist y0mean, kdensity name(gry0mean_sim20k)
hist y0, frac name(gry0, replace)
/*
TODO: How do the distributions of the sample mean of y0 compare for the 500 and 20k
simulation? Finally, when you look at the original distribution of y0, can you explain
how (on earth) it can be that y0mean appears to be normally distributed while y0 is
binary!?
*/
// Question 11
gen y0se = y0sd/sqrt(n0)
gen tstat = (y0mean - y0popav)/y0se
sum tstat
twoway (hist tstat) (function y = normalden(x), range(-4 4) lc(red)), ///
legend(order(1 "t-stat (20k simulated)" 2 "Normal distribution") ) name(grt)
// Question 12
di  "t-crit low= ", invnormal(0.025)
di "t-crit high= ", invnormal(1-0.025)
twoway (function y = normalden(x), range(-4 -1.96) color(sand) recast(area)) ///
(function y = normalden(x), range(1.96 4) color(sand) recast(area)) ///
(function y = normalden(x), range(-4 4) lc(red) ), ///
legend(order(1 "5% area (2.5%+2.5%)" 3 "Normal distribution")) ///
xtitle(t-stat) ytitle(density) xlabel(-1.96 0 1.96) name(grnormal)

// Start Part 3

// Question 13
random_sample 1000
sum y if x==0
di "y0se: " (r(sd)/sqrt(r(N)))
di "H0: y0=0 t-stat=" (r(mean)) / (r(sd)/sqrt(r(N)))
di "H0: y0=0.3 t-stat=" (r(mean)-0.3) / (r(sd)/sqrt(r(N)))
/*
H0: y0=0 REJECTED (t-stat=14.54696)
H0: y0=0.3 NOT REJECTED (t-stat=.09829027)
*/
// Question 14
ttest y==0 if x==0
ttest y==0.3 if x==0
/*
We obtain the same results.
In the first test, the probability of mean != 0 is 0
In the second test, the probability of mean != 0.3 is 0.92

TODO: Do you see the p-values? What are they?
*/
// Question 15
twoway (function y = normalden(x), range(-4 4) lc(red)), xline(`=r(t)') ///
legend( order(1 "Normal distribution"))
/*
It is not surprising that the hypothesis was not rejected.
*/
