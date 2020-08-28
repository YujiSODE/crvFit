#crvFit
#sample03.tcl
source crvFit.tcl;
namespace path ::crvFit;
#
# sample model: y = (x+1)**2 = x**2+2*x+1
set list {};
set i 0;
while {$i<30} {
	set rd [expr {rand()*100.0}];
	lappend list "$rd,[expr {$rd**2.0+2.0*$rd+1.0}]";
	incr i 1;
};
#
setFunction {$A*$x**2+$B*$x+$C};
loadXY $list;
#
setRange A "0.0,1.5";
setRange B "1.0,3.5";
setRange C "1.0,1.5";
#
estimateMC 10 1000;
