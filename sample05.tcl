#crvFit
#sample05.tcl
source crvFit.tcl;
namespace path ::crvFit;
#
source varCSV.tcl;
#
#sample model: y = f(x) = 10*x+30
#
#CSV data 
set X [::varCSV::getColumn csvSample.csv 0 1 utf-8];
set Y [::varCSV::getColumn csvSample.csv 1 1 utf-8];
loadXY [::varCSV::lJoin $X $Y ,];
#
setFunction {$x*$A+$B};
#
setRange A "5.0,15.0";
setRange B "15.0,35.0";
#
estimateMC 100 1000;
