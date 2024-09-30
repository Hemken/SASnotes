** 
---
title: "SAS Macros - Progams and functions"
author: "Doug Hemken"
output: html_document
---
## Macros
Macros as programs or functions;

*R require(SASmarkdown)
sas_collectcode();

*+ sassetup, engine="sas",
    engine.path="C:/Program Files/SASHome/SASFoundation/9.4/sas.exe",
    engine.opts="-nosplash -ls 75",
	error=TRUE, collectcode=TRUE, comment=NA;

libname y ".";
libname library (y);

title;

options symbolgen mprint=on;
*options nosymbolgen mprint=off;
%let dsn = y.nlswages;
%let varlist = R0043600 R0107300 R0174800 R0257500 R0303200 R0323900 
	R0407200 R0477200 R0511200 R0623800 R0703400 R0759400 R0856900 
	R0967600 R3388500 R4153500 R5111700 R6204300 R7312300;


** Define the macro ;

*+ mdefine, engine="sas",
    engine.path="C:/Program Files/SASHome/SASFoundation/9.4/sas.exe",
    engine.opts="-nosplash -ls 75",
	error=TRUE, collectcode=TRUE, comment=NA;

%macro meancorr;  
	proc means data=&dsn n mean std stderr lclm uclm;
		var &varlist;
		run;

	proc corr data=&dsn nosimple;
		var &varlist;
		run;
%mend meancorr;

 ** Then use, or "call", the macro;

*+ mcall, engine="sas",
    engine.path="C:/Program Files/SASHome/SASFoundation/9.4/sas.exe",
    engine.opts="-nosplash -ls 75",
	error=TRUE, comment=NA;

%meancorr;

** If the preceding example doesn't seem much different than
	using a macro variable - just text substitution - well,
	it isn't much different.

	However, we are going to be able to do a lot more.;


** ##Doing a little more
Adding a loop to repeat our procs by subset;

*+ mdefine2, engine="sas",
    engine.path="C:/Program Files/SASHome/SASFoundation/9.4/sas.exe",
    engine.opts="-nosplash -ls 75",
	error=TRUE, comment=NA;

%macro meancorrbymstatus;
%do i = 1 %to 6;
	proc means data=&dsn(where=(R0002400=&i)) 
		n mean std stderr lclm uclm;
		var &varlist;
		run;

	proc corr data=&dsn(where=(R0002400=&i)) nosimple;
		var &varlist;
		run;
%end;
%mend meancorrbymstatus;

%meancorrbymstatus;


** A macro need not contain any macro variables, nor does it
	need to produce an executable block of SAS code;

*+ mdefine3, engine="sas",
    engine.path="C:/Program Files/SASHome/SASFoundation/9.4/sas.exe",
    engine.opts="-nosplash -ls 75",
	error=TRUE, comment=NA;

%macro fragment;
 	R7312300; 
	run;
%mend;

proc freq data=&dsn;
	tables %fragment;

** This also looks like just a macro variable, but can be 
	extended to be more powerful.
	;
