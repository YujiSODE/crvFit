# Change Log

## [Unreleased]
## [1.0] - 2020-09-02
## Changed
- [`crvFit.tcl`] line 529: `		set ::crvFit::D [expr {abs($y-crvFit_F($x))}];`
- [`crvFit.tcl`] lines 526-527: `		set x [expr {double([lindex $xy 0])}];`  
  `		set y [expr {double([lindex $xy 1])}];`
- [`crvFit.tcl`] lines 518-521: `	#x-y data`  
  `	set x [expr {double(0)}];`  
  `	set y [expr {double(0)}];`  
  `	#`

- [`crvFit.tcl`] line 426: `		set ::crvFit::D [expr {abs($y($i)-crvFit_F($x($i)))}];`

## Released
## [0.1 beta] - 2020-08-31
