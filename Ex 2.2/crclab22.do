cls
clear all

//change folder
cd "X:\Applied Ectrcs Prop\statalab\clab22"




use "..\clab21\upop"
compress
save upop, replace


sort id
gen rdraw = _n
merge 1:1 rdraw using "..\clab21\urdraw", nogen




compress
save upop_rdraw_20k, replace
























