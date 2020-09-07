# crvFit
Curve fitting tool based on the least absolute value method and the Monte Carlo method.  
GitHub: https://github.com/YujiSODE/crvFit  
>Copyright (c) 2020 Yuji SODE \<yuji.sode@gmail.com\>  
>This software is released under the MIT License.  
>See LICENSE or http://opensource.org/licenses/mit-license.php  
______

## 1. Description
Namespace `::crvFit` has procedures to estimate curve fitting parameters.

- `::crvFit::setFunction ?formula?;`  
 	Procedure that adds a mathematical function that returns a result of _`f`_(_`x`_) defined at namespace `::crvFit`.  
 	Generated function is called `crvFit_F(x)`, which is expressed with variable `$x`, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions.  
 	- `$formula`: a formula for _`f`_(_`x`_), which is expressed with variable `$x`, parameters (in upper case only), numerical values and mathematical functions in Tcl expressions, default value is `{$A*$x+$B}`

- `::crvFit::setRange parameterName range;`  
 	Procedure that sets range of random parameters.  
 	- `$parameterName`: a name of parameter to set
 	- `$range`: a range for a random number that is expressed as "`min,max`"

- `::crvFit::setParameter parameterName value;`  
 	Procedure that sets parameter for generated function based on given values.
 	- `$parameterName`: a name of parameter to set
 	- `$value`: a numerical value

- `::crvFit::loadXY ?xyList?;`  
  Procedure that loads list of x-y data.  
 	Stored data is returned when `$xyList` is not specified.  
 	Format of x-y data is "`x,y`".
 	- `$xyList`: a list of x-y data, and every element is expressed as "`x,y`"

- `::crvFit::estimate ?n?;`  
  Procedure that estimates parameters.  
 	Returned value is named list.
 	- `$n`: sample size used for a single estimation based on the least absolute value method, default size is `100`

- `::crvFit::estimateMC N ?n?;`  
 	Procedure returns result of the least absolute value method with the Monte Carlo approximation.  
 	Returned value is named list.
 	- `$N`: a number of estimated parameter sets in order to estimate average
 	- `$n`: sample size used for a single estimation based on the least absolute value method, default size is `100`

- `::crvFit::outputLog namedList fileName;`  
 	Procedure that outputs estimation log and estimated tcl math function.  
 	Output function is called `crvFitLog_F(x)`.
 	- `$namedList`: a named list that is returned by `::crvFit::estimate ?n?;` or `::crvFit::estimateMC N ?n?;`
 	- `$fileName`: a name of file to output

## 2. Script
#### Tcl
It requires Tcl 8.6+.
#### Main script
- `crvFit.tcl`

## 3. Library list
- Sode, Y. 2018. lSum_min.tcl: https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0
- Sode, Y. 2019. nonparametricP.tcl: the MIT License; https://gist.github.com/YujiSODE/4d5d004a6e98f2d17b42940fcc97c7d6
