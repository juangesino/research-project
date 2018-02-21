/**** crwork.do ****/

// Clear screen.
cls
// Clear memory.
clear all
// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 1.2"

// Start Part 1

// Question 2
// Import Excel data file.
import excel "/Users/juangesino/Documents/UvA/Research Project/Lab/Ex 1.2/M3.xlsx", sheet("Monetary aggregates  - Broad Mo") cellrange(A7:AY36) firstrow case(lower)

// Question 4
// The variables are named according to the Excel column name.
// Red variables are strings and black values are numbers.
// The values in column ar are all 100 becuase 2010 is the base year.

// Question 5
// Copies all countries to b (with non OECD).
replace b = country if mi(b)
// Renames b to country, and country to a.
ren (country b) (a country)
// Removes the first column and third.
drop a c

// Question 6
// Rename all columns to m1970 - m2017 (Money Supply from 1970 to 2017)
rename (d - ay) m#, addnumber(1970)

// Question 7
// Make all variables numeric
destring m*, force replace
// Replace: Replaces the variables with the numeric value.
// Force: Forces the strings to numeric values.

// Question 8
// Remove OECD extraction comment.
drop if mi(m2010)

// Question 9
// Trim country names.
replace country = strtrim(country)
// Shorten long names.
replace country = word(country,1) if wordcount(country) > 2

// Question 10
// Merge master (money supply) data with using (GDP) data.
merge 1:1 country using work_merged

// Question 11
// Check which countries did not merge.
tab country if _merge==1
// Check which countries merged.
tab country if _merge==2
// Drop all unmerged countries.
drop if _merge==1
// Drop the _merge column.
drop _merge

// Question 12
// Restructure the data to long.
reshape long gdp cpi i m, i(country) j(year)

// Question 13
// Create growth rates.
bysort country (year): gen pi =100*(cpi-cpi[_n-1])/cpi[_n-1]
bysort country (year): gen g =100*(gdp-gdp[_n-1])/gdp[_n-1]
bysort country (year): gen mgrowth =100*(m-m[_n-1])/m[_n-1]

// Question 14
// Take the logarithm of everything.
gen lnpi = log(pi)
gen lng = log(g)
gen lnmgrowth = log(mgrowth)

// Question 15
// Compress data.
compress
// Save dataset (overwrite).
save work.dta, replace

// End Part 1

/**** graphs.do ****/

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
