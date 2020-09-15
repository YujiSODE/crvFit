# Change Log

## [Unreleased]

## Released: [2.0] - 2020-09-16
## [2.0] - 2020-09-15
## Fixed
range of random numbers
- [`crvFit.tcl`] line 293: ` 		set rnd [expr {$r0+rand()*($r1-$r0+$::crvFit::EPS)-$::crvFit::EPS}];`
- [`crvFit.tcl`] line 291: ` 	set rnd [expr {$r0+rand()*($r1-$r0+$::crvFit::EPS)-$::crvFit::EPS}];`
- [`crvFit.tcl`] lines 282-286:

     	#$r0 = $r1
    	if {!($r0!=$r1)} {
    		return [format %e $r0];
    	};
    	#$r0 != $r1

- [`crvFit.tcl`] line 278: ` 	variable ::crvFit::EPS;`

- [`crvFit.tcl`] lines 264-268:

    	#=== epsilon ===
    	variable EPS 1.0;
    	while {1.0+$EPS!=1.0} {
    		set EPS [expr {$EPS/2.0}];
	    };

## Released: [1.1] - 2020-09-12
## [1.1] - 2020-09-12
## Added
- [`README.md`]: description of **`Sample script and sample data`**

## [1.1] - 2020-09-10
## Added
- [`csvSample.csv`]: sample CSV data
- [`sample05.tcl`]: code sample which uses CSV file data via `varCSV.tcl`

## [1.1] - 2020-09-09
## Added
- [`varCSV.tcl`]: added a procedure `::varCSV::scan fileName ?encoding?;`  
  `::varCSV::scan` is procedure that returns a result of CSV structure scan

## [1.1] - 2020-09-08
## Added
- [`varCSV.tcl`]: added a procedure `::varCSV::getSize fileName ?encoding?;`  
  `::varCSV::getSize` is procedure that returns the maximum size of CSV file

## Changed
- [`varCSV.tcl`]: added namespace `::varCSV`

## [1.1] - 2020-09-07
## Changed
- [`README.md`] lines 53-56:

      #### Main script
      - `crvFit.tcl`
      #### Additional script
      - `varCSV.tcl`: CSV file dealing interface

## Added
- [`varCSV.tcl`]: CSV file dealing interface

## Released: [1.0] - 2020-09-05
## [1.0] - 2020-09-02
## Changed
- [`crvFit.tcl`] line 529: `		set ::crvFit::D [expr {abs($y-crvFit_F($x))}];`
- [`crvFit.tcl`] lines 526-527:

      		set x [expr {double([lindex $xy 0])}];
      		set y [expr {double([lindex $xy 1])}];
  
- [`crvFit.tcl`] lines 518-521:

      	#x-y data
      	set x [expr {double(0)}];
      	set y [expr {double(0)}];
      	#
      
- [`crvFit.tcl`] line 426: `		set ::crvFit::D [expr {abs($y($i)-crvFit_F($x($i)))}];`

## Released: [0.1 beta] - 2020-08-31
## [0.1 beta] - 2020-08-31
