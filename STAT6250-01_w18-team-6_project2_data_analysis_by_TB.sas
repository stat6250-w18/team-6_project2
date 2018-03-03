
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding individual players statistic in the NBA between the eastern
and western conference. 

Dataset Name: NBA 16-17 data set.xlsx created in external file.
STAT6250-01_w18-team-6_project2_data_preparation.sas, which is assumed to be
in the same directory as this file.

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset NBA_2016_analytic_file;
%include '.\STAT6250-01_w18-team-6_project2_data_preparation.sas'


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which conference recorded the most points and assists between the 2016 and 2017 season?'
;

title2
'Rationale: This would help identify which conference is the offensive powerhouse.'
;

footnote1
"The conference that recorded the most points and assists as a total sum of all the players in the respective conference is the Western Conference."
;

footnote2
"Although the Western conference players recorded the most points and assists, it was not by any big margin."
;

footnote3
"If we look at the graph that compares the number of assists and points among all the players in both conferences, we can see that the statistics for points and assists among most of the players is similar."
;

*
Notes: This compares the Points (PTS) and Assists (AST) column in the East
2016-17 data file with the same columns in the West 2016-17 data files.

Methodology: We add up the column PTS (Points) and AST (Assists) recorded by 
each player in the West and East files. Then we compare the numbers to see 
which conference recorded the most points and assists.

Limitations: Although this will tell us which conference was offensivley 
dominant, we also need to look at total number of losses and wins for a more
deeper analysis. 

Followup Steps: Get the total wins and loses for each conference and determine
which conferene got the most wins over the other.
;

proc sql;
        select sum(PTS) as East_Conf_PTS
        from East201617_raw_sorted;       
        select sum(AST) as East_Conf_AST
        from East201617_raw_sorted;
        select sum(PTS) as West_Conf_PTS
        from West201617_raw_sorted;      
        select sum(AST) as West_Conf_AST
        from West201617_raw_sorted;     
quit;       
        
proc print 
    data=East_West_Analytic_file
   ;
   var
       TEAM
       AST
       PTS
   ;
run;

*
Graph Assists and Points for both Eastern and Western conference players.
;
proc sgplot data=East_West_Analytic_file;
     scatter x=PTS
             y=AST / markerattrs=(symbol=circlefilled size=10px)
             filledoutlinedmarkers group=TEAM;
run;
       
title;
footnote;

       
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which conference recorded the most steals and blocks in 2016 and 2017 season?'
;

title2
'Rationale: This would help identify which conference has the best defensive players.'
;

footnote1
"The conference that recorded the most steals and blocks as a total sum among all the palyers in the respective conference is the western conference."
;

footnote2
"If we look at the graph that compares the number of steals and blocks for all the players in both conferences, we can observe that with the exception of a handlful of players, the rest had similar amount of blocks and steals."
;

*
Note: This compares the column Steals (STL) and Blocks (BLK) in the East 
2016-17 data file with the same columns in the West 2016-17 files.

Methodology: We add up the number of "STL” (Steals) and “BLK” (Blocks) from the 
East 2016-17 and compare it to sum from West 2016-17 file.

Limitaitons: This only takes into account Steals and Blocks. We can look at 
other defensive stats such as points allowed for further analysis. 

Followup Steps: Add up the points allowed by each conference and determine
which conference allowed the least points.
;

proc sql;
        select sum(STL) as East_Conf_STL
        from East201617_raw_sorted;    
        select sum(BLK) as East_Conf_BLK
        from East201617_raw_sorted;
        select sum(STL) as West_Conf_STL
        from West201617_raw_sorted;      
        select sum(BLK) as West_Conf_BLK
        from West201617_raw_sorted;
quit;       
     
*
Graph Assists and Points for both Eastern and Western conference players.
;
proc sgplot data=East_West_Analytic_file;
     scatter x=STL
             y=BLK / markerattrs=(symbol=circlefilled size=10px)
             filledoutlinedmarkers group=TEAM;
run;
        
title;
footnote;  
  
  
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which conference attempted the most total amount free throws, the Eastern or Western Conference in the 2016-17 season?'
;

title2
'Rationale: This would help identify if the number of free throws taken in a game have a direct correlation with points scored.'
;

footnote1
"The Eastern Conference players recorded the most attempts as a total sum among all the players in their conference than the Western Conference."
;

footnote2
"If we look at the results of the graph for the amount of free throws attempted by all the teams in the NBA, we can see that it is similar with the exception of a handful of teams."
;

*
Note: This compares the Free Throw Attempts (FTA) between the East 2016-17
data with the FTA column in the West 2016-17 data.

Methodology: We add up the number "FTA” (Free Throw Attempt) from the East 
2016-17 and compare it the sum from West 2016-17 file.

Limitations: We can look at other stats such as number of shots attempted and
field goal percentage to see which players are offensively efficient. 

Followup Steps: Find the avg free throw percentage of all the players in each
conference and see which shooting percentage is better between the two.
;

proc sql;
        select sum(FTA) as East_Conf_FTA
        from East201617_raw_sorted;   
        select sum(FTA) as West_Conf_FTA
        from West201617_raw_sorted;   
quit;

*
Graph Assists and Points for both Eastern and Western conference players.
;
proc sgplot data=East_West_Analytic_file;
     scatter x=TEAM
             y=BLK / markerattrs=(symbol=circlefilled size=10px)
             filledoutlinedmarkers group=TEAM;
 run;

title;
footnote;
