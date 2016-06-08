/*<pre><b>
/ Program   : varlist.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30-Jul-2007
/ Purpose   : Function-style macro to return a list of variables in a dataset
/ SubMacros : none
/ Notes     : Variable names will be in uppercase.
/ Usage     : %let varlist=%varlist(dsname);
/ 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  13Feb07         "macro called" message added
/ rrb  30Jul07         Header tidy
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: varlist v1.0;

%macro varlist(ds);

%local dsid rc nvars i varlist;

%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (varlist) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
  %let nvars=%sysfunc(attrn(&dsid,nvars));
  %if &nvars LT 1 %then %put ERROR: (varlist) No variables in dataset &ds;
  %else %do;
    %do i=1 %to &nvars;
      %if %length(&varlist) EQ 0 %then %let varlist=%sysfunc(varname(&dsid,&i));
      %else %let varlist=&varlist %sysfunc(varname(&dsid,&i));
    %end;
  %end;
  %let rc=%sysfunc(close(&dsid));
%end;
&varlist
%mend;
