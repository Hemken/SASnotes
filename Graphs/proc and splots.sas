* Scatter plots;
title 'Fisher (1936) Iris Data';
ods select scatterplot;
proc corr data=sashelp.iris plots=scatter(ellipse=none);
	var petallength petalwidth;
	run;
*Easier to specify with SGPLOT;
title 'Fisher (1936) Iris Data';
proc sgplot data=sashelp.iris;
   scatter x=petallength y=petalwidth;
run;
*Group markers;
proc sgplot data=sashelp.iris;
   scatter x=petallength y=petalwidth / group=species;
run;
title;

* Frequency plots (bar charts);
title "Framingham Heart Study";
ods select freqplot;
proc freq data=sashelp.heart;
	tables status / plots=freqplot(scale=percent);
	run;

proc sgplot data=sashelp.heart;
	vbar status / stat=percent;
	run;

* Grouped bar charts;
ods select freqplot;
proc freq data=sashelp.heart;
	tables status*sex / plots=freqplot(twoway=cluster);
	run;

proc sgplot data=sashelp.heart;
	vbar sex / group=status groupdisplay=cluster;
	run;
title;

* Box plots;
title1 'Nitrogen Content of Red Clover Plants';
data Clover;
   input Strain $ Nitrogen @@;
   datalines;
3DOK1  19.4 3DOK1  32.6 3DOK1  27.0 3DOK1  32.1 3DOK1  33.0
3DOK5  17.7 3DOK5  24.8 3DOK5  27.9 3DOK5  25.2 3DOK5  24.3
3DOK4  17.0 3DOK4  19.4 3DOK4   9.1 3DOK4  11.9 3DOK4  15.8
3DOK7  20.7 3DOK7  21.0 3DOK7  20.5 3DOK7  18.8 3DOK7  18.6
3DOK13 14.3 3DOK13 14.4 3DOK13 11.8 3DOK13 11.6 3DOK13 14.2
COMPOS 17.3 COMPOS 19.4 COMPOS 19.1 COMPOS 16.9 COMPOS 20.8
;

ods select BoxPlot;
proc glm data = Clover; /* or PROC ANOVA */
   class Strain;
   model Nitrogen = Strain;
run; quit;
* Strains in alphabetic order - reorder with informats and formats;
proc sgplot data=Clover;
	vbox nitrogen / category=strain;
	run;
title;

*Regression plots;
ods select FitPlot;
proc reg data=sashelp.cars;
	model mpg_highway = weight;
	run; quit;

proc sgplot data=sashelp.cars;
	reg y=mpg_highway x=weight;
	run;

proc sgplot data=sashelp.cars;
	reg y=mpg_highway x=weight / group=origin;
	run;

proc sgpanel data=sashelp.cars;
	panelby origin;
	reg y=mpg_highway x=weight;
	run;
