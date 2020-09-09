# Change Log

## [Unreleased]

## [1.1] - 2020-09-09
## Added
- [`varCSV.tcl`]: added a procedure that returns a result of csv structure scan `::varCSV::scan`

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

## Released
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

## Released
## [0.1 beta] - 2020-08-31
