data drug;
      input drug$ x r n @@;
      datalines;
   A  .1   1  10   A  .23  2  12   A  .67  1   9
   B  .2   3  13   B  .3   4  15   B  .45  5  16   B  .78  5  13
   C  .04  0  10   C  .15  0  11   C  .56  1  12   C  .7   2  12
   D  .34  5  10   D  .6   5   9   D  .7   8  10
   E  .2  12  20   E  .34 15  20   E  .56 13  15   E  .8  17  20
   ;

data drugexpanded;
	set drug;
	event = 1;
	do i = 0 to r;
		if i > 0 then output;
		end;
	event = 0;
	do i = (r+1) to n;
		if (r+1) <= n then output;
		end;
	drop i r n;
	run;

proc genmod data=drugexpanded;
	class drug;
	model event = drug x drug*x / dist = binomial link=logit;
	run;

data lognorm;
      input x y;
      datalines;
   0 5
   0 7
   0 9
   1 7
   1 10
   1 8
   2 11
   2 9
   3 16
   3 13
   3 14
   4 25
   4 24
   5 34
   5 32
   5 30
   ;

proc sgplot data=lognorm;
	scatter y = y x = x;
	run;

proc genmod data=lognorm;
      model y = x / dist = normal
                    link = log;
run;
