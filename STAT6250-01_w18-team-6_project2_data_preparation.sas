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

[Data Source] https://stats.nba.com/players/traditional/?PerMode=Totals&sort=PTS&dir=-1&Season=2016
17&SeasonType=Regular%20Season&Conference=East

[Data Dictionary] http://stats.nba.com/players


[Unique ID Schema] The column “Player” is a primary key

--

[Dataset 2 Name] NBA West 2016-17

[Experimental Units] Contains players stats for 2016-17 NBA Season from the
Western Conference

[Number of Observations] 256

[Number of Features] 29

[Data Source] https://stats.nba.com/players/traditional/?PerMode=Totals&sort=PTS&dir=-1&Season=2016-17&SeasonType=Regular%20Season&Conference=West


[Data Dictionary] http://stats.nba.com/players


[Unique ID Schema] The column “Player” is a primary key

--

[Dataset 3 Name] NBA Advanced 2016-17

[Experimental Units] Contains advanced players stats for 2016-17 NBA Season
from both the Eastern and Western Conference

[Number of Observations] 486

[Number of Features] 22

[Data Source] http://stats.nba.com/players/advanced/?sort=GP&dir=-1&Season=2016-17&SeasonType=Regular%20Season


[Data Dictionary] http://stats.nba.com/players/advanced


[Unique ID Schema] The column “Player” is a primary key
--
;


* environmental setup;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-6_project2/blob/master/data/East201617.xlsx?raw=true

;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = East201617_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-6_project2/blob/master/data/West201617.xlsx?raw=true

;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = West201617_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-6_project2/blob/master/data/Advanced201617.xlsx?raw=true

;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = Advanced201617_raw;


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
        data=East201617_raw
        dupout=East201617_raw_dups
        out=East201617_raw_sorted(where=(not(missing(Player))))
    ;
    by
       Player
    ;
run;

data East201617_raw_sorted; set East201617_raw_sorted;
   conf = "EAST";
   format conf $4.
run;


proc sort
        nodupkey
        data=West201617_raw
        dupout=West201617_raw_dups
        out=West201617_raw_sorted
    ;
    by
        Player
    ;
run;

data West201617_raw_sorted; set West201617_raw_sorted;
   conf = "WEST";
   format conf $4.
run;

proc sort
        nodupkey
        data=Advanced201617_raw
        dupout=Advanced201617_raw_dups
        out=Advanced201617_raw_sorted
    ;
    by
        Player
    ;
run;

 
* combine East1617 data and West1617 data vertically
;
data East_West_Analytic_file;
   retain
        Player
        TEAM
        conf
        AGE
        GP
        W
        L
        MIN
        PTS
        FGM
        FGA
        FG_
        _3PM
        _3PA
        _3P_
        FTM
        FTA
        FT_
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
        VAR30
   ;
   keep
    Player
       TEAM
    conf
        AGE
        GP
        W
        L
        MIN
        PTS
        FGM
        FGA
        FG_
        _3PM
        _3PA
        _3P_
        FTM
        FTA
        FT_
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
        VAR30
   ;
   set
        East201617_raw_sorted(in=East_row)
        West201617_raw_sorted(in=West_row)
    ;
   by
        Player
    ;
run;


* build analytic dataset from raw datasets with the least number of columns 
and minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files
;
data advanced_data_analytic_file;
    merge East_West_Analytic_file Advanced201617_raw_sorted;
    by player team;
    retain
        CONF
        OREB
        DREB
        REB
        AST
        TOV
        STL
        BLK
        PF
        PLAYER
        TEAM
        AGE
        GP
        W
        L
        MIN
        PTS
        OFFRTG
        DEFRTG
        NETRTG
        AST_
        AST_TO
        AST_Ratio
        OREB_
        DREB_
        REB_
        TO_Ratio
        eFG_
        TS_
        USG_
        PACE
        PIE
        FGM
        _3PM
        FTM
    ;
    keep
        CONF
        OREB
        DREB
        REB
        AST
        TOV
        STL
        BLK
        PF
        PLAYER
        TEAM
        AGE
        GP
        W
        L
        MIN
        PTS
        OFFRTG
        DEFRTG
        NETRTG
        AST_
        AST_TO
        AST_Ratio
        OREB_
        DREB_
        REB_
        TO_Ratio
        eFG_
        TS_
        USG_
        PACE
        PIE
        FGM
        _3TM
        FTM
    ;
   run;
   

* Setup for JC Question 1 ;

* Creating dataset for question1 and limiting to only necessary variables;
data quest1
    ;
    set
        advanced_data_analytic_file
    ;
    MIN = MIN*GP
    ;
    format
        team $5.
        GP MIN 4.
    ;
    keep
        player
        GP
        CONF
        team
        MIN
        OREB
        DREB
        REB
        AST
        TOV
        STL
        BLK
        PF
    ;
run;

* Ensuring no duplicates in new file ;
proc sort
        nodupkey
        data=quest1
        out=tm1
    ;
    by
        team
        player
    ;
run;

* 
Using only players that have played more than 41 games,
finding conference means for the 8 variables listed below.
;

proc means
        data=tm1
        noprint
    ;
    where GP > 41 and team ^= "TOT"
    ;
    class
        CONF
    ;
    var
        OREB
        DREB
        REB
        AST
        TOV
        STL
        BLK
        PF
    ;
    output
        out=top3list(rename=(_freq_=NumberPlayers)) mean=
          idgroup( max(MIN) out[12] (player
          OREB DREB REB AST TOV STL BLK PF)=)/autolabel autoname
    ;
run;




* Setup for JC Question 2;

* 
Creating dataset for analyzing question2.
Creating successful shots per minute, for each of 3 scoring categories.
Creating adjusted point per minute statistic, called useful.
;

data quest2
    ;
    set
        advanced_data_analytic_file
    ;
    MIN=MIN*GP
    ;
    FG60_ = FGM/MIN
    ;
    _360 = _3PM/MIN
    ;
    FT60_ = FTM/MIN
    ;
    AST60_ = AST/MIN
    ;
    Useful = 2*FG60_ + 3*_360 + FT60_ + AST60_
    ;
    format
        Pp60_ FG60_ _360 FT60_ AST60_ Useful 6.2
        team $5.
        GP MIN PTS 4.
    ;
    keep
        player
        team
        MIN
        PTS
        GP
        FG60_
        _360
        FT60_
        AST60_
        Useful
    ;
run;

* Ensuring no duplicates in data;

proc sort
        nodupkey
        data=quest2
        out=tm2
    ;
    by
        team
        player
    ;
run;

* 
Using only players who played more than 41 games,
found mean of useful for each team.
;

proc means
        data=tm2
        noprint
    ;
    where GP > 41 and team ^= "TOT"
    ;
    class
        team
    ;
    var
        useful
    ;
    output
        out=top3list2(rename=(_freq_=NumberPlayers)) mean=
          idgroup( max(useful) out[12] (player
          useful)=)/autolabel autoname
    ;
run;

*Creating new dataset, adding the useful scores to the top 7 players per team;

data n3list2
    ;
    set
        top3list2
    ;
    new = (useful_1 + useful_2 + useful_3 + useful_4 + useful_5 + useful_6 + useful_7)/7
    ;
    format
        new 6.3
    ;
run;

* Sorting n3list2 by new, to have descending list of top teams;

proc sort
        data=n3list2
    ;
    by
        descending new
    ;
run;



* Setup for JC Question 3;

* Creating dataset for question3 analysis.;

data quest3
    ;
    set
        advanced_data_analytic_file
    ;
    MIN=MIN*GP
    ;
    format
        team $5.
        GP MIN 4.
    ;
    keep
        player
        team
        MIN
        GP
        offrtg
        defrtg
        pie
    ;
run;

* Ensuring no duplicates. ;

proc sort
        nodupkey
        data=quest3
        out=tm3
    ;
    by
        team
        player
    ;
run;

* Finding average mean by team of each player for offrtg, defrtg, and pie ; 

proc means
        data=tm3
        noprint
    ;
    where GP > 41 and team ^= "TOT"
    ;
    class
        team
    ;
    var
        offrtg
        defrtg
        pie
    ;
    output
        out=top3list3(rename=(_freq_=NumberPlayers)) mean=
          idgroup( max(MIN) out[12] (player
          offrtg defrtg pie)=)/autolabel autoname
    ;
run;

* 
Averaging top 7 players per team together.
New3 multiplied by 10 to have similar scale.
New4 created as a catch all statistic.
;

data n3list3
    ;
    set
        top3list3
    ;
    new = (offrtg_1 + offrtg_2 + offrtg_3 + offrtg_4 + offrtg_5 + offrtg_6 + offrtg_7)/7
    ;
    new2 = (defrtg_1 + defrtg_2 + defrtg_3 + defrtg_4 + defrtg_5 + defrtg_6 + defrtg_7)/7
    ;
    new3 = ((pie_1 + pie_2 + pie_3 + pie_4 + pie_5 + pie_6 + pie_7)*10)/7
    ;
    new4 = (new + new2 + new3)/3
    ;
    format
        new new2 new3 new4 6.3
    ;
run;

* Sort n3list3 by new4;

proc sort data=n3list3
    ;
    by descending 
        new4
    ;
run;


