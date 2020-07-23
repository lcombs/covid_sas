/********************************************

PURPOSE: COVID-19 Data Brief / STEP 1

DATA SETS: 
●	Eight (8) SAS datasets with daily COVID-19 information for the study period (“cd0601”- “cd0607”) and for the day prior to the start of the study period (“cd0531”)
●	One (1) SAS dataset indicating region for each U.S. state/territory, based on U.S. Census classification (“region”) 

PROGRAMMER: Elizabeth Combs

DATE DUE : 7/27/2020

********************************************/


*First, let’s examine the data for the entire United States, i.e., all states and territories:

1.	What was the total number of (a) tests, (b) confirmed cases, (c) hospitalizations, and (d) deaths recorded in the U.S. at the beginning of the study period (on June 1)? ;
* selected (b) confirmed cases;
proc contents data=mylib.cd0531;
run;
* NOTE: The data set mylib.cd0601 has 58 observations and 19 variables.;

proc print data=mylib.cd0531 (obs=10);
run;

proc means data=mylib.cd0531 n  mean sum;
var Confirmed;
run;

* Confirmed:1790172.00 on May 31 (beginning); 
* Confirmed:1811020.00 on Jun 1;

*What was the total number of (a) tests, (b) confirmed cases, (c) hospitalizations, and (d) deaths recorded in the U.S. at the end of the study period (on June 7)? 1 point ;
* selected (b) confirmed cases;
proc contents data=mylib.cd0607;
run;

proc print data=mylib.cd0607 (obs=10);
run;

proc means data=mylib.cd0607 n  mean sum;
var Confirmed;
run;
* Confirmed:1943882, Deaths:110528,	People_Tested:20235678,	People_Hospitalized: 216906;	 	 	 	 	

*Next, merge all datasets provided into one combined dataset. Compute the number of new tests, new confirmed cases, and new deaths for each day of the study period (June 1-7, 2020) by subtracting the total number recorded the day before from the total number reported that day. 
2.	How did the total daily number of new tests, new confirmed cases, and new deaths change over time in the U.S. during the study period (June 1-7, 2020)? Did these numbers increase, decrease, or pretty much stay the same? 6 points;

* wide merge:;
* first, change the variable  name for confirmed by day so that we can merge by province_state;

* day0;
data day_0;
set mylib.cd0531;
*rename variables;
Confirmed_day0=Confirmed; 
*dataset only has those variables;
keep Confirmed_day0 province_state;
run;

*sort before merging;
proc sort data=day_0;
by Province_state;

proc print data=mylib.cd0531;
run;

proc print data=day_0;
run;

* day1;
data day_1;
set mylib.cd0601;
*rename variables;
Confirmed_day1=Confirmed; 
*dataset only has those variables;
keep Confirmed_day1 province_state;
run;

*sort before merging;
proc sort data=day_1;
by Province_state;

* day2;
data day_2;
set mylib.cd0602;
*rename variables;
Confirmed_day2=Confirmed; 
*dataset only has those variables;
keep Confirmed_day2 province_state;
run;

*sort before merging;
proc sort data=day_2;
by Province_state;

* day3;
data day_3;
set mylib.cd0603;
*rename variables;
Confirmed_day3=Confirmed; 
*dataset only has those variables;
keep Confirmed_day3 province_state;
run;

*sort before merging;
proc sort data=day_3;
by Province_state;

* day4;
data day_4;
set mylib.cd0604;
*rename variables;
Confirmed_day4=Confirmed; 
*dataset only has those variables;
keep Confirmed_day4 province_state;
run;

*sort before merging;
proc sort data=day_4;
by Province_state;

* day5;
data day_5;
set mylib.cd0605;
*rename variables;
Confirmed_day5=Confirmed; 
*dataset only has those variables;
keep Confirmed_day5 province_state;
run;

*sort before merging;
proc sort data=day_5;
by Province_state;

* day6;
data day_6;
set mylib.cd0606;
*rename variables;
Confirmed_day6=Confirmed; 
*dataset only has those variables;
keep Confirmed_day6 province_state;
run;

*sort before merging;
proc sort data=day_6;
by Province_state;

* day7;
data day_7;
set mylib.cd0607;
*rename variables;
Confirmed_day7=Confirmed; 
*dataset only has those variables;
keep Confirmed_day7 province_state;
run;

*sort before merging;
proc sort data=day_7;
by Province_state;

* region has province_state;
proc sort data=mylib.region;
by Province_state;

* merge daily data and region by province_state and save permanent;
data mylib.daily_covid_cases;
merge day_0 day_1 day_2 day_3 day_4 day_5 day_6 day_7 mylib.region;
by Province_state;
run;

proc print data=mylib.daily_covid_cases;
run;

data mylib.daily_covid_change; 
set  mylib.daily_covid_cases;
newcases1=Confirmed_day1-Confirmed_day0;
newcases2=Confirmed_day2-Confirmed_day1;
newcases3=Confirmed_day3-Confirmed_day2;
newcases4=Confirmed_day4-Confirmed_day3;
newcases5=Confirmed_day5-Confirmed_day4;
newcases6=Confirmed_day6-Confirmed_day5;
newcases7=Confirmed_day7-Confirmed_day6;
run;

*sum over the 58 entries to find the total for the US;
proc means data=mylib.daily_covid_change n sum;
var newcases1 newcases2 newcases3 newcases4 newcases5 newcases6 newcases7;
run;
*stayed mostly the same with a spike on day5;
* external Excel analysis of output: mean = 21959, std = 3845

*Second, let’s investigate the data by region. 
3.	At the beginning of the study period (on June 1, 2020), how did the average hospitalization rate compare across the five regions of the U.S.? In other words, which region had the highest and which region had the lowest average (mean) hospitalization rate? Please answer the same question for the last day of the study period (June 7, 2020). 4 points;

*day1;
proc sort data=mylib.cd0531;
by Province_state;
run;

proc print data=mylib.cd0531;
run;

proc sort data=mylib.region;
by Province_state;
run;

data day1_hosp_reg;
merge mylib.cd0531 mylib.region;
by Province_state;
run;

proc print data=day1_hosp_reg;
run;

proc means data=day1_hosp_reg nway;
class region;
var hospitalization_rate;
run; 

*NE highest; 
*MW lowest;
*Other - missing info;

*day7;
proc sort data=mylib.cd0607;
by Province_state;
run;

proc sort data=mylib.region;
by Province_state;
run;

data day7_hosp_reg;
merge mylib.cd0607 mylib.region;
by Province_state;
run;

proc print data=day7_hosp_reg;
run;

proc means data=day7_hosp_reg;
class region;
var hospitalization_rate;
run; 

*NE highest, but South much closer; 
*MW lowest;
*Other missing info;


*Finally, let’s look at the data at the state level:
4.	At the beginning of the study period (on June 1, 2020), which state or territory had the highest and which state or territory had the lowest number of (a) new tests, (b) new confirmed cases, and (c) new deaths? ;
proc sort data=mylib.daily_covid_change;
by newcases1;
run;

proc print data=mylib.daily_covid_change;
run;
*HIGH: Massachusettts: 3840;
*LOW: 7 states and provinces had 0 cases;

proc sort data=mylib.daily_covid_change;
by newcases7;
run;

proc print data=mylib.daily_covid_change;
run;
*HIGH: California: 2022;
*LOW: 8 states and provinces had 0 cases;

data mylib.total_covid_change; 
set mylib.daily_covid_change;
newcases_total = newcases1 + newcases2 + newcases3 + newcases4 + newcases5 + newcases6 + newcases7;
run;

proc sort data=mylib.total_covid_change;
by newcases_total;
run;

proc print data=mylib.total_covid_change;
run;


*5.	Select one state/territory from each of the five regions. (NOTE: your selections are completely up to you.) Compare trends in daily (a) new tests, (b) new confirmed cases, and (c) new deaths across the study period for the selected states and/or territories. Do you see different or similar patterns across the five selected locations?  6 points;	

proc print data=mylib.daily_covid_change;
run;

*select the states/territories;
data daily_covid_change_select;
set mylib.daily_covid_change;
selected = 0;
if province_state = 'Georgia' then selected = 1;
if province_state = 'Connecticut' then selected = 1;
if province_state = 'Washington' then selected = 1;
if province_state = 'Missouri' then selected = 1;
if province_state = 'Puerto Rico' then selected = 1;
run;

*keep only the selected states/territories;
data daily_covid_change_selected;
set daily_covid_change_select;
where selected = 1;
keep province_state newcases1 newcases2 newcases3 newcases4 newcases5 newcases6 newcases7;
run;

proc print data=daily_covid_change_selected;
run;

*transpose for plotting;
proc transpose data=daily_covid_change_selected out=daily_covid_change_selected_t;
id province_state;
run;

proc print data=daily_covid_change_selected_t;
run;

data daily_covid_change_selected_t2;
set daily_covid_change_selected_t;
study_day=_n_;
run;

title1 "State Case Studies: New Confirmed COVID-19 US Cases";
footnote1 "Source: COVID-19 Data from the Center for Systems Science and Engineering at Johns Hopkins University";
proc sgplot data=daily_covid_change_selected_t2;
 series x=study_day y=Puerto_Rico;
 series x=study_day y=Missouri;
 series x=study_day y=Connecticut;
 series x=study_day y=Washington;
 series x=study_day y=Georgia;
yaxis label="New Confirmed COVID-19 cases";
xaxis label="Study Day 
(June 1-June 7, 2020)"; 
run;

* STEP 2: Please see the data brief for summarized results.