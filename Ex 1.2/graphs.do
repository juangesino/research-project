// Clear screen.
cls
// Clear memory.
clear all
// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 1.2"

// Start Part 2

// Question 16
// Use the dataset created in crwork.do
use work.dta

// Question 17
// Create scatter graph.
scatter lnpi lnmgrowth, xtitle(Money supply growth (log)) ytitle(Inflation (log))

// Question 18
// Create line graph.
line pi i year if country=="United Kingdom", lc(green red) ytitle(Per cent) xtitle(Year) legend(pos(0) bplace(ne) col(1) order(1 "Inflation rate" 2 "Nominal interest rate"))

// Question 19
// Export graph as vector image (MacOSX cannot create emf files).
graph export uk_pi_i.png, replace

// Question 20
// Trying different layouts.
set scheme economist
line pi i year if country=="United Kingdom", lc(green red) ytitle(Per cent) xtitle(Year) legend(pos(0) bplace(ne) col(1) order(1 "Inflation rate" 2 "Nominal interest rate"))
set scheme sj
line pi i year if country=="United Kingdom", lc(green red) ytitle(Per cent) xtitle(Year) legend(pos(0) bplace(ne) col(1) order(1 "Inflation rate" 2 "Nominal interest rate"))

// End Part 2
