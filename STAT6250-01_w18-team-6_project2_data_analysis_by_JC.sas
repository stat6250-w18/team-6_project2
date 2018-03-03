


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
%include '.\STAT6250-01_w18-team-6_project2_data_preparation.sas'

title1 
'Research Question: Are there any significant differences in playstyle between conferences (more pts, free throws, etc.)? '
;

title2
'Rationale: Determining how each conference's strategies are structured to compete in inter-conference games.'
;

*
Methodology: Averaging major statistics (Offensive, Defensive, & Total Rebounds, Assists, 
Turnovers, Steals, Blocks, and Personal Fouls) by conference and comparing them.

Limitations: Does not test for significance.

Possible Follow-up Steps: Testing for significance.

;


data quest1
    ;
    set 
        advance_data_analytic_file
    ;
    format 
        team $5. 
        GP MIN 4.
    ;
    keep 
        player 
        conf 
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

proc means 
        data=tm1 
        noprint
    ;
    where GP > 41 and team ^= "TOT"
    ;
    class 
        conf
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

proc print 
        data=top3list 
        noobs label
    ;
    var 
        conf 
        OREB_mean 
        DREB_mean 
        REB_mean 
        AST_mean 
        TOV_mean 
        STL_mean 
        BLK_mean 
        PF_mean
    ;
run;

title1
'Research Question: Who are the most efficient players in the league?'
;
title2
'Rationale: Determining which players are most valuable to teams by measuring points against play time.'
;

*
Methodology: Computing adjusted point variable using free throw, 3 pt, and 
field goals pts to evaluate efficiency.

Limitations: Does not take into account teammate effects.

Possible Follow-up Steps: Take team and teammate effects into account.

;

data quest2
    ;
    set 
        advance_data_analytic_file
    ;
    Pp60_ = PTS/(MIN)
    ;
    Pp60_ = ((PTS + REB + AST)/(MIN*4))
    ;
    DEF = (STL + BLK - TOV)/(MIN)
    ;
    New2 = (Pp60_*.6 + DEF*.4)
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
        Pp60_ 
        FG60_ 
        _360 
        FT60_ 
        AST60_ 
        Useful 
        pos
    ;
run;

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

proc means 
        data=tm1 
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
        out=top3list(rename=(_freq_=NumberPlayers)) mean=
          idgroup( max(useful) out[12] (player
          useful)=)/autolabel autoname
    ;
run;

data n3list
    ; 
    set 
        top3list
    ;
    new = (useful_1 + useful_2 + useful_3 + useful_4 + useful_5 + useful_6 + useful_7)/7
    ;
    format 
        new 6.3
    ;
run;

proc sort 
        data=n3list
    ;
    by 
        descending new
    ;
run;

title1 'Top 5 Players';

proc print 
        data=n3list 
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



title1
'Research Question: Which teams had the best rosters?'
;
title2
' Rationale: Looking at offensive, defensive, and player impact estimates to compare teams and see if that matches league standings and playoff success.'
;

*
Methodology: Creating sums of offrtg, defrtg, and pie for Top 7 players in minutes played per team.

Limitations: Comparing variables of different distributions.

Possible Follow-up Steps: Standardize variables and create a comprehensive "catch-all" statistic.

;

data quest3
    ;
    set 
        advance_data_analytic_file
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

proc sort 
        nodupkey 
        data=quest3 
        out=tm1
    ;
    by 
        team 
        player
    ;
run;

proc means 
        data=tm1 
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
        out=top3list(rename=(_freq_=NumberPlayers)) mean=
          idgroup( max(MIN) out[12] (player
          offrtg defrtg pie)=)/autolabel autoname
    ;
run;

data n3list
    ; 
    set 
        top3list
    ;
    new = (offrtg_1 + offrtg_2 + offrtg_3 + offrtg_4 + offrtg_5 + offrtg_6 + offrtg_7)/7
    ;
    new2 = (defrtg_1 + defrtg_2 + defrtg_3 + defrtg_4 + defrtg_5 + defrtg_6 + defrtg_7)/7
    ;
    new3 = (pie_1 + pie_2 + pie_3 + pie_4 + pie_5 + pie_6 + pie_7)/7
    ;
    format 
        new new2 new3 6.3
    ;
run;

proc print 
        data=n3list 
        noobs label
    ;
    var 
        team 
        new 
        new2 
        new3
    ;
run;
