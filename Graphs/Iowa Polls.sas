data Iowapolls;
	infile "Z:\PUBLIC_web\Stataworkshops\Grammar of Graphics\Iowa Huffingtonpost.csv" 
		firstobs=2 dsd dlm=",";
	input Pollster :$46. Dates :$16. Pop $ Ernst Braley Undecided Spread :$10;
	LV = (index(pop, "LV") gt 0);
	if LV; *Just use "likely voter" polls, not "registered voters";
	polldate = input(trim(substr(dates, index(dates, "-")+2))||"/2014", mmddyy10.);
	format polldate mmddyy8.;
	margin = Ernst - Braley;
run;

proc sort;
	by polldate;
	run;

data Iowapolls2;
	set Iowapolls;
	retain w1 - w51 m1-m51;
	array w {51};
	array m {51};
	w{_n_} = polldate;
	m{_n_} = margin;
	do i = 1 to _n_;
		if w{i}+21 lt polldate then do;
			w{i}=.;
			m{i}=.;
			end;
		end;
	trailing21 = mean(of m1-m51);
	do i = 1 to 51;
		if w{i} ne . then lastdate = w{i};
		end;
	format lastdate mmddyy8.;
	drop w1 -- i;
	run;

data trailing;
	set Iowapolls2;
	keep trailing21 lastdate;
	by lastdate;
	if last.lastdate;
	run;

data Polls;
	merge Iowapolls trailing(rename=(lastdate=polldate));
	by polldate;
	trailing = lag(trailing21);
	lmoe = trailing - 3.5;
	umoe = trailing + 3.5;
	if polldate gt "01Sep2014"d;
	run;

/*
proc sgplot;
	scatter x=polldate y=margin;
	run;

proc sgplot;
	series x=polldate y=trailing;
	run;

proc sgplot;
	band x=polldate upper=umoe lower=lmoe;
	run;
*/
proc sgplot;
	band x=polldate upper=umoe lower=lmoe;
	series x=polldate y=trailing;
	scatter x=polldate y=margin;
	run;

proc format;
	value margin -10 = "Braley +10"
				-5 = "Braley +5"
				5 = "Ernst + 5"
				10 = "Ernst + 10";
	run;

title "Iowa Senate Polls Coverged";
title2 "(But Badly Missed the Outcome)";
footnote "data from Huffington Post, analysis after fivethirtyeight.com";
proc sgplot;
	band x=polldate upper=umoe lower=lmoe / fillattrs=(color=gray)
		legendlabel="+3.5% / -3.5%";
	series x=polldate y=trailing / lineattrs=(color=red)
		legendlabel="Trailing average";
	scatter x=polldate y=margin / markerattrs=(symbol=circlefilled color=black)
		legendlabel="Polling margin";
	refline 8.5 / lineattrs=(pattern=dot thickness=4 color=black) 
		label="Actual Result: Ernst +8.5" labelloc=inside;
	xaxis grid;
	yaxis min=-10 max=10 grid label=" ";
	label polldate = "Poll Ending Date";
	format margin margin.;
	run;

title; footnote;
