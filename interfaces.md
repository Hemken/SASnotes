---
title: "Using SAS"
author: "Doug Hemken"
date: today
---

There are several different ways you can work with SAS in the SSCC.

If you are learning to use SAS or beginning to develop code for a 
project, you probably want to work *interactively*
so that you can write, submit, and troubleshoot small blocks of SAS
code.  Start with SAS 9.4 on Winstat.

If you already have your code mostly worked out, if your code
takes a long time to run, or if your code would benefit from more
CPUs or more RAM, you probably want to submit *batch* jobs.
Start with SAS on Linstat.

It is perfectly normal to work both interactively and in batch mode!  Well written
code will work in either mode.

## SAS Platforms

::: {.callout-tip}
## More Power

The easiest way to use more computing power for your SAS work is to switch platforms.
To use the Linux platforms, you only need to write any file paths (e.g. in LIBNAMEs) differently.
:::

The hierarchy of SSCC platforms for SAS is (from least powerful
to most powerful):

| Platform            | Operating System | Default CPU | Default Memory  | Max CPU | Max Memory |
|:-------------------:|:-----------------|------------:|----------------:|--------:|-----------:|
|Winstat              |Windows    |2    |12G   |4     |24G|
|Lab computers        |Windows    |4    |12G   |4     |32G|
|Winstat for Big Jobs |Windows    |12   |90G   |24    |128G|
|Linstat              | Linux     |36   |375G  |36-48 |500G|
|Slurm                | Linux     |36   |375G  |36-128|256-1024G|

## Windows or Linux?

You can work with an interactive interface or in batch mode using
either a Windows computer (Winstat) or a Linux computer (Linstat).
If your program requires a lot of computing power (CPUs or RAM),
you can submit batch jobs to Slurm.

### Windows for Typical SAS jobs
If you are developing your code and your data do not require too much
time to process, it is appropriate to use SAS on a Windows computer,
either [Winstat](https://kb.wisc.edu/sscc/102698) or a [lab computer](https://kb.wisc.edu/sscc/102696).

(video) [Logging on to Winstat](https://mediaspace.wisc.edu/id/1_9fgwdfxz?width=1298&height=802&playerId=25717641)

Winstat for Big Jobs gives you access to substantially more power as well.

### Linux for Big SAS jobs
For SAS jobs that can take advantage of
many CPUs, more memory,
or that take a long time to run, use SAS on a Linux computer - [Linstat](https://sscc.wisc.edu/sscc/pubs/grc/resources.html#linstatlinsilo)
or [Slurm](https://sscc.wisc.edu/sscc/pubs/grc/resources.html#slurmslurmsilo).

(video) [Logging on to Linstat](https://mediaspace.wisc.edu/id/1_rt23kds2?width=1298&height=802&playerId=25717641)

#### Multiple Cores
See [Setting CPUCOUNT](setting_cpucount.html) if you want to use more than the platform default.

#### More Memory
If your data set is 1 GB or more, or if you will be reading data sets many times, 
you can also configure SAS to store data in computer
memory (RAM).  On Linstat, this is as simple as using the WORK directory
for up to 24G of data.  On Winstat, or to go beyond 24G on Linstat,
you can use the SASFILE command to ensure your data is kept in memory.
A little extra set up can greatly speed up your work.
See [Loading Data in Memory](data_in_memory.html).

## Interactive or Batch?
Use SAS interactively to develop your code, and for small tasks.  Use SAS in 
batch mode for time-consuming tasks, or where you do not need to check the
results of each line of code.  SAS can be run in either mode on both Windows
and Linux computers.

### Interactive Interfaces for Development
If you anticipate working interactively in both Windows and Linux
environments, use SAS Studio.

#### SAS Studio

This runs in a web browser, and works the same way on both Windows and Linux computers.
Very similar to "SAS" (see below), but more consistent across operating systems.

[Detailed SAS Studio documentation](https://documentation.sas.com/doc/en/webeditorcdc/3.8/webeditorug/p092daf4a5ypjcn138maiooc8wsn.htm#p1qugkav98pck8n1kh3bmsq5slfa)
    
- Winstat: from the Windows Start menu find **SAS** > **SAS Studio**.

  (video)  [Launching SAS Studio on Winstat](https://mediaspace.wisc.edu/id/1_e89es0nr?width=1298&height=802&playerId=25717641)
    
- Linstat: ***first log on to Winstat***.  Then from the Windows Start menu
  find **Linstat** > **Linstat SAS Studio**.  You need your user name and
  password to log on.
    
<iframe id="kaltura_player" src="https://cdnapisec.kaltura.com/p/1660902/sp/166090200/embedIframeJs/uiconf_id/25717641/partner_id/1660902?iframeembed=true&playerId=kaltura_player&entry_id=1_z5f2ith8&flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en_US&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[Kaltura.addCrossoriginToIframe]=true&amp;&wid=1_5bx8dk5x" width="649" height="401" allowfullscreen webkitallowfullscreen mozAllowFullScreen allow="autoplay *; fullscreen *; encrypted-media *"  frameborder="0" title="Launching SAS Studio Server on Linstat"></iframe>
    
You can also bookmark this in your own web browser.  However, your computer must
be on the SSCC network (see [VPN](https://kb.wisc.edu/sscc/93546)) to use this.
    
      https://ssc.wisc.edu/sas-studio

#### SAS (a.k.a. SAS Display Manager, or DMS)

A dedicated application that is *similar* on both Windows and Linux
computers.  It has more of an old-school look, but on Windows it makes
it easy to open files in a project folder.
    
- Winstat: from the Windows Start menu find **SAS** > **SAS 9.4** (either
    English or Unicode).
    
<iframe id="kaltura_player" src="https://cdnapisec.kaltura.com/p/1660902/sp/166090200/embedIframeJs/uiconf_id/25717641/partner_id/1660902?iframeembed=true&playerId=kaltura_player&entry_id=1_vdklhmfx&flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en_US&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[Kaltura.addCrossoriginToIframe]=true&amp;&wid=1_v25ax3mq" width="649" height="401" allowfullscreen webkitallowfullscreen mozAllowFullScreen allow="autoplay *; fullscreen *; encrypted-media *"  frameborder="0" title="Launching SAS 9.4 on Winstat"></iframe>
    
- Linstat: (**Not recommended for Linux**)
    
  You'll need to be familiar with the very
    old-school Program Editor, capturing ODS listing output, and
    logging off by typing `endsas` in the Command Box.  Use SAS Studio Server, instead - see above.
    
  To use this interface on Linstat, first log on to Linstat via X-Win32.
    Then at the linux command prompt type
    
```bash
linstat> sas &
```

#### Jupyterlab

Jupyter notebooks allow you to put text and code in the same document - useful for
  writing tasks that involve showing both code and output.  Runs in a web browser.
    
- On Winstat (**Not recommended.**), you would have to install the SAS kernel yourself. 
    
- On Linstat, first log on to Linstat with any terminal software.  Then at the linux
    command prompt type
    
  ```bash
  linstat> sscc-jupyterlab
  ```
    
  Copy and paste the URL into a web browser, select the SAS kernel, and being your
  document.  See our guide to [Jupyterlab](https://sscc.wisc.edu/sscc/pubs/grc/programs.html#jupyterlab).
  
  (video) [Launching Jupyterlab, using Linstat from Winstat](https://mediaspace.wisc.edu/id/1_r3x1nih2?width=1298&height=802&playerId=25717641)
    
### Batch Interfaces for Final, Big Runs

#### Winstat

Once logged on to Winstat, open a File Explorer, and navigate to your .sas file.  Right-click on the file,
and pick *Batch Submit with SAS 9.4* from the context menu.  Your output file
will have the same file name, with an .lst file extension, and will be found in
the same folder.
    
<iframe id="kaltura_player" src="https://cdnapisec.kaltura.com/p/1660902/sp/166090200/embedIframeJs/uiconf_id/25717641/partner_id/1660902?iframeembed=true&playerId=kaltura_player&entry_id=1_tpcrn5s3&flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en_US&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[Kaltura.addCrossoriginToIframe]=true&amp;&wid=1_t11z5p9q" width="649" height="401" allowfullscreen webkitallowfullscreen mozAllowFullScreen allow="autoplay *; fullscreen *; encrypted-media *"  frameborder="0" title="SAS Batch Processing on Winstat"></iframe>
    
#### Linstat

Once logged on to Linstat, navigate (`cd`) to the folder with your .sas file.  At the linux command prompt
issue a command like
    
```bash
linstat> sas mysasfile.sas &
```
    
Your output file
will have the same file name as your .sas file, with an .lst file extension, and will be found in
the same folder.
    
<iframe id="kaltura_player" src="https://cdnapisec.kaltura.com/p/1660902/sp/166090200/embedIframeJs/uiconf_id/25717641/partner_id/1660902?iframeembed=true&playerId=kaltura_player&entry_id=1_hug31leu&flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en_US&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[Kaltura.addCrossoriginToIframe]=true&amp;&wid=1_ivs8vrzd" width="649" height="401" allowfullscreen webkitallowfullscreen mozAllowFullScreen allow="autoplay *; fullscreen *; encrypted-media *"  frameborder="0" title="SAS Batch Processing on Linstat"></iframe>

#### Slurm

Many of the SSCC's Linux servers are only available through [Slurm](https://sscc.wisc.edu/sscc/pubs/grc/slurm.html).  These servers provide even more power,
but are only suitable for batch processing.

Access Slurm by first logging on to Linstat.  Navigate (`cd`) to the folder with your .sas file.  At the linux command prompt
issue a command like
    
```bash
linstat> ssubmit --cores=C --mem=Mg "sas my_sas_program.sas"
```
Where `C` is the number of cores you want to use and `M` is the amount of memory you want to use.

If you need more than 36 cores or 375G of memory, you will also need to specify these options in
your SAS command.  For example, to use 45 cores and 500G of memory you would use

```bash
linstat> ssubmit --cores=45 --mem=500g "sas -cpucount 45 -memsize 500g my_sas_program.sas"
```

Your output file
will have the same file name as your .sas file, with an .lst file extension, and will be found in
the same folder.  You will also have a Slurm log file, and you will receive an email
when your job finishes.