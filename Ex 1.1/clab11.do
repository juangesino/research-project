// Clear results and commands.
cls
clear all

// Go to project directory.
cd "/Users/juangesino/Documents/UvA/Research Project/Lab"

// Start Part 1

// Question 2
// Import Excel data file.
import excel "/Users/juangesino/Documents/UvA/Research Project/Lab/rpclab11_data_gt.xlsx", sheet("Sheet1") firstrow

// Question 3
// Browse the imported data.
browse

// Question 4
// Run the describe data command.
desc
/* 
We do not see informative value-or variable-labels because the 
data were imported from excel which only contains a column header. 
Most data come with a codebook. This case we use knowledge of the 
context.
*/

// Question 5
// Apply descriptive labels to variables imported.
label var cito "primary school exam score"
label var vwo "academic high school"
// Run the describe data again.
desc
/*
'cito' and 'vwo' are the names used in the data file to represent 
'primary school exam score' and 'academic high school' respectevely.

Primary school exam score: The score students obtained in the primary
school exam.

Academic high school: Binary variable that determines if the student
passed the academic high school.
*/

// Question 6
tab treat eligible
tab eli z if treat==0
tab eli z if treat==1
/*
treat: Determines if the student can be eligible for GT.
z: Determines if the student 
eligible: If the student is eligible for GT.
gt: Gifted program.
*/

// Question 7
// Get statistics summary.
sum
/*
Do you spot outliers or strange looking values?
Values for id, year and grade seem strange, but this is due to the 
fact that these variables are nominal.
There seems to be outliers in cito.

Are the schools equally represented?
No, schools don't seem to be equally represented. The mean values are
different for each one of these.

And what about men and academic high school?
Male students are somehow equally represented, although there seems
to be more non-male students in the data.
The same logic applies to VWO or academic high school, the mean value
is 0.45.
*/

// Question 8
// Remove the id and grade columns
drop id grade
/* We can do this because the student ID are irrelevant for 
statistical analysis and the sample students were all 3rd graders.
*/

// Question 9
tabstat *,s(mean sd min max) columns(s)format(%6.2f)

// Question 10
tabstat school* year vwo male age cito gpabaseline if treat==1,by(eli)f(%6.2f)
/*
The mean values for both eligible and non-eligible students seem to
be quite similiar so they can be comparable.
*/

// Question 11
tabstat gpa*_raw if treat==1,by(eli)f(%6.2f)
/*
Eligible students seem to perform better than non-eligible student.
There is no way of determining if this is due to the GT program or 
not.
*/

// End Part 1

// Start Part 2

// Question 12
// Graph boxplot for male.
graph hbox male
// All the observations are between 1 and 0 (either male or not male).
// Graph boxplot for age.
graph hbox age
// Small IQR with some outliers.
// Graph boxplot for cito.
graph hbox cito
// A few lower bound outliers.
// Graph boxplot for gpabaseline.
graph hbox gpabaseline
// We can see outliers for the lower and higher bound.
// Graph boxplot for gpa_raw.
graph hbox gpa_raw
// Plenty of lower and upper outliers with a small IQR

// Question 13
// Graph histogram for male.
hist male
// Again, all the observations are between 1 and 0.
// Graph histogram for age.
hist age
// We see a higher density between the age of 14 and 15.
// Graph histogram for cito.
hist cito
// Density getting higher as we approach the value of 550.
// Graph histogram for gpabaseline.
hist gpabaseline
// Bell shape density centered around -1.
// Graph histogram for gpa_raw.
hist gpa_raw
// Bell shape density centered around 6.5.

// Question 14
scatter gpa_raw cito
/*
There seems to be a small positive correlation, with GPA increasing 
as primary school exam score increases.
*/

// Question 15
twoway (scatter gpa_raw cito) (lfit gpa_raw cito, lc(red)), legend(off) name(cito)
// The fitted line confirms the answer to question 13.

// Question 16
twoway (scatter gpa_raw gpabaseline) (lfit gpa_raw gpabaseline, lc(red)), legend(off) name(gpab)
// In this graph the correlation seems to be stronger (also positive).

// Question 17
graph combine gpab cito
// As stated in Q15, the correlations seems stronger with gpabaseline.

// Question 18
generate gpa_raw0 = gpa_raw if treat==0
gen gpa_raw1 = gpa_raw if treat==1
scatter gpa_raw0 gpa_raw1 gpabaseline if z==1, mc(blue red) legend(order(2 "GT child (eligible)" 1 "Control class"))
graph export gpa_base_scetter.pdf, replace
/*
There seems to be better grades for the GT children than the control
group.
*/

// End Part 2
