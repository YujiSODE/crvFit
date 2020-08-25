#crvFit
#crvFit.tcl
##===================================================================
#	Copyright (c) 2020 Yuji SODE <yuji.sode@gmail.com>
#
#	This software is released under the MIT License.
#	See LICENSE or http://opensource.org/licenses/mit-license.php
##===================================================================
#Curve fitting tool based on the least absolute value method and the Monte Carlo method
#
#=== Synopsis ===
# - `::crvFit::rand range;`
#	procedure that returns a random number in range [min,max]
# 	- $range: range for a random number expressed as "min,max"
#
# - `::crvFit::setFunction ?formula?;`
# 	procedure that adds a mathematical function that returns a result of f($x) defined at namespace `::crvFit`  
# 	generated function is called `crvFit_F(x)`, which is expressed with variable $x, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions
# 	- $formula: a formula for f($x), which is expressed with variable $x, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions, default value is {$A*$x+$B}
#
# - `::crvFit::setRandomParameters;`
# 	procedure that sets random parameters for generated function (`crvFit_F($x)`) based on given ranges
#
# - `::crvFit::setRange parameterName range;`
# 	procedure that sets range of random parameters
# 	- $parameterName: a name of parameter to set
# 	- $range: a range for a random number that is expressed as "min,max"
#
# - `::crvFit::setParameter parameterName value;`
# 	procedure that sets parameter for generated function (`crvFit_F($x)`) based on given values
# 	- $parameterName: a name of parameter to set
# 	- $value: a numerical value
#
# - `::crvFit::loadXY ?xyList?;`
# 	procedure that loads list of x-y data  
# 	stored data is returned when $xyList is not specified  
# 	format of x-y data is "x,y"
# 	- $xyList: a list of x-y data, and every element is expressed as "x,y"
#
# - `::crvFit::estimate ?n?;`
#	procedure that estimates parameters
# 	- $n: sample size used for a single estimation based on the least absolute value method, default size is 100
#--------------------------------------------------------------------
#
#*** <namespace ::tcl::mathfunc> ***
#additional math function
#
#--- lSum.tcl (Yuji SODE, 2018): https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0 ---
# - `lSum(list)`: function that returns sum of given list
# 	- `$list`: a numerical list
#--------------------------------------------------------------------
#
#*** <namespace ::tcl::mathfunc> ***
#additional math functions
#
#--- nonparametricP.tcl/avg (Yuji SODE, 2019); the MIT License: https://gist.github.com/YujiSODE/4d5d004a6e98f2d17b42940fcc97c7d6 ---
# - `avg(list)`: function that estimates average using a given numerical list
# 	- `$list`: a numerical list
#
#--- nonparametricP.tcl/var (Yuji SODE, 2019); the MIT License: https://gist.github.com/YujiSODE/4d5d004a6e98f2d17b42940fcc97c7d6 ---
# - `var(list,?m?)`: function that estimates variance using a numerical list (and an optional mean) with "list size -1"
# 	- `$list`: a numerical list
# 	- `$m`: an optional mean value
#--------------------------------------------------------------------
#
#*** <namespace ::tcl::mathfunc> ***
#additional math functions
#
# - `lAvg(namedList)`: it returns a named list of averages based on two-dimensional named list
# 	- $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
#
# - `lSE(namedList,meanList)`: it returns a named list of standard errors based on two-dimensional named list and a named list of means
# 	- $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
# 	- $meanList: a named list with form like "name meanValue name meanValue ... name meanValue"
#
# - `lSE95(namedList,meanList)`: it returns a named list of 1.96*(standard errors) based on two-dimensional named list and a named list of means
# 	- $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
# 	- $meanList: a named list with form like "name meanValue name meanValue ... name meanValue"
##===================================================================
#
set auto_noexec 1;
package require Tcl 8.6;
#--------------------------------------------------------------------
#
#additional math function
#*** <namespace ::tcl::mathfunc> ***
#=== lSum.tcl (Yuji SODE, 2018): https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0 ===
#Additional mathematical function for Tcl expressions
# [References]
# - Iri, M., and Fujino., Y. 1985. Suchi keisan no joshiki (in Japanese). Kyoritsu Shuppan Co., Ltd.; ISBN 978-4-320-01343-8
proc ::tcl::mathfunc::lSum {list} {namespace path {::tcl::mathop};set S 0.0;set R 0.0;set T 0.0;foreach e $list {set R [+ $R [expr double($e)]];set T $S;set S [+ $S $R];set T [+ $S [expr {-$T}]];set R [+ $R [expr {-$T}]];};return $S;};
#--------------------------------------------------------------------
#
#additional math functions
#*** <namespace ::tcl::mathfunc> ***
#=== nonparametricP.tcl/avg (Yuji SODE, 2019); the MIT License: https://gist.github.com/YujiSODE/4d5d004a6e98f2d17b42940fcc97c7d6 ===
#it estimates average using a given numerical list
proc ::tcl::mathfunc::avg {list} {
	# - $list: a numerical list
	set v {};
	#n is list size
	set n [expr {double([llength $list])}];
	foreach e $list {
		lappend v [expr {double($e)}];
	};
	return [expr {lSum($v)/$n}];
};
#
#=== nonparametricP.tcl/var (Yuji SODE, 2019); the MIT License: https://gist.github.com/YujiSODE/4d5d004a6e98f2d17b42940fcc97c7d6 ===
#it estimates variance using a numerical list (and an optional mean) with "list size -1"
proc ::tcl::mathfunc::var {list {m {}}} {
	# - $list: a numerical list
	# - $m: an optional mean value
	set v {};
	#n is list size
	set n [expr {double([llength $list])}];
	#m is average of list
	set m [expr {[llength $m]>0?double($m):avg($list)}];
	foreach e $list {
		lappend v [expr {(double($e)-$m)**2}];
	};
	unset m;
	return [expr {lSum($v)/($n-1)}];
};
#--------------------------------------------------------------------
#
#additional math functions
#*** <namespace ::tcl::mathfunc> ***
#it returns a named list of averages based on two-dimensional named list
proc ::tcl::mathfunc::lAvg {namedList} {
	# - $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
	#list sizes
	set w [llength [lindex $namedList 0]];
	set h [llength $namedList];
	#list to return
	set L {};
	#
	set i 0;
	set j 0;
	while {$i<$w} {
		#name
		lappend L [lindex $namedList 0 $i];
		#values
		set vList {};
		set j 0;
		while {$j<$h} {
			lappend vList [lindex $namedList $j [expr {$i+1}]];
			incr j 1;
		};
		lappend L [format %e [expr {avg($vList)}]];
		incr i 2;
	};
	unset w h i j vList;
	return $L
};
#
#it returns a named list of standard errors based on two-dimensional named list and a named list of means
proc ::tcl::mathfunc::lSE {namedList meanList} {
	# - $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
	# - $meanList: a named list with form like "name meanValue name meanValue ... name meanValue"
	#list sizes
	set w [llength [lindex $namedList 0]];
	set h [llength $namedList];
	#list to return
	set L {};
	#
	set i 0;
	set j 0;
	#mean value
	set m [expr {double(0)}];
	#number of mean values
	set n [expr {double(0)}];
	while {$i<$w} {
		#name
		lappend L [lindex $namedList 0 $i];
		#values
		set m [lindex $meanList [expr {$i+1}]];
		set vList {};
		set j 0;
		while {$j<$h} {
			lappend vList [lindex $namedList $j [expr {$i+1}]];
			incr j 1;
		};
		set n [expr {double([llength $vList])}];
		lappend L [format %e [expr {sqrt(var($vList,$m)/$n)}]];
		incr i 2;
	};
	unset w h i j m n vList;
	return $L
};
#
#it returns a named list of 1.96*(standard errors) based on two-dimensional named list and a named list of means
proc ::tcl::mathfunc::lSE95 {namedList meanList} {
	# - $namedList: a two-dimensional named list, which is composed of lists with form like "name value name value ... name value"
	# - $meanList: a named list with form like "name meanValue name meanValue ... name meanValue"
	#list sizes
	set w [llength [lindex $namedList 0]];
	set h [llength $namedList];
	#list to return
	set L {};
	#
	set i 0;
	set j 0;
	#mean value
	set m [expr {double(0)}];
	#number of mean values
	set n [expr {double(0)}];
	while {$i<$w} {
		#name
		lappend L [lindex $namedList 0 $i];
		#values
		set m [lindex $meanList [expr {$i+1}]];
		set vList {};
		set j 0;
		while {$j<$h} {
			lappend vList [lindex $namedList $j [expr {$i+1}]];
			incr j 1;
		};
		set n [expr {double([llength $vList])}];
		lappend L [format %e [expr {1.96*sqrt(var($vList,$m)/$n)}]];
		incr i 2;
	};
	unset w h i j m n vList;
	return $L
};
#--------------------------------------------------------------------
#
#*** <namespace: ::crvFit> ***
namespace eval ::crvFit {
	#=== variables ===
	#
	#formula to evaluate
	variable FORMULA {};
	#
	#parameters
	variable PRM;
	array set PRM {};
	#
	#ranges of random number for parameters
	variable RANGE;
	array set RANGE {};
	#
	#a list of x-y data
	variable DATA {};
	#
	#--- variable for estimation ---
	#the sum of abs(y-f(x))
	variable D [expr {double(0)}];
};
#
#=== procedures ===
#
#procedure that returns a random number in range [min,max]
proc ::crvFit::rand {range} {
	# - $range: a range for a random number that is expressed as "min,max"
	#
	#rand() in tcl math functions returns in range (0,1)
	set r [split $range ,];
	set r0 [expr {double([lindex $r 0])}];
	set r1 [expr {double([lindex $r 1])}];
	if {$r1<$r0} {
		set r0 [expr {double([lindex $r 1])}];
		set r1 [expr {double([lindex $r 0])}];
	};
	set rnd [expr {$r0+rand()*($r1+0.1)-0.1}];
	while {$rnd<$r0||$r1<$rnd} {
		set rnd [expr {$r0+rand()*($r1+0.1)-0.1}];
	};
	unset r r0 r1;
	return [format %e $rnd];
};
#
#procedure that adds a mathematical function that returns a result of f($x) defined at namespace `::crvFit`
#generated function is called `crvFit_F(x)`, which is expressed with variable $x, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions
proc ::crvFit::setFunction {{formula {$A*$x+$B}}} {
	# - $formula: a formula for f($x), which is expressed with variable $x, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions  
	#   default value of $formula is {$A*$x+$B}
	#
	variable ::crvFit::FORMULA;variable ::crvFit::PRM;variable ::crvFit::RANGE;
	#
	#setting formula
	set ::crvFit::FORMULA $formula;
	#
	#setting initial parameters and their ranges
	array unset ::crvFit::PRM;
	array unset ::crvFit::RANGE;
	array set ::crvFit::PRM {};
	array set ::crvFit::RANGE {};
	foreach e [regexp -all -inline {\$[A-Z]+} $formula] {
		set ::crvFit::PRM([string map {\$ {}} $e]) 0.0;
		set ::crvFit::RANGE([string map {\$ {}} $e]) "0.0,1.0";
	};
	#
	#adding mathematical function for Tcl expressions
	#generated function is called `crvFit_F(x)`
	#
	#mathematical function that returns a result of f($x) defined at namespace `::crvFit`
	proc ::tcl::mathfunc::crvFit_F {x} {
		#mathematical function that returns a result of f($x) defined at namespace `::crvFit`
		# - $x: a numerical value
		#
		variable ::crvFit::FORMULA;variable ::crvFit::PRM;
		#
		set x [expr {double($x)}];
		foreach e [lsort -unique [array names ::crvFit::PRM]] {
			set $e $::crvFit::PRM($e);
		};
		return [expr $::crvFit::FORMULA];
	};
	#
	return $formula;
};
#
#procedure that sets random parameters for generated function (`crvFit_F($x)`) based on given ranges
proc ::crvFit::setRandomParameters {} {
	variable ::crvFit::PRM;variable ::crvFit::RANGE;
	#
	set info {};
	foreach e [lsort -unique [array names ::crvFit::PRM]] {
		set ::crvFit::PRM($e) [::crvFit::rand $::crvFit::RANGE($e)]
		lappend info "$e:$::crvFit::PRM($e)";
	};
	return $info;
};
#
#procedure that sets range of random parameters
proc ::crvFit::setRange {parameterName range} {
	# - $parameterName: a name of parameter to set
	# - $range: a range for a random number that is expressed as "min,max"
	#
	variable ::crvFit::RANGE;
	#
	set ::crvFit::RANGE($parameterName) $range;
	return "RANGE($parameterName):$range";
};
#
#procedure that sets parameter for generated function (`crvFit_F($x)`) based on given values
proc ::crvFit::setParameter {parameterName value} {
	# - $parameterName: a name of parameter to set
	# - $value: a numerical value
	variable ::crvFit::PRM;
	#
	set ::crvFit::PRM($parameterName) $value;
	#
	return "$parameterName:$value";
};
#
#procedure that loads list of x-y data
#x-y data format: "x,y"
#stored data is returned when $xyList is not specified
proc ::crvFit::loadXY {{xyList {}}} {
	# - $xyList: a list of x-y data, and every element is expressed as "x,y"
	#
	variable ::crvFit::DATA;
	#
	#stored data is returned when $xyList is not specified
	if {[llength $xyList]<1} {
		return $::crvFit::DATA;
	};
	foreach e $xyList {
		lappend ::crvFit::DATA $e;
	};
	#
	return $xyList;
};
#
#procedure that estimates parameters
proc ::crvFit::estimate {{n 100}} {
	# - $n: sample size used for a single estimation based on the least absolute value method, default size is 100
	#
	variable ::crvFit::FORMULA;variable ::crvFit::PRM;
	#
	#error is returned when $::crvFit::FORMULA is not defined
	if {[llength $::crvFit::FORMULA]<1} {error "ERROR: formula is not defined"};
	#error is returned when $::crvFit::DATA is not defined
	if {[llength [::crvFit::loadXY]]<1} {error "ERROR: x-y data is not defined"};
	#
	#$n is not less than 10
	set n [expr {$n<10?10:int($n)}];
	#
	#a list of estimated parameters
	set results {};
	#
	#$d is the sum of abs(y-f(x))
	set d [expr {double(0)}];
	set ::crvFit::D [expr {double(0)}];
	#
	set nameList [lsort -unique [array names ::crvFit::PRM]];
	#
	#--- 0th simulation ---
	::crvFit::setRandomParameters;
	#array for parameters
	array set vars {};
	foreach e $nameList {
		set vars($e) $::crvFit::PRM($e);
	};
	#
	set xys [::crvFit::loadXY];
	#$Nxy is data length
	set Nxy [llength $xys];
	#x-y data as an array
	array set x {};
	array set y {};
	set i 0;
	while {$i<$Nxy} {
		set xy [split [lindex $xys $i] ,]
		set x($i) [expr {double([lindex $xy 0])}];
		set y($i) [expr {double([lindex $xy 1])}];
		#
		set ::crvFit::D [expr {$::crvFit::D+abs($y($i)-crvFit_F($x($i)))}];
		incr i 1;
	};
	set d $::crvFit::D;
	#
	#--- [simulations from 1st to (n-1)th] ---
	set j 1;
	while {$j<$n-1} {
		::crvFit::setRandomParameters;
		set ::crvFit::D [expr {double(0)}];
		#
		set i 0;
		while {$i<$Nxy} {
			set ::crvFit::D [expr {$::crvFit::D+abs($y($i)-crvFit_F($x($i)))}];
			incr i 1;
		};
		#replacing values only when the new value of `abs(y-f(x))` is less than another
		if {$::crvFit::D<$d} {
			foreach e $nameList {
				set vars($e) $::crvFit::PRM($e);
			};
			set d $::crvFit::D;
		};
		incr j 1;
	};
	#
	set results [array get vars];
	lappend results d_abs;
	lappend results $d;
	#
	unset d nameList vars xys Nxy i j x y;
	#
	return $results;
};
#
#procedure: result of the least absolute value method with the Monte Carlo approximation
proc ::crvFit::estimateMC {N {n 100}} {
	# - $N: a number of estimated parameter sets in order to estimate average
	# - $n: sample size used for a single estimation based on the least absolute value method, default size is 100
	#
	variable ::crvFit::FORMULA;variable ::crvFit::PRM;variable ::crvFit::D;
	#
	#$N and $n are not less than 10
	set N [expr {$N<10?10:int($N)}];
	set n [expr {$n<10?10:int($n)}];
	#
	#$R is a result array
	array set R {};
	#
	#variables for Monte Carlo approximation
	set l {};
	set avg {};
	set i 0;
	#
	while {$i<$N} {
		lappend l [::crvFit::estimate $n];
		incr i 1;
	};
	set avg [expr {lAvg($l)}];
	set SE [expr {lSE($l,$avg)}];
	set SE95 [expr {lSE95($l,$avg)}];
	###
		puts stdout "formula:$::crvFit::FORMULA";
		puts stdout "number of data sets:$N";
		puts stdout "sample size of a single estimation:$n";
		puts stdout "avg:$avg";
		puts stdout "SEr:$SE";
		puts stdout "S95:$SE95";
	###
	#--- estimated curve function ---
	array set R $avg;
	foreach e [lsort -unique [array names R]] {
		::crvFit::setParameter $e $R($e);
	};
	unset ::crvFit::PRM(d_abs);
	unset R(d_abs);
	#
	set xys [::crvFit::loadXY];
	#$Nxy is data length
	set Nxy [llength $xys];
	#x-y data as an array
	array set x {};
	array set y {};
	set ::crvFit::D [expr {double(0)}];
	set i 0;
	while {$i<$Nxy} {
		set xy [split [lindex $xys $i] ,]
		set x($i) [expr {double([lindex $xy 0])}];
		set y($i) [expr {double([lindex $xy 1])}];
		#
		set ::crvFit::D [expr {$::crvFit::D+abs($y($i)-crvFit_F($x($i)))}];
		incr i 1;
	};
	#
	unset l avg i SE SE95 xys Nxy x y;
	return "[array get R] d_abs [format %e $::crvFit::D]";
};
