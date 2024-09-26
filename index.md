---
title: "SAS Notes"
toc-expand: 1
---

## Using SAS in the SSCC
- [Using SAS in the SSCC](interfaces.html)
  - Windows vs. Linux
  - Interactive vs. batch
- [Launching SAS from a Command Line](7-4_SAS_command_line.html)
- [Launching SAS from the Windows Explorer](sas_windows_launch.html)
- [Customizing Your SAS Configuration](custom_configuration.html)
  - [Setting CPUCOUNT](setting_cpucount.html)

## Using the SAS Windows (DMS)
- [Introduction to the SAS Windowing
Environment](http://support.sas.com/documentation/cdl/en/lrcon/67227/HTML/default/viewer.htm#p1kcewwv8r36lun1nvr2ryx9ks9h.htm) (SAS 9.4 Language Reference)
- [Main Windows in the SAS Windowing
Environment](http://support.sas.com/documentation/cdl/en/lrcon/67227/HTML/default/viewer.htm#n1039zk8bk9aton1fmbm7z2wji3k.htm) (SAS 9.4 Language Reference)
- [Submitting Commands](SubmittingCode.html)

## Working with the SAS Language
Saving and Using SAS Files, and the SAS Language.

- [Writing SAS Code](SASGrammar.html)
- [SAS Files](SASFiles.html)
  - [Saving SAS Data](saveSASdata.html)
  - [Data Set Options](data_set_options.html)
  - [Saving SAS Output](saveSASoutput.html)
  - [SAS Procedure Graphs](4-21_Simple_SAS_Graphs_with_ODS.html)

## Working with Large Data Sets
- [SAS Efficiencies](4-3_SAS_Efficiencies.html)
- [Where to Store Data](bigsas.html)
- [Compressed Data](4-11_SAS_Compressed_Data.html)
- [Importing Large Text Files](4-11_Zipped_data.html)
- [Optimizing System Performance](https://documentation.sas.com/doc/en/lrcon/9.4/p1xjhzwjv6ojukn18mi4j1ysye76.htm) (SAS 9.4 Language Reference)

## Building Data Sets (Data Wrangling)
### The DATA step
- [The Basic DATA step](4-18_Basic_DATA_Steps.html)
- [Understanding the DATA step](4-18_Understanding_DATA_Steps.html)
- [Working with Numeric Data](numeric_values.html)
- [Working with Character Values](character_values.html)
- [Converting Numeric/Character Types](Converting_numbers_and_characters.html)
- [Creating and Using Indictators for Many Categories](4-2_SAS_Indicator_Variables.html)
- [Working with Logical Values](Logical_data.html)
- [Conditional Processing:  IF-THEN/ELSE](4-18_If-Then_Else.html)
- [Statement groups and Iterations:  DO/END](4-18_Do_groups_and_loops.html)
- [Iterating over variables:  Variable Arrays](4-5_SAS_Arrays.html)
- [Repeated and Duplicate Observations](duplicates.html)

### Beyond the DATA step
- [Variable Labels](variable_labels.html)
- [SAS Formats](Formats.html)
- [User-defined Formats (Value Labels)](4-19_SAS_user_formats.html)
- [Informats to Encode and Order Character Values](4-19_SAS_user_informats.html)
- [Types of SAS Errors](Error_types.html)

### Reading Data into SAS
-  [Concepts](textdata_sources.html)
-  [Observations and Records](observations_records.html)
-  [INPUT specification](INPUT_specs.html)

### Subsets and Merges
- Subsets
  -  [Variables](Subset_variables.html)
  -  [Conditional observations](Subset_observations.html)
- Merges
  -  [Add variables, Concatenate, Stack data sets](Merges/set.sas)
  -  [Nuances and trouble-shooting concatenation](Merges/set%20nuances.sas)
  -  [PROC APPEND and DATASETS](Merges/append.sas)
  -  [Concatenate, Merge, and Match-merge](Merges/04%20-%20Data%20Merges.sas)
  - [Table lookup techniques](4-1_SAS_Table_lookup.html)

### Arrays
- [Variable Arrays](4-5_SAS_Arrays.html)

### Reshaping Data
- [Reshape Long](4-5_SAS_Reshape_Long.html)
- [Reshape Wide](4-5_SAS_Reshape_Wide.html)

## Output Data Sets
  - [SAS Output as Data](4-8_Output_data.html)
-   [Utility and Statistical
    procs](Output%20data/proc%20standard%20and%20summary.sas)
-   [Output statements and
    options](Output%20data/output%20data%20sets.sas)
-   [ODS](Output%20data/ods%20output%20data%20sets.sas)
-   [ODS example: collecting
    lsmeans](Output%20data/collecting%20lsmeans.sas)

## Common Statistical Procedures
-   [Frequencies and Crosstabs](BasicStats/procfreq.html)
-   [Means](BasicStats/procmeans.sas)
-   [Weighted Means](BasicStats/procmeansweighted.sas)
-   [Correlations](BasicStats/proccorr.sas)
-   [Regression](BasicStats/procreg.sas)

## [Graphics](Graphs/SAS%20Graphics.pdf)
- [Three graphics systems](Graphs/Three%20Graphics%20Systems.sas)
- [Finding graphics commands](Graphs/Statistical%20graphics%20examples.sas)
- Twoway Plots
  -   [proc sgplot](Graphs/sgplot%20forbes.sas)
  -   [proc gplot](Graphs/gplot%20forbes.sas)
- [Categorical Charts](Graphs/Statistical%20graphics%20examples.sas)
  -   [proc sgplot](Graphs/sgplot%20pie%20sales.sas)
  -   [proc gchart](Graphs/gchart%20pie%20sales.sas)

## Macros
- [Let (Macro variables)](Macros/M1.sas)
- [Simple Macros](Macros/M2.sas)
- [Macros with parameters](Macros/M3.sas)
- [Macro flow](Macros/M4.sas)

- [Interleaved output](Macros/interleaved%20output%20from%20multiple%20procs.sas)

## Writing SAS Documentation
Some notes on how to write up SAS documentation using Markdown and RMarkdown.
This is primarily geared toward writing web pages and PDF handouts that include SAS code, 
SAS output, and explanatory text.  This same system can be used to produce
simple Word documents.

-   [The SASmarkdown Package](Markdown/index.html)
-   [SAS and R Markdown](Markdown/ch2.html)
-   [Linking SAS Code Blocks](Markdown/ch3.html)
-   [HTML Tables and Graphs](Markdown/ch4.html)
-   [Including SAS Logs](Markdown/ch5.html)
-   [Cleaning Up SAS Log Output](Markdown/ch6.html)
-   [SAS LaTeX tables](Markdown/ch7.html)
-   [SAS National Language Support](Markdown/ch8.html)
-   [Saving intermediate files](Markdown/ch9.html)
-   [spinSAS - Markdown in SAS comments](Markdown/ch10.html)

## Running R from SAS
- [Configuration and Basic Use](SASWindows/RfromSAS.html)

