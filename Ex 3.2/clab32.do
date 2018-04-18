/*****      Start Part 0      *****/
// Clear screen.
cls
// Clear memory.
clear all
// Change directory to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 3.2"
/*****      End Part 0      *****/


/*****      Start Part 1      *****/
// Question 1
use glass
desc
sum
hist glass, name(post)
hist glass_pre, name(pre)
scatter glass glass_pre, name(scatter)
/*
shopid: The ID of the shop the employee works at.
emplid: The ID of the employee.
glass_pre: The avg. amount of glasses sold by the employee
the previous month.
glass: The avg. amount of glasses sold by the employee
this month.
ppp: If there was Performance Pay Plan or not.
*/
// Question 2
tab ppp
/*
There is variation. We have 2755 observations of which 1427
(51.8%) are without PPP and 1328 (48.2%) who have PPP.
*/
twoway (kdensity glass if ppp==0, lc(black)) (kdensity glass if ppp==1, lc(blue)), legend(order(1 "No PPP" 2 "PPP")) name(kden)
/*
From the graph we can see that the average number of glasses
installed is higher for PPP compared to no PPP.
However, this is not enough to say that PPP increases
productivity.
*/
// Question 3
ttest glass, by(ppp) uneq
/*
From this test, we can see the p-value is 0.1196 and it
larger than our 5% significance level. Thus, we do not
reject the null-hypothesis H₀. This does not come as a
surprise after the observation made in Question 2.
*/
// Question 4
eststo a: reg glass ppp, r
/*
In this case, we see the same result we saw in Question 3,
we observe a p-value of 0.12 that is again larger than
our 0.05 significance level. We obtained the same result
than in Question 3.
*/
// Question 5
tabstat glass_pre glass, by(ppp) f(%6.2f)
/*
There seems to be some evidence of negative selection.
The mean amount of glasses sold the previous month for
the group that had PPP is smaller than the average amount
of glasses sold the previous month for the group with
no PPP.
*/
/*****      End Part 1      *****/



/*****      Start Part 2      *****/
// Question 6
egen glass_pre_bin3 = cut(glass_pre), gr(3)
tab glass_pre glass_pre_bin3
tab glass_pre_bin3 ppp
table glass_pre_bin3 ppp, c(mean glass) format(%6.2f)
eststo b: reg glass ppp i.glass_pre_bin3, r
/*

The bins are formed by maing ranges of average glasses
sold on the previous month. Bin 1 from 0 to 2.15,
Bin 2 from 2.2 to 3.35 and Bin 3 from 3.4 to 10.6
In most bins there appear to be variation. Speacially
in Bin 1 where we see 487 people without PPP and 458
without PPP. However, in the other two bins, the variation
is less.
Using this linear regression, we obtain a low p-value
meaning that we should reject the null-hypothesis
and assume the alternative hypothesis.
*/
// Question 7
egen glass_pre_bin10 = cut(glass_pre), gr(10)
eststo c: reg glass ppp i.glass_pre_bin10, r
// Question 8
bys glass_pre_bin10: egen my0=mean(glass) if ppp==0
bys glass_pre_bin10: egen my1=mean(glass) if ppp==1
bys glass_pre_bin10: egen mx=mean(glass_pre)
bys glass_pre_bin10 ppp: egen ny=count(glass)
bys glass_pre_bin10 ppp: gen absmx = abs(glass_pre-mx)
bys glass_pre_bin10 ppp (absmx): gen t = _n
twoway (scatter my0 my1 mx if t==1 [fweight=ny], ms(Oh X) mc(blue black)), legend(order(1 "no PPP" 2 "PPP")) xtitle(Average #glass installed last month (10 bins)) ytitle(Average #glass installed this month) name(control10)
/*
The graph shows the relation between the avg. number of
glasses installed this month and the avg. number of glasses
installed last month for every of the 10 bins (with and
without PPP). We can see how for every bin the avg. number
of glasses is greater for those with PPP.
*/
// Question 9
egen glass_pre_binall = group(glass_pre)
tab glass_pre_binall ppp
table glass_pre_binall ppp, c(mean glass) format(%6.2f)
eststo d: reg glass ppp i.glass_pre_binall , r
/*
We see bins where there is variation and others where
there doesn't seem to be any variation. However, in
general, there seems to be variation in the bins.
There are some bins (specially those with lower glasses
sold the previous month) where we see significant values
for the p-value. In those cases (bins 4 to 19, excluding
bin 14), we cannot confirm an effect of PPP.
*/
// Question 10
eststo e: reg glass ppp glass_pre , r
esttab a b c d e, b(a3) se drop(*.glass*) mti(nocontrol control3 control10 controlall controllinreg)
// Question 11
predict yhat
twoway (scatter my0 my1 mx [fweight=ny], ms(Oh X) mc(blue black)) (line yhat glass_pre if ppp==0, lc(blue)) (line yhat glass_pre if ppp==1, lc(black)) if t==1, legend(order(1 "no PPP" 2 "PPP" 3 "Linear fit" 4 "Linear fit") row(1)) title(Control glass_pre) xtitle(Average #glass installed last month (10 bins)) ytitle(Average #glass installed this month) name(regfit)
/*
This graph shows what we mentioned before, how the average
amount of glasses sold increases with PPP for all bins.
The values are not surprising after seeing the linear
fits shown in this graph.
*/
// Question 12
drop my0 my1 ny mx
egen my0=mean(glass) if ppp==0
egen my1=mean(glass) if ppp==1
egen mx=mean(glass_pre)
bys ppp: egen ny=count(glass)
twoway (scatter my0 my1 mx [fweight=ny], msize(large large) ms(Oh X) mc(blue black)) if t==1, legend(order(1 "no PPP" 2 "PPP")) xlabel(1(1)6) title(No control) xtitle(Average #glass installed last month (1 bin)) ytitle(Average #glass installed this month) name(nocontrol) nodraw
graph combine nocontrol regfit, ycommon
/*
The graph shows how an uncontrolled analysis can lead to
wrong results. In the first graph, with only a single
group (i.e.: uncontrolled), PPP does not seem to have
an effect on the average amount of glasses installed
or even have a negative effect. On the other hand, the
second graph shows how a controlled group accounting for
different "types of employees" clearly leads to the
conlcusion that PPP has a positive effect on the average
amount of glasses installed.
*/
/*****      End Part 2      *****/
