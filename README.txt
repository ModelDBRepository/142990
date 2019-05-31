Reproduces data points from all figures in:
S Yarrow, E Challis and P Series,
Fisher and Shannon information in finite neural populations.
Neural Computation (in press).

Contact:
Stuart Yarrow
s.yarrow@ed.ac.uk
Institute for Adaptive and Neural Computation / Neuroinformatics DTC
School of Informatics, University of Edinburgh

Usage:

1)  This code requires the lightspeed toolbox, which can be downloaded from:
    
    http://research.microsoft.com/en-us/um/people/minka/software/lightspeed/
    
    Note that the lightspeed toolbox contains mex files that must be compiled before
    use; see the lightspeed README, and comments in install_lightspeed.m, for further
    information.

2)  Unzip yarrow2012.zip

3)  Prepare the popcode toolbox for use by running install_popcode.m - this compiles
    the cellsxfun mex file for your system. 

4)  Both the lightspeed and popcode toolbox directories must be on the Matlab path; the
    install scripts should do this for you, but this is the first thing to check if you
    have problems with functions not being recognised.

5)  To reproduce a point from a figure, run the appropriate Matlab function
    (e.g. fig1.m).  Information on the parameters for each function can be found
    using the help command (e.g. "help fig1").

6)  See figure scripts for further information on parameter values.

7)  Some of the scripts/functions will take a *long* time (maybe a couple of days) to run.

8)  Hopefully the figure functions/scripts, should serve as examples of how to use the popcode
    toolbox.  See comments in the toolbox files for additional information.  Note, however,
    that the toolbox is a work in progress and contains some unimplemented stubs and extra
    functions (not used in the figure scripts) that may contain bugs.