*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset 1 Name] NBA East 2016-17

[Experimental Units] Contains players stats for 2016-17 NBA Season from the 
Eastern Conference

[Number of Observations] 256

[Number of Features] 29

[Data Source] https://stats.nba.com/players/traditional/?PerMode=Totals&sort=PTS&dir=-1&Season=2016 17&SeasonType=Regular%20Season&Conference=East

[Data Dictionary] http://stats.nba.com/players

[Unique ID Schema] The column “Teams” is a primary key

--

[Dataset 2 Name] NBA West 2016-17

[Experimental Units] Contains players stats for 2016-17 NBA Season from the 
Western Conference

[Number of Observations] 256

[Number of Features] 29

[Data Source] https://stats.nba.com/players/traditional/?PerMode=Totals&sort=PTS&dir=-1&Season=2016-17&SeasonType=Regular%20Season&Conference=West

[Data Dictionary] http://stats.nba.com/players

[Unique ID Schema] The column “Players” is a primary key

--

[Dataset 3 Name] NBA Advanced 2016-17

[Experimental Units] Contains advanced players stats for 2016-17 NBA Season 
from both the Eastern and Western Conference

[Number of Observations] 486

[Number of Features] 22

[Data Source] http://stats.nba.com/players/advanced/?sort=GP&dir=-1&Season=2016-17&SeasonType=Regular%20Season

[Data Dictionary] http://stats.nba.com/players/advanced

[Unique ID Schema] The column “Players” is a primary key
--
;


* environmental setup;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-6_project2/blob/project02/data/East_16-17.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = East_16-17_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-6_project2/blob/project02/data/West_16-17.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = West_16-17_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-6_project2/blob/project02/data/Advanced_2016-17.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = Advanced_2016-17_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)
;


* sort and check raw datasets for duplicates with respect to their unique ids,
removing blank rows, if needed
;
proc sort
        nodupkey
        data=East_16-17_raw
        dupout=East_16-17_raw_dups
        out=East_16-17_raw_sorted
    ;
    by
       Player
    ;
run;
proc sort
        nodupkey
        data=West_16-17_raw
        dupout=West_16-17_raw_dups
        out=West_16-17_raw_sorted
    ;
    by
        Player
    ;
run;
proc sort
        nodupkey
        data=Advanced_16-17_raw
        dupout=Advanced_16-17_raw_dups
        out=Advanced_16-17_raw_sorted
    ;
    by
        Player
    ;
run;


* combine East_16-17 data and West_16-17 data vertically
;
data East_West_Anlaytic_file;
   set
        East_16-17_raw_sorted(in=East_row)
        West_16-17_raw_sorted(in=West_row)
    ;
   retain
        TEAM
        AGE
        GP
        W
        L
        MIN
        PTS
        FGM
        FGA
        FG%
        3PM
        3PA
        3P%
        FTM
        FTA
        FT%
        OREB
        DREB
        REB
        AST
        TOV
        STL
        BLK
        PF
        FP
        DD2
        TD3
        +/-
   by
        Player
  if
      East_row=1
  then
      do;
          data_source=East_16-17_raw_sorted;
      end;
  else
      do;
          data_source=West_16-17_raw_sorted;
      end;
run;


* build analytic dataset from raw datasets with the least number of columns  
and minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files
;
data advanced_data_analytic_file;
    retain
	PLAYER
        TEAM
        AGE
        GP
        W
        L
        MIN
        OFFRTG
        DEFRTG
        NETRTG
        AST%
        AST/TO
        AST Ratio
        OREB%
        DREB%
        REB%
        TO Ratio
        eFG%
        TS%
        USG%
        PACE
        PIE
    ;
    keep
        TEAM
        AGE
        GP
        W
        L
        MIN
        OFFRTG
        DEFRTG
        NETRTG
        AST%
        AST/TO
        AST Ratio
        OREB%
        DREB%
        REB%
        TO Ratio
        eFG%
        TS%
        USG%
        PACE
        PIE
    ;
    merge
        East_West_Analytic_file
      	Advanced_16-17 
    ;
    by
        Player
	;
run;
