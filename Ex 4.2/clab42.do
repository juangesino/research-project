/*****      Start Part 0      *****/
// Clear screen.
cls
// Clear memory.
clear all
// Change directory to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 4.2"
/*****      End Part 0      *****/


/*****      Start Part 1      *****/
// Question 1
use sp500desc2018.dta
br
desc
tab gicssector
// Question 2
import excel "sp500_2014.xls", firstrow case(lower) clear
br
import excel "sp500_2015.xls", firstrow case(lower) clear
br
// Question 3
append using sp500_2014
sort tickersymbol year
br
// Question 4
gen R = (close - open)/open
hist R
tabstat R, by(year) s(mean sd)
/*
In average, it seems that 2014 was a better year for
investors.
*/
// Question 5
merge m:1 tickersymbol using sp500desc2018.dta
tab _merge year, m
drop if _merge==2
gen msmpl = (_merge==3)
/*
We could not math all records because there are some stocks
for wich we have open/close values but no description
(_merge==1) and some other for which we have a description
but no open/close values (_merge==2).
We drop _merge==2 because these are records for which we
have a description but no open/close values.
*/
// Question 6
bys tickersymbol: gen bsmpl=(_N==2)
/*****      End Part 1      *****/


/*****      Start Part 2      *****/
// Question 7
tab gicssector
gen util = (gicssector=="Utilities")
gen energy = (gicssector=="Energy")
// Question 8
gen G = (util | energy)
gen D = (year==2015)
gen X = G*D
/*
The first command generates a new varaible G and sets it
to 0 if the stock doesn't belong to either an Energy or
Utilities company and 1 if the firm does belong to an
Energy or Utilities company.
The second command generates a new variable D that is set
to 0 if the data belongs to 2014 and 1 if it belongs to the
year 2015.
Lastly, the last command generates a variable X which is
equal to the multiplication of G and D. In this way, X will
be equal to 1 if the company belongs to the Energy or
Utilities sectors and the data is from 2015.
*/
// Question 9
eststo did: reg R X G D, cluster(tickersymbol)
/*
The coefficients represent the effect each variable has
on returns. X is the effect the combination of year 2015
and being a utility/energy company has on returns.
G is the effect the type of company (utility/energy or
non-utility/energy) has on returns. D is the effect the
year has on the returns.
The Beta for the company being a utility/energy company
is significantly different from the rest.
*/
// Question 10
predict Rcfact
replace Rcfact = Rcfact - _b[X]*X
twoway (lfit R D if G==0, lc(blue)) (lfit R D if G==1, lc(black)) (line Rcfact D if G==1, lp(dash) lc(black) sort), xlabel(0 `""Before" "(2014)""' 1 `""After" "(2015)""') legend(order(1 "non-Energy" 2 "Energy" 3 "Energy if same cyclicality")) ytitle(R) xtitle("")
/*
The graph shows the change in returns from year 2014 to year
2015. This is shown for both non-Energy companies and Energy
companies. The dotted line show what the decline should
look like for Energy companies if they had the same
cyclicality as the rest of the companies.
*/
// Question 11
qui eststo didb: reg R X G D if bsmpl, cluster(tickersymbol)
qui eststo didbm: reg R X G D if bsmpl & msmpl, cluster(tickersymbol)
esttab did didb didbm, b(a2) se nogap star(* 0.10 ** 0.05 *** 0.01)
/*
No, the conclusion is still that the effect is significant.
*/
// Question 12
nlcom _b[X]/_b[D]
/*
The conclusion is that Utility/Energy companies are more
cyclical than the rest of the companies by 0.58. However,
this effect is not significant.
*/
/*****      End Part 2      *****/
