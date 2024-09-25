/* Saving Graphics */

/*
Graphics show up as part of your default output,
in the Results Viewer.  Although SAS is actually
creating files on the server/your computer as you add to your 
results, these are effectively hidden from you in
a temporary folder within C:\temp\SAS Temporary Files\.
The name of this folder changes each time you start
a SAS session, and your graphics are erased when you
exit SAS.  Rather than struggle with moving files around
by hand, or trying to copy-and-paste, your best 
strategy is to learn to save graphics
in the location and format you desire, automatically.

Format
Your choice of file format will depend on how you intend
to use the graphic.  Common choices are rtf (for use in 
Word documents), pdf, or png (as a separate graphics file).
These correspond to the ODS RTF, ODS PDF, and ODS HTML destinations,
respectively.

Location
You either specify a file name, or a folder, depending on
the format you choose.

Examples below
*/

/* James Forbes' Altimeter (1857)
	Bringing water to a boil throughout the Alps */

data forbes;
	input id boil pressure;
	label boil = "Boiling Point (degrees F)"
		pressure = "Air Pressure (inches Hg)";
	datalines;
    1   194.5   20.79
    2   194.3   20.79
    3   197.9   22.40
    4   198.4   22.67
    5   199.4   23.15
    6   199.9   23.35
    7   200.9   23.89
    8   201.1   23.99
    9   201.4   24.02
   10   201.3   24.01
   11   203.6   25.14
   12   204.6   26.57
   13   209.5   28.49
   14   208.6   27.76
   15   210.7   29.04
   16   211.9   29.88
   17   212.2   30.06
;

/* Titles affect all forms of output */
title "Boiling Point and Altitude";
title2 "James D. Forbes, 1857";

/* RTF output, for MS Word documents */
ods rtf file="u:\graphics example.rtf";

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

ods rtf close;

/* PDF output, for Acrobat documents */
ods pdf file="u:\graphics example.pdf";

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

ods pdf close;

/* PNG output, for a variety of uses */
ods html gpath="u:\";

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

* No need to close the HTML destination;

/* As a final note, remember that you could
	save output from a single PROC to more
	than one output destination, simultaneously.
	We could have done all three like this:
*/

ods rtf file="u:\graphics example.rtf";
ods pdf file="u:\graphics example.pdf";
ods html gpath="u:\";

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

ods rtf close;
ods pdf close;

/* Exercises
(1) Saving multiple graphs
Use the sashelp.class data to draw
scatterplots of weight by age and
weight by height.  Save these in
all three formats discussed here.
(2) JPG files
Look up the ODS HTML command, and
find the DEVICE option 
(Base SAS - Output Delivery System User's Guide - ODS Statements).
Save files
from exercise (1) in jpg or jpeg format.
*/

* (1) ;
title;
ods rtf file="u:\graphics example.rtf";
ods pdf file="u:\graphics example.pdf";
ods html gpath="u:\";

proc sgplot data=sashelp.class;
	scatter y=weight x=age;
proc sgplot data=sashelp.class;
	scatter y=weight x=height;
run;

ods rtf close;
ods pdf close;

ods html gpath="u:\" device=gif;

* (2) ;
proc sgplot data=sashelp.class;
	scatter y=weight x=age;
proc sgplot data=sashelp.class;
	scatter y=weight x=height;
run;
