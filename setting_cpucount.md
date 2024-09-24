# How to set SAS CPUCOUNT

To increase the number of CPUs available to SAS for processing, you
can simply include an OPTIONS statement in your SAS code.

```default
options cpucount=actual;
```

It would be common to put that near the top of your command file along
with other global statements like LIBNAME or FILENAME.

See the [SAS documentation](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lesysoptsref/p14arc7flhenwqn1v1gipt9e49om.htm) for more details and options.

## Maximizing Processing Power

::: {.callout-tip}
## More Power

***The easiest way to use more computing power for your SAS work is to change
computing platforms.***
:::

 **Maximum CPU Requests**
 
| Platform             | Operating System | default | max    |
|:--------------------:|:----------------:|--------:|-------:|
| Winstat              |  Windows         |  2      | 4      |
| Lab computers        |  Windows         |  4      | 12     |
| Winstat for Big Jobs |  Windows         | 12      | 24     |
| Linstat              |  Linux           | 36      | 36-48  |
| Slurm                |  Linux           | 36      | 36-128 |


Only some SAS procedures can take advantage of multiple CPUs to speed up their work.
If you are using 

- `proc means` or `proc sort` with large data sets,
- `proc glm` or `proc mixed` with many variables, 
- or any of the `hp` procs (see the [SAS documentation](https://documentation.sas.com/doc/en/lrcon/9.4/n0czb9vxe72693n1lom0qmns6zlj.htm))

on Winstat or a lab computer, and your procedure takes more than a minute to run,
this could be a good task for multiple CPUs.

Moving to Winstat-for-Big-Jobs enables your SAS job to use 12 CPUs, while moving to Linstat enables your
SAS job to use 36 CPUs.  **All you need to do is move your work to a different platform!**

## CPUCOUNT and Slurm

The default SAS CPUCOUNT is 36 cores in Slurm (just like Linstat).

Jobs [submitted to Slurm](https://sscc.wisc.edu/sscc/pubs/grc/slurm.html#submitting-jobs) can use up to 128 cores.
(See the Slurm [cluster specifications](https://sscc.wisc.edu/sscc/pubs/grc/slurm.html#cluster-specifications) for
more details.)

To use more than 36 cores for a SAS job submitted to Slurm, we need to harmonize two settings:

- the number of cores requested of Slurm (the default is just 1!)
- the number of CPUs (cores) requested for SAS

SAS will use the minimum of the Slurm cores request and the SAS CPUCOUNT setting.

### Slurm cores

*Omitting this options means SAS will be limited to one (1) core!*

To specify that Slurm make more cores available, your `ssubmit` command will look like

```bash
ssubmit --cores=N "sas myjob.sas"
```

where *N* is any number of cores up through 128.  In this case, SAS will use either *N*
or 36 cores, whichever is less.

### SAS cpus

To enable SAS to use more than 36 CPUs, you need to specify the CPUCOUNT option, either
within your SAS program, **or** as a command line option.

- In the SAS command line use

  ```bash
  ssubmit --cores=64 "sas -cpucount actual myjob.sas"
  ```
- **Or** within a SAS program 
  
  In your SAS program include an `options` statement
  
  ```sas
  options cpucount=actual;
  
  proc glm data=bigdata;
    class nation;
    model freedom = nation gdp politics year;
    run;
  ```
  
  Then your Slurm request simplifies to
  
  ```bash
  ssubmit --cores=64 "sas myjob.sas"
  ```

Last Revised: 09/09/2024