#crvFit
#sample02.tcl
source crvFit.tcl;
namespace path ::crvFit;
#
set list {0,0 1,1 2,2 3,3 4,4 5,5 6,6 8,8 10,10};
#
setFunction {$A*$x};
loadXY $list;
estimateMC 100 100;
