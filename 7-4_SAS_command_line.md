# The SAS Command Line

Typing "sas" on an operating system command line is generally used
to launch SAS in batch mode, running an entire script without
input or interruption and producing a log and an output ("list")
file.  This is most often used on the Linstats and for Slurm
(see below for a discussion of the Windows command line).

It's a great way to run a time-consuming script, or to generate
output for archiving a project.

## Linux: SAS Batch Jobs 

A SAS batch job can be invoked simply by typing

```bash
> sas filename &
```

where *filename* is the name of your SAS program file.

The ampersand ("&") is important to make this a *background* job - 
otherwise your terminal is tied up until SAS is finished processing.
[See the SAS documentation](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostunx/n0x9esc5c95qg4n1wogx5u2k7354.htm#n1i0v54m20z7z0n1lc2tpdx5zbua)
for further explanation.

### Command Line Options
There are numerous system configuration options that can be
invoked when you start any SAS session, including batch jobs.

They use the general form:

```bash
> sas -option1 -option2 ... filename &
```

(The filename can also come first.)

There are a huge number of [SAS sytem options](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/p1tmgku1vq7pwqn1iqioeflxgec1.htm).

Some useful options include:

### Output Options
- `-linesize n`, where *n* is an integer $64 \leq n \leq 256$. This specifies the line size of the SAS listing and log output.
  The default varies depending on the operating system and execution mode (batch or interactive).

  ```bash
  > sas -linesize 90 example.sas &
  ```
  ::: {.callout-tip}
  Make this wide enough that tables don't wrap.
  :::
- `-pagesize n`, where *n* is an integer $15 \leq n \leq 32,767$.  This specifies the number of lines that can be placed in a
page of SAS output. The default varies depending on the operating system and execution mode.

  ```bash
  > sas -pagesize max example.sas &
  ```
  ::: {.callout-tip}
  Suppress page breaks by setting this to the maximum value.
  :::

### Debugging Options
It is sometimes useful to send the log and the output to files with
alternative names, especially when you are trying to compare your
results across slightly different runs, like when you are debugging.

- `-log logfilename` where *logfilename* specifies the name of the file to
use as a log. By default, the SAS log is written to the file *filename*.log
when *filename* is the name of the file containing the SAS commands.

  ```bash
  > sas example.sas -log newfile.log &
  ```
  sends log output to "newfile.log" instead of "example.log".

- `-print outfile` where *outfile* specifies the name of the file
used for procedure output.
By default, the SAS output is written to the file *filename*.lst where
*filename* is the name of the file containing the SAS commands.

  ```bash
  > sas example.sas -print output.lst &
  ```
  sends procedure output to "output.lst" instead of "example.lst".

### Power Options
::: {.callout-tip}
The easiest way to use more computing power for your SAS work is to [switch platforms](interfaces.html#sas-platforms).
:::

- `-obs n` specifies the last observation from SAS data sets is read.
Especially useful when you are debugging code with a gigantic data set.

These options are occasionally useful for Slurm submissions:

- `-cpucount n`, where *n* specifies how many CPUs SAS should use
(for procedures that can use multiple cpus).  See the link above
for guidelines.

- `-memsize nG`, where *n* specifies the gigabytes of memory available to SAS.
  See the link above for guidelines.

### No Options

If you accidentally type

```bash
> sas
```
this invokes the interactive SAS
Windowing Environment.  You are better off
using  SAS Studio.  See [Using SAS](interfaces.html#sas-studio)

To exit the Linux SAS Windowing Environment and close the plethora of
SAS windows, issue the command

```sas
endsas;
```

either in the Program Editor window, or the Command window.

## Windows
Using SAS from a command line is more tricky on a Windows computer.
The SSCC has not placed SAS on the PATH environment variable, so
you have to type the full path for the SAS executable in a Command
window or a terminal.  You will have to quote the executable path,
because it contains a space.

```bash
> 'C:/Program Files/SASHome/SASFoundation/9.4/sas.exe' -linesize 90 -pagesize max example.sas
```

Note that you can also submit a
[batch job from the Windows File Explorer](https://users.ssc.wisc.edu/~hemken/SASworkshops/sas_windows_launch.html#program-files)
- however, the
limitation is that you will not be able to add command line options.  Instead, specify
options within your script.

::: {.callout-tip}
### Options in Command Files
Most SAS options can be invoked from *within a SAS command file*.  We generally recommend this approach
on Windows computers, rather than trying to type long operating system file paths.

```sas
options linesize=90 pagesize=max;
```

:::

Last Revised: 9/15/2024
