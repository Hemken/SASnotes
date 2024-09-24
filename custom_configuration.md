# Customizing SAS
Like most statistical software, you can customize your SAS
sessions for your particular work flow. There are generally 
two places you can put code to customize
your SAS sessions:  *configuration* files, and *autoexec* files.

- **Autoexec files** enable you to run *any* SAS code, just as if it
was the first part of your program, including most system
settings.

- **Configuration files** enable you to customize SAS system settings,
the sorts of things you might specify with an `OPTIONS` statement
or a [command line](7-4_SAS_command_line.html) option.

SAS uses configuration files as it first starts up, and then
also uses an autoexec file if it finds one.  Whatever is specified
***last*** is what has effect.

:::{.callout-tip}
If you are not sure which to use, an autoexec file is probably
the easiest to implement.
:::

See the [SAS documentation](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostunx/p13flc1vsrqwr8n1vutzds8rp3t0.htm)
for more details.

> ### Archive Your Customizations
> Session customizations may save you a lot of typing and clutter in your code.
However, they also have the potential to make your code
less portable - if you move to a new computing platform, or
someone else tries to use an archived version of your work,
your customizations might be necessary to reproduce your
results.  Be sure to include them when you archive your work.

## Autoexec Files
To set up code that you want to run at the beginning of every SAS session,
put it in a file named `autoexec.sas`.  Any code that is repeated 
at the top of every program file in a folder would
be appropriate to put in an autoexec file.
A typical use of an autoexec file
would be to define `LIBNAME`s that are shared across several programs files.

```
---- autoexec.sas ----
libname u "U:/dissertation/data";
libname x "X:/project";
options dmssynchk varinitchk=error;
----------------------
```

SAS searches for this file in several places - exactly where SAS will
search is different on [Linux](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostunx/p13flc1vsrqwr8n1vutzds8rp3t0.htm#p1ehc1znix6r96n1pxs9ie7c3941) 
versus [Windows](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostwin/p0bmj7wjme32ayn1h4wim7trkhp6.htm#p0ceb6r7y2mkdsn1lc2ice1mx1dc) computers.  On both platforms, the first place that SAS searches is the folder
in which SAS starts, and the first autoexec file that SAS finds is the one that it uses.

### Linstat
- Using Linstat in batch mode, SAS first searches the folder where your program file is located.
- Using SAS Studio on Linstat, SAS first searches your home folder, e.g. something of the form `/home/h/hemken`

  :::{.callout-tip}
  ## SAS Studio working directory
  SAS Studio on Linstat has a default working directory that you cannot write to.
  Changing the default working directory will make it simpler to write code that
  reads from or writes to text files.
  
  Use this form in an autoexec.sas file:
  
  ```
  ---- autoexec.sas ----
  DATA _NULL_;
    RC=DLGCDIR('/home/h/hemken');
    RUN;
  ----------------------
  ```
  :::

### Winstat
- Launching files from the File Explorer on Winstat, SAS searches the folder where your program file is located.
- Launching SAS from the Windows Start menu, SAS searches your "U:/" drive.

## Configuration Files
Configuration files can only be used to set SAS system options.  While most of these could be
set in an autoexec file, there are a few settings that are best handled in a configuration
file:  redirecting the WORK library and memory settings can be specified only here or on the command line, and language settings
are often easiest to set in this way.

SAS requires one or more configuration files to start up.  The first configuration file should be a
default SAS configuration file.  The SSCC provides a second configuration that sets things like the
`memsize`, `cpucount`, and the location of the `work` directory for each of our computing
platforms.  Any configuration file you set up should come third.

As with autoexec files, the details of where SAS searches for configuration files is different
on [Linux](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostunx/p13flc1vsrqwr8n1vutzds8rp3t0.htm#p1gwe1epwyr4iin0zh749k4csrzx) 
versus [Windows](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/hostwin/p0bmj7wjme32ayn1h4wim7trkhp6.htm#n0z0mc6z54d2fgn1wzfdnj3uizzw).

### Linstat
On Linstat, put your configuration options in a file named `sasv9.cfg`.

- Using Linstat in batch mode, this file typically goes in the folder where your program file is located.
- Using SAS Studio on Linstat, this goes in your home folder, e.g. something of the form `/home/h/hemken`

:::{.callout-warning}
On Linstat, the sasv9.cfg file **must** have Unix LF line endings (not Windows CRLF).  You can create
this file on a Windows computer if you use software such as VS Code or Notepad++ that can change the
line endings.  (The bottom status bar in both programs has this option.)
:::

#### Redirecting WORK
For example, if you routinely work with data files that are too big for the default `WORK`
library, you might redirect the library to the `/tmp` folder, putting this file in your project folder:

```
---- sasv9.cfg ----
-WORK /tmp
-------------------
```

#### Use Another Language
If you wanted to work with data in a non-Western language (including UTF-8), or produce results in another
language, your configuration file could call one of the many language configurations that SAS supplies.
For example, to produce output in French, use:

```
---- sasv9.cfg ----
-CONFIG /software/sas/SASFoundation/9.4/nls/fr/sasv9.cfg
-------------------
```

### Winstat
Setting up your own configuration file on Windows is a little trickier.  SAS can use
multiple -CONFIG options when launched from a command line, but most of us don't work
that way because it requires so much typing - see the example below.

The easiest approach is to make a new SAS launch program icon on your desktop, and modify
the Target property as described in the documentation linked above.  (Or, switch
to a Linux computer!)

- In the Windows Start menu, find the SAS 9.4 (English) icon.  Right click,
and on the context menu pick **More > Open file location**.
- Copy the icon file to your Desktop.
- Using the SAS icon you copied to your Desktop, right click, and select **Properties**
- Edit the **Target** field (most of which is hidden from view at any given moment).  Your
modified Target should point to at least two CONFIG files:  a default language file, and the
SSCC configuration file.  If you add your own file, it should be the ***third*** CONFIG option.
(If you just want to change the language, you can use an alternative SAS language file as 
the first config file.)

  For example, to enable SAS to process data encoded in double-byte character sets, and also
  add your own sasv9.cfg configuration file, the Target would be (all on one line):

  ```
  "C:\Program Files\SASHome\SASFoundation\9.4\sas.exe"
    -CONFIG "C:\Program Files\SASHome\SASFoundation\9.4\nls\1d\sasv9.cfg"
    -config "C:\Program Files\SASHome\SASFoundation\9.4\sscc_sas.cfg"
    -config "U:/dissertation/sasv9.cfg"
  ```
