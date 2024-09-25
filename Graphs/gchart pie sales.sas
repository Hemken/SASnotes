/* SAS Proc Chart Example 3 data */

data piesales;
   input Bakery $ Flavor $ 10-18 Year Pies_Sold;
   datalines;
Samford  apple      1995  234
Samford  apple      1996  288
Samford  blueberry  1995  103
Samford  blueberry  1996  143
Samford  cherry     1995  173
Samford  cherry     1996  195
Samford  rhubarb    1995   26
Samford  rhubarb    1996   28
Oak      apple      1995  319
Oak      apple      1996  371
Oak      blueberry  1995  174
Oak      blueberry  1996  206
Oak      cherry     1995  246
Oak      cherry     1996  311
Oak      rhubarb    1995   51
Oak      rhubarb    1996   56
Clyde    apple      1995  313
Clyde    apple      1996  415
Clyde    blueberry  1995  177
Clyde    blueberry  1996  201
Clyde    cherry     1995  250
Clyde    cherry     1996  328
Clyde    rhubarb    1995   60
Clyde    rhubarb    1996   59
;
run;

proc gchart data=piesales;
	vbar flavor / freq=pies_sold;
run;

proc gchart data=piesales;
	vbar flavor / sumvar=pies_sold;
run;
 
proc gchart data=piesales;
	vbar flavor / type=mean sumvar=pies_sold;
run;

proc gchart data=piesales;
	vbar flavor / group=year sumvar=pies_sold;
run;

proc gchart data=piesales;
	vbar year / group=flavor sumvar=pies_sold discrete;
run;

proc gchart data=piesales;
	vbar flavor / subgroup=bakery sumvar=pies_sold discrete;
run;
