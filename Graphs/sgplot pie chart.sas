
/*----------------------------------------------------------------------------------------*/
/*  Macro for GTL Pie Chart                                                              */
/*  Author:  Sanjay Matange, SAS                                                          */
/*  Date:    May 15, 2011                                                                 */
/*  History: 8/22/2012/SNM - Initial                                                      */
/*                                                                                        */
/*----------------------------------------------------------------------------------------*/
%macro GTLPieChartMacro (
       Data=,    	               /*--Data Set Name (Required)--*/
       Category=,                  /*--Category Variable - Required--*/ 
	   Response=,                  /*--Response Variable - Optional)--*/ 
	   Group=,                     /*--Group Variable - Optional)--*/ 
	   CategoryLabel=True,         /*--Include category value in slice label--*/
	   ResponseLabel=True,         /*--Include response value in slice label--*/
	   PercentLabel=False,         /*--Include percent value in slice label--*/
	   Legend=False,               /*--Display Legend--*/
	   StartAngle=0,               /*--Angle in degrees from East--*/
	   DataLabelLocation=Auto,     /*--Data label location for slices--*/
	   Direction=CounterClockWise, /*--Pie Slices drawing direction--*/
	   DataSkin=Sheen,             /*--Default data skin--*/
	   GroupGap=0,                 /*--Gap between group rings--*/
	   OtherSlice=True,            /*--Group small values in one slice labeled "Other"--*/
           GroupLabelFontSize=7,       /*--Footnote Font Size--*/
	   DataLabelFontSize=8,        /*--Footnote Font Size--*/
           FootnoteFontSize=10,        /*--Footnote Font Size--*/
	   TitleFontSize=12,           /*--Title Font Size--*/
           SubtitleFontSize=10,        /*--Subtitle Font Size--*/  
	   Footnote=,                  /*--Graph Footnote--*/
	   Footnote2=,                 /*--Graph Footnote--*/
	   Footnote3=,                 /*--Graph Footnote--*/
	   Title=,                     /*--Graph title2--*/
	   SubTitle=,                  /*--Graph Title--*/ 
	   Format=                     /*--Format String--*/ 
);

%local  NumCat Cat Resp Pct ResVar GroupVar;

/*--Data set is required--*/
%if %length(&Data) eq 0 %then %do;
%put The parameter 'Data' is required - GTLPieChart Macro Terminated.;
%goto finished;
%end;

/*--Category is required--*/
%if %length(&Category) eq 0 %then %do;
%put The parameter 'Category' is required - GTLPieChart Macro Terminated.;
%goto finished;
%end;

/*--Response is optional--*/
%if %length(&Response) eq 0 %then %do;
  %let resvar=__not_assigned__;
%end;
%else %let resvar=&Response;

/*--Group is optional--*/
%if %length(&Group) eq 0 %then %do;
  %let groupvar=__not_assigned__;
%end;
%else %let groupvar=&Group;

/*--Generate the DataLabelContent option--*/
%let Content=DataLabelContent=none;

%if %length(&CategoryLabel) ne 0 and %upcase(&CategoryLabel) eq TRUE %then
  %let cat=category;
%else %let cat=;


%if %length(&ResponseLabel) ne 0 and %upcase(&ResponseLabel) eq TRUE %then
  %let resp=response;
%else %let resp=;


%if %length(&PercentLabel) ne 0 and %upcase(&PercentLabel) eq TRUE %then 
  %let pct=percent;
%else %let pct=;


%if %length(&cat) or %length(&resp) or %length(&pct) %then %do;
  %let content=DataLabelContent=(&cat &resp &pct); 
%end;

/*-Add code to align a 2-slice pie vertically--*/


/*--Define template--*/
proc template;
  define statgraph GTLPieChart;
    begingraph;
      entrytitle "&title" / textattrs=(size=&TitleFontSize);
	  entryTitle halign=left "&subtitle" / textattrs=(size=&SubtitleFontSize);
      entryfootnote halign=left "&footnote" / textattrs=(size=&FootnoteFontSize);
      entryfootnote halign=left "&footnote2" / textattrs=(size=&FootnoteFontSize);
	  entryfootnote halign=left "&footnote3" / textattrs=(size=&FootnoteFontSize);

      /*--Draw individual scatter plots in first row if needed--*/
      layout region;
          piechart category=&category response=&resvar / group=&groupvar name='a' 
            dataskin=&dataskin start=&startangle groupgap=&groupgap
            datalabelattrs=(size=&datalabelfontsize) &content otherslice=&otherslice;
		  %if %length(&Legend) ne 0 and %upcase(&Legend) eq TRUE %then %do;
            discretelegend 'a';
		  %end;
	  endlayout;
	endgraph;
  end;
run;

/*--Render the graph--*/
proc sgrender data=&data template=GTLPieChart;
%if %length(&Format) ne 0  %then %do;
&format;
%end;
run;

%finished:
%mend GTLPieChartMacro;

/*------------------End of Macro Definition-------------------------*/

ods html close;
%let gpath='C:\';
%let macroLoc=C:\;
%let dpi=200;
ods listing style=listing gpath=&gpath image_dpi=&dpi;

options sasautos=("&macroLoc", sasautos);
options mautosource mprint mlogic;

proc format;
  value $sex
    'M'='Male'
    'F'='Female';
run;

/*--Freq Pie Chart--*/
*ods graphics / reset width=3in height=3.5in imagename='BasicPieChartSheen';
%GTLPieChartMacro(data=sashelp.class, category=sex,
         title=Class Size by Sex/*, 
         format=format sex $sex.*/);

/*--Percent Pie Chart--*/
*ods graphics / reset width=3in height=3.5in imagename='BasicPieChartGloss';
%GTLPieChartMacro(data=sashelp.class, category=sex, startangle=355,
         title=Class Size by Sex, ResponseLabel=false, Percentlabel=true, 
         legend=false,
         format=format sex $sex.);

/*--Pie Chart of Actual by Product--*/
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='PieChartRespGloss';
%GTLPieChartMacro(data=sashelp.prdsale, category=product, response=actual, 
         dataskin=gloss, title=Actual Sales by Product, 
         footnote=Data Set: SAShelp.prdsale,
         footnotefontsize=6);

/*--Grouped Pie Chart--*/
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='GroupedPieChartRespGloss';
%GTLPieChartMacro(data=sashelp.prdsale, category=product, response=actual, group=year, 
         dataskin=gloss, title=Actual Sales by Product and Year, 
         footnote=Data Set: SAShelp.prdsale,
         footnotefontsize=9, datalabelfontsize=7);

/*--Grouped Pie Chart Gap--*/
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='GroupedPieChartGapGloss';
%GTLPieChartMacro(data=sashelp.prdsale, category=product, response=actual, group=year, 
         dataskin=gloss, groupgap=10, title=Actual Sales by Product and Year, 
         footnote=Data Set: SAShelp.prdsale,
         footnotefontsize=9, datalabelfontsize=6);

/*--Other Slice Pie Chart--*/
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='OtherSlice';
%GTLPieChartMacro(data=sashelp.cars, category=make,
         dataskin=gloss, groupgap=10, title=Share of Market by Make, 
         footnote=Data Set: SAShelp.prdsale, responselabel=false, percentlabel=true,
         footnotefontsize=9, datalabelfontsize=6);

/*--No Other Slice Pie Chart--*/
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='NoOtherSlice';
%GTLPieChartMacro(data=sashelp.cars, category=make,
         dataskin=gloss, groupgap=10, title=Share of Market by Make, 
         footnote=Data Set: SAShelp.prdsale, responselabel=false, percentlabel=true,
         footnotefontsize=9, datalabelfontsize=6, otherslice=false);

proc sort data=sashelp.cars out=CarsByOrigin;
  by origin;
  run;

/*--Share of Sedans--*/
data GTL_Sedans;
  retain Sedans 0 Rest 0;
  format count percent5.0;
  keep Origin Type Count;
  set CarsByOrigin nobs=totalcount;
  by origin;

  if first.origin then do; Sedans=0; Rest=0; end;

  if type eq 'Sedan' then Sedans+1;
  else  Rest+1;
  if last.origin then do;
    Type='Sedans'; Count=Sedans/totalcount; output;
	Type='Rest';   Count=Rest/totalcount;   output;
  end;
  run;

/*--Two Slice pie Chart w/o start angle--*/
ods listing style=analysis;
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='SedanShare';
%GTLPieChartMacro(data=GTL_Sedans, category=type, response=count,
         title=Share of Market for Sedans,
         DataLabelFontSize=12,
         responselabel=true, percentlabel=false);

/*--Two Slice pie Chart--*/
ods listing style=analysis;
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='SedanShareVert';
%GTLPieChartMacro(data=GTL_Sedans, category=type, response=count,
         title=Share of Market for Sedans, startangle=340,
         DataLabelFontSize=12,
         responselabel=true, percentlabel=false);

/*--Share of SUVs--*/
data GTL_SUVs;
  retain SUVs 0 Rest 0;
  format count percent5.0;
  keep Origin Type Count;
  set CarsByOrigin nobs=totalcount;
  by origin;

  if first.origin then do; SUVs=0; Rest=0; end;

  if type eq 'SUV' then SUVs+1;
  else  Rest+1;
  if last.origin then do;
    Type='SUV'; Count=SUVs/totalcount; output;
	Type='Rest';   Count=Rest/totalcount;   output;
  end;
  run;

/*--Two Slice Pie Chart with horizonal alignment--*/
ods listing style=analysis;
ods graphics / reset width=3in height=3.5in antialiasmax=1500 imagename='SUVShareHorz';
%GTLPieChartMacro(data=GTL_SUVs, category=type, response=count,
         title=Share of Market for SUVs, startangle=335,
         DataLabelFontSize=12,
         responselabel=true, percentlabel=false);


