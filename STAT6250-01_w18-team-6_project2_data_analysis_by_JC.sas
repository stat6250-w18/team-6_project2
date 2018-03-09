
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding individual players statistic in the NBA between the eastern
and western conference.

Dataset Name: NBA 16-17 data set.xlsx created in external file
STAT6250-01_w18-team-6_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset NBA_2016_analytic_file;
%include '.\STAT6250-01_w18-team-6_project2_data_preparation.sas';

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Are there any significant differences in playstyle between conferences (more pts, free throws, etc.)? '
;

title2
'Rationale: Determining how each conferences strategies are structured to compete in inter-conference games.'
;

footnote1
' '
;

*
Note: This compares the columns OREB, DREB, REB, AST, TOV, STL, BLK, and PF between both conferences.

Methodology: Averaging major statistics (Offensive, Defensive, & Total Rebounds, Assists,
Turnovers, Steals, Blocks, and Personal Fouls) by conference and comparing them.

Limitations: Does not test for significance.

Possible Follow-up Steps: Testing for significance.

;



proc print
        data=top3list
        noobs label
    ;
    var
        CONF
        OREB_mean
        DREB_mean
        REB_mean
        AST_mean
        TOV_mean
        STL_mean
        BLK_mean
        PF_mean
    ;
    format
        OREB_mean
        DREB_mean
        REB_mean
        AST_mean
        TOV_mean
        STL_mean
        BLK_mean
        PF_mean 9.2
    ;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1
'Research Question: Who are the most efficient players in the league?'
;
title2
'Rationale: Determining which players are most valuable to teams by measuring points against play time.'
;

footnote1
' '
;

*
Note: This uses the columns creates an adjusted Points per Minute statistic
using the columns PTS, FGM, _3PM, FTM, AST, and MIN.

Methodology: Computing adjusted point variable using free throw, 3 pt, and
field goals pts to evaluate efficiency.

Limitations: Does not take into account teammate effects.

Possible Follow-up Steps: Take team and teammate effects into account.

;



title1 'Top 5 Players';

proc print
        data=n3list2
        noobs label
    ;
    var
        new
        team
        player_1
        useful_1
        player_2
        useful_2
        player_3
        useful_3
        player_4
        useful_4
        player_5
        useful_5
    ;
    label
        player_1 = "#1 Player"
        player_2 ="#2 Player"
        player_3 = "#3 Player"
        player_4 = "#4 Player"
        player_5 = "#5 Player"
    ;
    label
        useful_1 = "Useful"
        useful_2 = "Useful"
        useful_3 = "Useful"
        useful_4 = "Useful"
        useful_5 = "Useful"
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1
'Research Question: Which teams had the best rosters?'
;
title2
' Rationale: Looking at offensive, defensive, and player impact estimates to compare teams and see if that matches league standings and playoff success.'
;

footnote1
' '
;

*
Note: This uses the columns of offrtg, defrtg, pie, MIN, and GP.

Methodology: Creating sums of offrtg, defrtg, and pie for Top 7 players in minutes played per team.

Limitations: Comparing variables of different distributions.

Possible Follow-up Steps: Standardize variables and create a comprehensive "catch-all" statistic.

;


proc print
        data=n3list3
        noobs label
    ;
    var
        new4
        team
        new
        new2
        new3
    ;
run;

title;
footnote;
