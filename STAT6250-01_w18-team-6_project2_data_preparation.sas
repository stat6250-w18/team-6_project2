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
