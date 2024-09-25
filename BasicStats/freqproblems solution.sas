* This exercise uses the General Social Survey
	data from 2006.  The SAS data set may be 
	found in y:\sas\data .;

libname y "y:\sas\data";
libname library (y);

* Use proc contents and a search of your output to
	find the variables for respondent's education,
	mother's education, and father's education.
	(For now, ignore the issue of weighting for
	individuals instead of households.)

	What proportion of respondents have more than
	12 years of education?  Mothers?  Fathers?;

proc contents data=y.gss2006;
run;

proc freq data=y.gss2006;
	tables educ maeduc paeduc;
	run;

* Use a crosstab to check the relationship
	between respondent's sex and education.
	What does chi-square tell you about the
	relationship?  What can you see by
	looking at conditional percents (for
	instance, % sex within education levels)?;

proc freq data=y.gss2006;
	tables educ*sex / nopercent nocol chisq;
	run;

* Is there any relation between respondent's sex
	and region of residence?  In your proc, ask
	for one-way tables as well.;

proc freq data=y.gss2006;
	tables sex region / nocum;
	tables region*sex / nopercent nocol chisq expected;
	run;

* Repeat each of these analyses using the weighting
	variable wtssall . Do any of your observations/
	conclusions change?;

proc freq data=y.gss2006;
	tables educ maeduc paeduc;
	weight wtssall;
	run;

proc freq data=y.gss2006;
	tables educ*sex / nopercent nocol chisq;
	weight wtssall;
	run;

proc freq data=y.gss2006;
	tables sex region / nocum;
	tables region*sex / nopercent nocol chisq expected;
	weight wtssall;
	run;
