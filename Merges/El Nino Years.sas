data elnino(drop=temp);
	length nino $ 7 strength $ 6;
	retain nino strength;
	input temp $ & ;
	if temp eq "El Niño" then nino = temp;
	else if temp eq "La Niña" then nino = temp;
	else if temp in("Weak", "Mod", "Strong") then strength = temp;
	else do;
		year = input(temp, 4.);
		if nino eq "El Niño" then do;
			if strength eq "Strong" then scale = 7;
			else if strength eq "Mod" then scale = 6;
			else if strength eq "Weak" then scale = 5;
			end;
		else if nino eq "La Niña" then do;
			if strength eq "Strong" then scale = 1;
			else if strength eq "Mod" then scale = 2;
			else if strength eq "Weak" then scale = 3;
			end;
		output;
		end;
* data from http://ggweather.com/enso/oni.htm;
datalines;
El Niño	
Weak	
1951	
1963	
1968	
1969	
1976	 
1977	 
2004	 
2006		 
Mod	
1986	
1987	
1994	
2002	
Strong	
1957	
1965	
1972	
1982	
1991	
1997	
2009	
La Niña		
Weak		 	
1950	
1956	
1962	
1967	
1971	
1974	
1984	
1995	
2000
Mod	
1954	
1964	
1970	
1998	
1999	
2007	
2010	
Strong
1955
1973
1975
1988
;

proc sort data=elnino;
by year;
run;

data years;
	do year = 1950 to 2010;
		output;
		end;
run;

data elninoyears;
	merge years(in=one) elnino(in=two);
	by year;
	if not two then scale = 4;
	run;

proc freq data=elninoyears;
	tables scale;
	run;

proc means data=elninoyears;
	var scale;
	run;

symbol1 interpol=l value="point";
proc gplot data=elninoyears;
	plot scale*year;
	run;quit;

data elninoyears;
	set elninoyears;
	year = year + 1;
	run;

libname y "y:\sas\data";

data warming;
	merge y.mendotaice elninoyears;
	by year;
	run;

ods graphics on;
proc corr data=warming;
	var year days scale;
	run;
ods graphics off;

proc reg data=warming;
	model days = year scale;
	model days = year;
	run; quit;

data thisyear;
	set warming;
	year = year - 2011;
	scale = scale - 4;
	run;

proc reg data=thisyear;
	model days = year scale;
	model days = year;
	run; quit;

proc reg data=thisyear;
	model days = year;
	run; quit;
