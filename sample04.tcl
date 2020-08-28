#crvFit
#sample04.tcl
source crvFit.tcl;
namespace path ::crvFit;
#
# sample model: y = (x+1)**2 = x**2+2*x+1
set list {};
set i 0;
while {$i<30} {
	set rd [expr {rand()*100.0}];
	lappend list "$rd,[expr {($rd+1.0)**2}]";
	incr i 1;
};
#
setFunction {($x+$A)**$B};
loadXY $list;
#
setRange A "0.8,1.2";
setRange B "1.8,2.2";
#
estimateMC 10 1000;
