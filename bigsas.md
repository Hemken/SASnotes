# Using Large SAS Data Sets with Linstat/Slurm

Linstat and Slurm are capable of running the vast majority of SAS jobs without any
difficulties. However, if you run SAS scripts that use extremely large
data sets (> 10 GB or so) or do a lot of reading and writing of data sets, you need to
understand where SAS stores your data sets and where to run your
programs so that they get the resources they need.

Where you store a data set determines:

- whether a SAS data set is [temporary (WORK) or permanent (any other library)](saveSASdata.html)
- how much space is available for storage
- how quickly SAS can process the data

:::{.callout-tip}
If finding enough room for your SAS data is more urgent than processing
speed, you can also work with [compressed SAS data](4-11_SAS_Compressed_Data.html)

See also [SAS Programming Efficiencies](4-3_SAS_Efficiencies.html) for suggestions on how to reduce
the size of your data sets.
:::

## Where SAS Stores Files

On Linstat (and Slurm), SAS can put files in four types of storage:

- /ramdisk (WORK)
- /tmp
- network drives - /home, /project, or /researchdrive
- SASfiles

:::{.callout-important}
The SSCC plans to eliminate /ramdisk in favor of /tmp in January 2025
:::

### /ramdisk

Linstat allows programs to use up to 32GB of computer memory (RAM) as if it were disk
space in a directory called `/ramdisk`. This space is much
faster than real disk space. SAS on Linstat is configured to use
`/ramdisk` as its default WORK library, where all temporary
data sets are stored. Files in `/ramdisk` that are not in
use will be deleted after three hours.

`/ramdisk` is shared with other users on the same server.  To see
how much space is currently available, use the `df` command at a
Linstat command line.

```bash
linstat> df -h /tmp
```
The result will typically look like:
```
Filesystem      Size  Used Avail Use% Mounted on
tmpfs            32G     0   32G   0% /ramdisk
```

### /tmp

The `/tmp` directory is a directory on each server's local
hard drive. On our current Linstat servers, this provides about the same
access speed as `/ramdisk`! Each Linstat has about 300GB of space in
`/tmp`.  Like `/ramdisk`, this is shared space.  To see how much is
actually available on the server you are using, use the `df` command at a
Linstat command line.

```bash
linstat> df -h /tmp
```
The result will typically look like:
```
Filesystem                  Size  Used Avail Use% Mounted on
/dev/mapper/almalinux-_tmp  313G   41G  273G  13% /tmp
```

#### Use /tmp in addition to WORK
If you are running out of space using WORK, you can define a 
SAS library that accesses `/tmp`.  Either define a "permanent" 
(in SAS terms) library and use it instead of WORK, or
redirect the WORK library itself.

```sas
libname t "/tmp";
```

A benefit if defining your own `/tmp` library and using it in place of WORK
is that SAS continues to use WORK for it's own temporary files - you
can effectively use the space in both locations.

And of course you should **not** put SAS data in `/tmp` that you expect
to use in a later SAS session (it's not really permanent, and you might
be on a different server the next time you log in)!

If you use `/tmp` for temporary data sets (without using it for the
WORK library), please remember to delete those data sets with
PROC DATASETS, e.g.

```sas
proc datasets lib=t;
    delete mydata1 mydata2 mydata3;
    run;
```

#### Use /tmp to replace WORK
If SAS does not have
enough room in WORK for it's own temporary files, then you **must**
redirect WORK.  (This often comes up when SORTing data - use TAGSORT.)
You can redirect WORK by specifying a `-WORK` option
on the command line when working in batch mode:

```bash
linstat> sas -work '/tmp' myprog.sas &;
```

To redirect WORK with SAS Studio, place this option in a
configuration file named `sasv9.cfg` in your home directory.
Your file will simply include
the line

```
-work '/tmp'
```

Note there is no semi-colon.  **This file must have Unix line-feeds** or
SAS gives you a "kernel initialization" error.  (Use VS Code or Notepad++
to create this file - the line-feed (CRLF or LF) option is in the bottom
status bar.)


### Network Disk Space

Permanent data sets are generally stored in network disk space, such as
`/home`, `/project`, and `/researchdrive` directories. Project and ResearchDrive
directories can be very large (up to 25 TB) but they are much slower than
`/tmp` and `/ramdisk`.  You access these by defining and using LIBNAMEs.

### SASfiles

SAS also has the ability to store a **copy** of a data set directly
in computer memory.  On Linstat there is up to 375GB of memory that
SAS can use.  This is useful in the case where your program will
read the same large data set multiple times (for example, to use
in multiple PROCs).

:::{.callout-tip}
Note that you still need disk storage space for the original
copy of the data set.  SASfiles can reduce the time it takes your
program to run, but they do not reduce the amount of storage space
you need.
:::

A global `SASFILE` statement  points to an already-existing SAS
data set.  The `OPEN` option causes it to be stored in computer
memory the next time it is read.  A `CLOSE` option frees up the
memory that was occupied.

```sas
libname proj '/project/example';
sasfile proj.mydata open;

proc means data=proj.mydata;
run;

proc glm data=proj.mydata;
  class treatment;
  model y = treatment x1 x2;
  run; quit;

sasfile proj.mydata close;
```

In this example, the data is actually loaded into memory when the
PROC MEANS is run.  The PROC GLM then reads the same data from memory.
The final SASFILE statement frees up memory.

See the [SASFILE documentation](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lestmtsglobal/n0osyhi338pfaan1plin9ioilduk.htm)
for more details.

## Making Programs Run Faster

Since permanent data sets are written to the (relatively slow) network
and temporary data sets are written (by default on Linstat) to
`/ramdisk`, using temporary data sets whenever a data set is
used in more than one program step can
dramatically improve the performance of programs that use large data
sets.

### Slower
Consider the following SAS program:

```sas
libname proj '/project/example';
data proj.intermediate;
  set proj.mydata;
  *...various commands...;
run;

data proj.finaldata;
  set proj.intermediate;
  * ...more commands...;
run;
```

Since all of the data sets are permanent data sets, all of the disk
I/O generated by this program goes to the network.

### Faster

```sas
libname proj '/project/example';
data intermediate;
  set proj.mydata;
  *...various commands...;
run;

data proj.finaldata;
  set intermediate;
  * ...more commands...;
run;
```

`intermediate` is now temporary and stored in the WORK library
(`/ramdisk`), which makes reading and writing it much faster.
The more steps you have between reading your initial input and writing
your final output the more time you will save by making the intermediate
data sets temporary.

### Avoid Single-Use Copies
Don't use a DATA step to make a copy of a data set you only use once. Consider
this construction:

```sas
data mydata;
  set proj.mydata;
run;

proc means data=mydata;
run;
```

While this makes a fast-access copy of `mydata`, the data is processed twice.
In this case it is more efficient to just read the data once.

```sas
proc means data=proj.mydata;
run;
```

As a bonus, your programs will also be easier to read.

## Preventing Programs from Running Out of Space

The vast majority of SAS programs require much less than the 32GB of
space available in `/ramdisk` on Linstat. If your program
requires more, here are your options:


|Storage Space Required | location                        |
|----------------------|----------------------------------|
|<32GB                 | /ramdisk                         |
|<300GB                | /tmp                    ([1](#1))|
|>300GB                | /project/myproject      ([2](#2))|


[]{#1}(1) These jobs may slow down the server they run on. If they can
be run at night, please do so.

[]{#2}(2) Any job that needs to write this much data to the network will
be extremely slow. You would be well advised to spend time making sure
your code is as efficient as possible before running such programs.

**You may use all of these locations in the same SAS script.**  Keep
in mind that SAS requires space for it's own temporary files in
the WORK directory - you won't be able to use the whole space for
your data files.

You can see how big a file is (once it has been created) by
using `PROC CONTENTS` and looking at the Engine/Host section.
Look for "File Size".

```sas
ods select enginehost;
proc contents data=proj.mydata;
run;
```

Be sure to delete any "temporary" data sets you create in
`/tmp` at the end of your program
using `proc datasets`.

```sas
proc datasets lib=t;
  delete intermediate;
  run; quit;
```

Last Revised: 9/12/2024
