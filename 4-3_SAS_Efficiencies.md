# SAS Programming Efficiencies

The purpose of this document is to provide tips for improving the
efficiency of your SAS programs. It suggests coding techniques,
provides guidelines for their use, and compares examples of acceptable
and more efficient ways to accomplish the same task. Most of the tips are
limited to DATA step applications.

See also [Optimizing System Performance](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lepg/n1c7iu5f048fdtn1v3g8ba2j3p6i.htm) in the **SAS Programmer's Guide**.

## Efficiency

For the purpose of this discussion, efficiency will be defined simply
as obtaining more results from fewer computer resources. When you
submit a SAS program, the computer must:

- load the required software into memory
- compile the program
- find the data on which the program will execute
- perform the operations requested in the program
- report the result of the operations for your inspection

All of these tasks require time and space. Time and space for a
computer program are composed of CPU time, I/O time, and memory.

- *CPU time*:   the time the Central Processing Unit spends performing the
operations you assign.
- *I/O time*:   the time the computer spends on two tasks, *input* and
*output*. Input refers to read the data from a storage
device. Output refers to writing to storage or to a
display device.
- *Memory*:     the size of the work area that the CPU must devote to the
operations in the program.

Another important resource is *data storage* - how much space on disk
your data use.

A gain in efficiency is seldom absolute because optimizing one
resource usually results in increased use of another resource.
For example, recreating a SAS data set from a text file
in each program run avoids the cost of
storing a SAS data set but increases the I/O and CPU time for the
program. A few programming techniques improve performance in all
areas.

## Faster Data Access

Reading and writing data (I/O) is the largest single component of
elapsed time ("real time") in most programs, including SAS programs.
Reading and writing
data to *local* disks (attached to the same computer that is doing your
computations) rather than *network* disks improves the speed of programs
enormously. Decreasing the number of times you read or write data is also
an effective way to improve the speed with which your programs are processed.

### Tip 1: Use locally sourced data
If you will be reading a data set multiple times (especially if you
will be using it for multiple PROCs), place it in memory with a
SASFILE statement, or move your data to a local
library (WORK).  Use PROC COPY, PROC DATASETS, or even a simple DATA step
to place your data in the WORK library.

If you are *not* using the data set (or subsets) in multiple PROCs,
this is actually inefficient, because the data is read, written, and read,
rather than being simply read.

If the WORK library does
not have enough room for your very large data set, [on Linstat use
the /tmp folder](bigsas.html).

With extremely large data sets, even this may not be an option - the network
drives have more storage space than the local disks on each server.

### Tip 2: SAS data is faster than text data
Recreating the same SAS data set by importing the data
from the same text file, over and over and over again is just as
inefficient as it sounds.

Create an input script that saves your data set to a permanent location,
i.e. a network drive.  (Save the script and the source text file, obviously.)

**First Try:**
```sas
data adults;
  infile "census.dat";
  input @34 division $3. @112 rpincome 8.;
  run;
  
proc means;
  class division;
  var rpincome;
  run;
```

**More Efficient:**
Having previously created the data set `adults` and saved it
in a folder called "dissertation", use that data by setting up
a LIBNAME, and reading it from the network drive.

```sas
libname read "~/dissertation";

proc means data=read.income;
  class division;
  var rpincome;
  run;
```

When you need to use SAS repeatedly to analyze or manipulate a
particular group of data, create a permanent SAS data set instead of
reading the raw data each time to create a temporary SAS data set.
With your data already in a permanent SAS data set, you can avoid DATA
steps altogether saving CPU time and extra I/O operations.

### Tip 3: Create multiple subsets with one DATA step
If several different subsets are needed, avoid rereading the
data for each subset.

**First Try:**
```sas
data div1;
  set read.adults;
  where division=1;
  run;
  
data div2;
  set read.adults;
  where division=2;
  run;
  
data div3;
  set read.adults;
  where division=3;
  run;
```

**More Efficient:**
```sas
data div1 div2 div3;
  set read.adults;
  if division=1 then output div1;
    else if division=2 then output div2;
    else if division=3 then output div3;
  run;
```

Minimize the number of times you read large SAS data sets or external
files by producing all the subsets you require for further processing
in one DATA step. Test for conditions using IF/THEN statements and
write observations to multiple data sets using OUTPUT statements. This
tip saves both I/O and CPU time.

### Tip 4: Use WHERE statements for subsets
In a DATA step, a WHERE statement excludes observations from being
read into the Program Data Vector, while an IF statement reads in the
data but doesn't send it to the output data set.  WHERE saves I/O.

If a subset will be used only for analysis by another SAS
step, use a WHERE statement in the PROC,
rather than creating a new data set.
This saves both I/O and CPU time.

**First Try:**
```sas
data div1;
  set read.adults;
  where division=1;
  run;
  
proc means;
  var salary;
  run;
```

**More Efficient:**
```sas
proc means data=read.adults;
  where division=1;
  var salary;
  run;
```

## Process Only the Data You Need

### Tip 5: Input only the variables you need.
#### Fixed-width Data
If you import a text file with data arranged in fixed columns, use the
codebook and import only what you need.  (It's easy to modify your code
later if you realize you need another variable.)

This is not only computationally efficient, it reduces the clutter in
your code!  And it will probably take you much less time to write!

**More Efficient:**
```sas
data adults;
  infile "census.dat";
  input @34 division $3. @112 rpincome 8.;
  run;
```

When you read records (lines) from an external file, you spend CPU time. By
excluding unnecessary fields from the INPUT statement, you spend less
CPU time, reduce I/O, and eventually save disk space.

#### Space- and Comma-delimited Data
When text data are space- or comma-delimited, in a DATA step
you will have to import
the variables from the first to the last that you need, but you can
skip later variables.

#### Using a prepared script
Archived data often comes in the form of text data and a prepared
import script.  Add a KEEP option to the output data set
or a KEEP statement at the bottom of the DATA step, to keep only
those variables you will need.

### Tip 6: Read subset-selection fields first when inputting data
If you will only keep selected observations, read in the variables
used to select observations first, and finish reading the rest of
the variables only for observations you will keep.

**First Try:**
Read everything, then select with a subsetting IF.

```sas
data adults;
  infile "census.dat";
  input \@34 division \$3. \... \@112 rpincome 8.;
  if division=1;
  run;
```

**More Efficient:**
```sas
data adults;
  infile "census.dat";
  input \@34 division \$3. @;
  
  if division=1;
  input \... \@112 rpincome 8.;
run;
```

Determine if you can eliminate records based on the contents of one or
two fields. Read those fields with an INPUT statement, using an ` @ `
line-hold specifier to hold the record, and test for a qualifying
value. If the value meets your criteria, read the rest of the record
with another INPUT statement. Otherwise, delete the record. Using this
tip saves CPU time.

### Tip 7: Drop selection, intermediate, and looping variables
Primarily, just store the variables you need for your analysis.
Obviously, you should save the script that creates the stored SAS data set,
so you can modify it if you later want more (or fewer) variables.

There are some variables you need only during DATA step execution. For
example:

- index variables from DO loops
- variables holding values for testing conditions
- variables holding intermediate values in calculations

Eliminating these variables from the output data set saves disk space.

In this example, the selection variable `division` is no longer
needed after the subset has been created.  In the output data
set it is a constant, and can be dropped.

**First Try:**
```sas
data temp;
  set read.adults;
  where division =1;
run;
```

**More Efficient:**
```sas
data temp(drop=division);
  set read.adults;
  where division =1;
run;
```

### Tip 8: KEEP only the variables you need

**First Try:**
The DATA step reads *all* the data in `adults`, and writes it *all*
to `temp`.
```sas
data temp;
  set read.adults;
  yr=year(date);
  flag = division in(1,2,3); /* flag is 0 or 1*/
  if (flag) then do;
    if yr < 1950 then adjinc=rpincome/1.25;
      else if yr < 1960 then adjinc=rpincome/1.5;
      else if yr < 1970 then adjinc=rpincome/1.75;
    end;
  run;

proc reg data=temp;
  model adjinc=year;
  run;
```

**More Efficient:**
Only the data that will be processed in the DATA step
and the subsequent PROC step is *read* from `adults`.
Only the data that will be processed in the PROC step
is *written* to `temp`.

```sas
data temp(keep=adjinc yr);
  set read.adults(keep=date division rpincome);
  flag = division in(1,2,3); /* flag is 0 or 1*/
  yr=year(date);
  if (flag) the do;
    if yr < 1950 then adjinc=rpincome/1.25;
      else if yr < 1960 then adjinc=rpincome/1.5;
      else if yr < 1970 then adjinc=rpincome/1.75;
    end;
  run;
  
proc reg data=temp;
  model adjinc=year;
  run;
```

When you use data set options to select the variables you want, you
eliminate all of the other variables from the program data vector as
well as from the output data sets you produce. This saves
you CPU time, I/O, and memory.

## Writing Text Files

### Tip 9: Use a null data set for writing text files

**First Try:**
This DATA step **both** writes to a text file, "div1.dat" and to
a SAS data set, `temp`.
```sas
data temp;
  set read.adults;
  file "div1.dat";
  put division $3. rpincome 8.;
run;
```

**More Efficient:**
```sas
data _null_;
  set read.adults;
  file "div1.dat";
  put division $3. rpincome 8.;
  run;
```

When creating external files using a DATA step, use the \_NULL\_
keyword in the DATA statement to run the step without creating a SAS
data set. This saves CPU time, I/O, and disk space.

## Reducing Storage Space

### Tip 10: Shorten character data using formats and informats

SAS is able to use formats (value labels) and informats with
both numeric and character data.

Consider the following data (in fixed column format):

```
00001 DIVORCED 1
00002 WIDOWED  0
00003 DIVORCED 2
00004 SINGLE   0
00005 MARRIED  5
00006 SINGLE   1
00007 MARRIED  0
```

**First Try:**
```sas
libname save "~/dissert";
data save.marital;
  infile "marital.dat";
  input id 1-5 status $ 7-14 no_chil 18;
run;
```

**More Efficient:**
The variable `marital` has a length of 1,
while `status` has a length of 9.

```sas
data marital;
  infile "marital.dat";
  input id 1-5 status $ 7-14 no_chil 16;
  if status="DIVORCED" then marital="D";
    else if status="WIDOWED" then marital="W";
    else if status="SINGLE" then marital="S";
    else if status="MARRIED" then marital="M";
    drop status;
```

**Even Better:**
Using an informat reduces the DATA step recoding,
and using a format gives you the same printed
output as the original data values.

```sas
libname save "~/dissert";
libname library (save); /* keep formats with data */
proc format library=library;
  invalue $ mar 'SINGLE'='S'
                'MARRIED'='M'
                'DIVORCED'='D'
                'WIDOWED'='W';
  value $ mar 'S'='SINGLE'
              'M'='MARRIED'
              'D'='DIVORCED'
              'W'='WIDOWED';
run;

data save.marital;
  infile "marital.dat";
  input id 1-5 status $mar8. no_chil 18;
run;

proc print data=save.marital;
  format status $mar.;
run;
```

Define your own formats and informats when you can use a short code to
represent long character data. Use informats to transform long
character values in raw data into codes with shorter values in your
SAS data set. Use formats that convert coded values to longer values
when you need them. By using this tip, you trade an increase in CPU
time for a decrease in storage requirements.

### Tip 11: Use LENGTH statements to reduce storage space

SAS uses a default length of 8 bytes for variables in SAS data sets unless you
specify a different length. For **character variables** and for **numeric
variables containing integers**, you can save significant storage space
by specifying the length without loss of information.

:::{.callout-tip}
Use a LENGTH statement **before** you INPUT or SET
data in order to change a variable's length
:::

:::{.callout-warning}
Caution: In general, do not shorten numeric variables
containing fractions - it reduces their precision!
:::

Using LENGTH statements slightly increases the CPU time.

**First Try:** 
```sas
data report;
  input local catalog;
  sales=local+catalog;
datalines;
100 400
300 800
:
;
```

**More Efficient:**
```sas
data report;
  length local catalog sales 4;
  input local catalog; 
  sales=local+catalog;
datalines;
100 400
300 800
:
;
```

### Tip 12: Use character rather than numeric variables
For categorical variables that happen to be labeled with
numerals, encode them as character variables.

**First Try:**
```sas
data inventory;
  infile "inventory.dat";
  input item start finish;
  sales=start-finish;
run;
```

**More Efficient:**
```sas
data inventory;
  length item $ 4;
  infile "inventory.dat";
  input item $ start finish;
  sales=start-finish;
run;
```
By default, numeric variables occupy 8 bytes of storage,
whereas character variables can occupy as few as 3 bytes.

### Tip 13: Use the COMPRESS= data set option
When creating large SAS data sets, SAS provides a
method for reducing the storage required.  See
[Using Compressed Data](4-11_SAS_Compressed_Data.html)

**First Try:**
```sas
libname read '~/dissert';
data read.salary;
  infile "salary.dat";
  :
run;
```

**More Efficient:**
```sas
libname read '~/dissert';
data read.salary(compress=binary);
  infile "salary.dat";
  :
run;
```

Compressed data sets require less storage space, and I/O operations
are faster.

### Tip 14: Use MODIFY instead of SET to recode existing variables
MODIFY does not make a copy of the data set like SET does. **Only use
MODIFY when disk space is an issue.** This statement does not save I/O
and uses more CPU. Note that you cannot create new variables with
MODIFY.

**First Try:**
Changes are made, overwriting the original data set,
and the original variable.  Be sure you can recover
the original data if you make a (human) mistake!

```sas
libname read '~/dissert';
data read.salary;
  set read.salary;
  salary=salary\*.1;
run;
```

**More Efficient:**
```sas
libname read  '~/dissert';
data read.salary;
  modify read.salary;
  salary=salary\*.1;
run;
```

## Less SORT Space

### Tip 15: Concatenate compound ID variables

**First Try:**
```sas
proc sort data=old;
  by vara varb varc vard vare;
  run;
```

**More efficient:**
```sas
data new;
  set old;
  sortvar=vara || varb || varc || vard || vare;
  run;

proc sort data=new;
  by sortvar;
  run;
```

This second sort requires less SORT space. Note that the
concatenation operator, ` || ` only works for character
variables. If the variables you need to sort by are numeric, use the
PUT function to convert them to character variables before the
concatenation:

```sas
cage=put(age, 3.);
```

### Tip 16: Sort TAGs, not data
Use the TAGSORT option to sort **large** SAS data sets.  This
trades I/O and CPU time for the utility space required by
PROC SORT.

**More efficient:**
```sas
proc sort tagsort data=old;
  by vara varb varc vard vare;
  run;
```

### Tip 17: SORT to a different library
Reading data from one location, SORTing it
and writing it to a different location requires less I/O operations.

**First Try:**
```sas
proc sort data=one;
  by age;
  run;
```

**More Efficient:**
```sas
libname save "~/sas";

proc sort data=one out=save.one;
  by age;
  run;
```

## Clean up

### Tip 17: Delete SAS data sets no longer needed
Use PROC DATASETS to automatically delete files you will not
need later.

**First Try:**
Read in data from two separate text files.  Then concatenate and sort the data.
We end up with two intermediate data sets that are no longer needed and just
taking up space.

```sas
data one;
  infile "one.dat";
  input a b;
  run;
  
data two;
  infile "two.dat";
  input a b;
  run;
  
data all;
  set one two;
  run;

proc sort;
  by a b;
  run;
```

**More efficient:**
```sas
data one;
  infile "one.dat";
  input a b;
  run;
  
data two;
  infile "two.dat";
  input a b;
  run;
  
data all;
  set one two;
  run;

proc datasets;
  delete one two;
  run;

proc sort data=all;
  by a b;
  run;
```

This tip saves disk space in the WORK library.

## Take advantage of SAS procedures.

Use procedures instead of DATA steps for data wrangling. This will save
*you* time coding, and probably CPU time as well. 

The following procedures produce output
data sets that could be used instead of writing a DATA step to produce
the data:

These procedures calculate summary data values:

PROC          | result
--------------|------------------------------------------------------------
MEANS (SUMMARY) | outputs descriptive (summary) statistics
FREQ          | outputs counts for groups of observation
RANK          | ranks the observations of numeric variables
STANDARD      | standardizes variables to specified means and standard deviations


These procedures help you move and organize multiple data sets:

PROC          | result
--------------|------------------------------------------------------------
COPY          | copies a data set from one location to another
APPEND        | appends data from one SAS data set to the end of another
TRANSPOSE     | reshapes SAS data sets


## Execute only the Necessary DATA Step Statements

The number and complexity of statements executed largely control the
CPU time used by a DATA step. 
By default, SAS executes every statement in the DATA
step for each observation in the input source. Within a statement, SAS
executes every operation in a given expression each time the statement
executes. Tips in this section fall into two main categories:

- tips that reduce the number of statements executed
- tips that reduce the number of operations performed in a particular
statement.

### Tip 18: Subset your data first
When performing several calculations, be sure you execute
them only for the necessary observations.

**First Try:**
This DATA step calculates a weekly income, and saves only those
observations under age 50.
```sas
data temp;
  set read.adults;
  wkincome=rpincome/52;
  if age <50;
  run;
```

**More Efficient:**
Select first, then calculate.
```sas
data temp;
  set read.adults;
  where age <50;
  wkincome=rpincome/52;
  run;
```
By replacing the subsetting IF statement with a WHERE, and moving it before the new
variable calculation, the rescaling
is executed only for the observations that will appear in the output
data set. This decreases the CPU time.  WHERE selects data before they are loaded
into the PDV, while IF selects data after they are in the PDV.  And we don't
perform calculations on observations that are deleted.

### Tip 19: Mutually exclusive conditions
When only one condition can be true for a given observation,
write a series of IF-THEN/ELSE statements or SELECT-WHEN statements.

**First Try:**
This DATA step rescales reported income based on categories of `division`.
```sas
data ...
...
if division =1 then adjinc=rpincome/1.5;
if division =2 then adjinc=rpincome/1.4;
if division =3 then adjinc=rpincome;
if division =4 then adjinc=rpincome;
if division =5 then adjinc=rpincome/1.2;
if division =6 then adjinc=rpincome/1.2;
if division =7 then adjinc=rpincome/1.2;
if division =8 then adjinc=rpincome/1.3;
if division =9 then adjinc=rpincome;
if division gt 9 then adjinc=rpincome;
...
run;
```

In this example, the value of `division` is checked 10 times
for every single obervation!  We could also consolidate some
of the calculations.

**More Efficient:**
Link conditions with ELSE IF.
```sas
data ...
...
if division =1 then adjinc=rpincome/1.5;
  else if division =2 then adjinc=rpincome/1.4;
  else if division in (5,6,7) then adjinc=rpincome/1.2;
  else if division =8 then adjinc=rpincome/1.3;
  else if division ne . then adjinc=rpincome; /* includes 3,4,9, gt 9 */
...
run;
```

Here the value of `division` is checked from 1 to at most 5 times.  Further
efficiency could be had by ordering the categories from most to least frequent.

(There are a few different ways to use white space to suggest that these
statements act as a block.)

**Also More Efficient:**
Choose among categories.
```sas
data ...
...
select (division);
  when (1)     adjinc=rpincome/1.5;
  when (2)     adjinc=rpincome/1.4;
  when (5,6,7) adjinc=rpincome/1.2;
  when (8)     adjinc=rpincome/1.3;
  otherwise    adjinc=rpincome;
...
run;
```

Where `division` has many categories, SELECT-WHEN is more efficient.  In
this example if might be only slightly more efficient.

### Tip 20: Calculate values once
Perform resource-intensive calculations and comparisons only
once.

**Use nested IF-THEN to test compound conditions.**

**First Try:**
This DATA step adjusts income for selected divisions, based on `year`.
```sas
data ...
...
if division in(1,2,3) and year(date)< 1950 then adjinc=rpincome/1.25;
  else if division in(1,2,3) and year(date)< 1960 then adjinc=rpincome/1.5;
  else if division in(1,2,3) and year(date)< 1970 then adjinc=rpincome/1.75;
...
run;
```

Here the value of `division in(1,2,3)` is calculated three times, and the value
of `year(date)` is calculated up to three times.

(Notice too, that without the ELSE, all the adjustments would be by 1.75.  A
small oversight could have been a huge error in logic!)

**More Efficient:** Use functions once.
```sas
data ...
...
yr=year(date);
if division in(1,2,3) then do;
    if yr< 1950 then adjinc=rpincome/1.25;
      else if yr< 1960 then adjinc=rpincome/1.5;
      else if yr< 1970 then adjinc=rpincome/1.75;
    end;
...
run;
```

Compound conditions often have multiple outcomes that share a
common condition.  Nesting conditions means you only have to
evaluate the shared condition once.  *The order in which you
nest conditions matters!*  Use a DO block when the secondary
condition has more than two outcomes.

Functions are expensive and require a lot of CPU time. By moving the
calculations involving SAS functions, you have reduced the number of
times the functions need to be evaluated per observation.

### Tip 21: RETAIN constant values.

**First Try:**
This DATA step adds a `year` constant as it read in text data.
```sas
data scores;
  infile "scores.dat";
  input test1-test3;
  year=2024;
run;
```

**More Efficient:**
```sas
data scores;
  retain year 2024;
  infile "scores.dat";
  input test1-test3;
  run;
 ```

SAS assigns values to variables in a RETAIN statement only once. In
contrast, SAS executes assignment statements during each iteration of
the DATA step.

### Tip 22: Check for missing values
Especially before using a variable in multiple statements.

**First Try:** 
```sas
data test; 
  set save.sales; 
  cost=whosale + oftmiss;
  tax=oftmiss*.05; 
  profit=sales-oftmiss;
run;
```

**More efficient:** 
```sas
data test; 
  set save.sales; 
  if oftmiss ne . then do;
    cost=whosale + oftmiss;
    tax=oftmiss*.05; 
    profit=sales-oftmiss;
    end;
run;
```

Propagating missing values in expressions requires CPU time, as
discussed in the previous tip. By checking for a missing value before
performing the operations, you can reduce the number of missing values
that are propagated.

### Tip 23: Use format to assign many values in one statement.

**First Try:**
```sas
:
if educ = 0 then neweduc="\< 3 yrs old"; 
  else if educ=1 then neweduc="no school"; 
  else if educ=2 then neweduc="nursery school";
:
  else if educ=16 then neweduc="Profess. degree"; 
  else if educ=17 then neweduc="Doctorate degree";
:
```

**More Efficient:**
```sas
proc format;
  value educf 0=" < 3 yrs old"
              1="no school"
              2="nursery school"
              3="kindergarten"
              4="thru 4th grade"
              5="thru 8th grade"
              6="9th grade"
              7="10th grade"
              8="11th grade"
              9="12th but nongrad"
              10="H.S. Grad"
              11="College,no degree"
              12="Assoc.,occupat."
              13="Assoc., academic."
              14="Bachelor Degree"
              15="Master Degree"
              16="Profess. degree"
              17="Doctorate degree";
run;

data new;
  set old; 
  neweduc=put(educ,educf.);
run;
```

When you must change many values of a variable to other values, using
user-created formats with the PUT function enables you to make the
changes in a single assignment statement, saving CPU resources.

Better yet, just use the format in your PROCs!

### Tip 24: Shorten expressions with functions

**First Try:**
```sas
:
array c{10} cost1-cost10; 
tot=0; 
do i=1 to 10; 
  if c{i} ne . then do;
    tot+c{i}; 
    end; 
  end;
:
```

**More Efficient:**
```sas
:
tot=sum(of cost1-cost10);
:
```

Functions use precompiled expressions. Therefore, a DATA step
containing a function needs to compile only the name of the function
and its arguments. If you write an expression to do the same thing,
SAS must compile all the operators and operands in the expression.
This saves you CPU.

### Tip 25: Use the IN operator rather than logical OR operators.

**First Try:**
```sas
:
if status=1 or status=5 or status=8 or status=9 then newstat="single"; 
  else newstat="not single";
:
```

**More Efficient:**
```sas
:
if status in (1,5,8,9) then newstat="single"; 
  else newstat="not single";
:
```
When SAS evaluates an expression containing the IN operator, it stops
the evaluation as soon as a comparison makes the expression true. When
SAS evaluates an expression containing multiple OR operators, it
evaluates the entire expression even if one true comparison has
already made the comparison true.

### Tip 26: Use If-THEN rather than compound expressions with AND

**First Try:**
```sas
:
if status1=1 and status2=5 and status3=8 and status4=9 then output;
:
```

**More Efficient:**
```sas
:
if status1=1 then 
  if status2=5 then 
    if status3=8 then 
      if status4=9 then output;
:
```
When a DATA step contains a series of conditions in IF-THEN clauses,
the DATA step stops evaluating the series as soon as one clause is
false. However, when the conditions are joined by AND, the DATA step
evaluates all the conditions even if one is false.

Last revised: 09-12-2024
