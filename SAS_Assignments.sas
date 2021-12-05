/* ----------------------Reading Data---------------------- */

/* ----------------------Assignment 1---------------------- */

/* Part 1 */
/* 1 */
PROC IMPORT DATAFILE="/home/u59306293/my_shared_file_links/haticesahinoglu0/Artists.csv"
OUT=artists_csv DBMS=CSV;

PROC CONTENTS DATA=artists_csv;
TITLE 'Assignment 1';
RUN;

/* 2 */
PROC IMPORT DATAFILE="/home/u59306293/my_shared_file_links/haticesahinoglu0/Artists_text.txt"
OUT=artists_text_txt DBMS=TAB REPLACE;
GETNAMES=NO;
RUN;

PROC CONTENTS DATA=artists_text_txt;
RUN;

/* Part2 */
/* a */
DATA Competition;
INPUT Name $ Weight Score1 Score2 Score3;
DATALINES;
Lucky 2.3 1.9 2.3 3.0
Spot 4.6 2.5 3.1  0.5
Tubs 7.1 2.2 3.1 3.8
Hop 4.5 3.2 1.9 2.6
Noisy 3.8 1.3 1.8 1.5
Winner 5.7 2.2 1.3 2.8
;
RUN;

PROC PRINT DATA=Competition;
RUN;

/* b */
DATA Competition_Column_Pointers;
INPUT Name $ 1-7 Weight 8-11 Score1 12-15 Score2 16-19 Score3 20-22;
DATALINES;
Lucky  2.3 1.9 2.3 3.0
Spot   4.6 2.5 3.1 0.5
Tubs   7.1 2.2 3.1 3.8
Hop    4.5 3.2 1.9 2.6
Noisy  3.8 1.3 1.8 1.5
Winner 5.7 2.2 1.3 2.8
;
RUN;

PROC PRINT DATA=Competition_Column_Pointers;
RUN;

/* ----------------------Assignment 2---------------------- */

/* Part 1*/
PROC IMPORT DATAFILE='/home/u59306293/my_shared_file_links/haticesahinoglu0/Artists_missing_text.txt'
OUT = Artists_Missing DBMS=TAB REPLACE;
GETNAMES=NO;
RUN;

PROC PRINT;
TITLE 'Assignment 2';
RUN;

/* Part 2 */
DATA RAWDATA;
INFILE '/home/u59306293/my_shared_file_links/haticesahinoglu0/Raw.txt' DLM=';' MISSOVER TRUNCOVER;
INPUT Date mmddyy10. Num1 Num2 Num3 Gender $;
days = TODAY() - Date;
RUN;

PROC PRINT;
RUN;



/* ---------------------Filtering Data--------------------- */

/* ----------------------Assignment 3---------------------- */

/* Import S&P500 Data */

DATA SP500;
INFILE '/home/u59306293/my_shared_file_links/haticesahinoglu0/S&P500_textData.txt' firstobs=8;
INPUT Date $12. Open comma8.2 High comma8.2 Low comma8.2 Close comma8.2 Adj_close comma8.2 volumn comma13.;
RUN;



/* Part 1 */
/* 1 */
DATA NewSP500;
SET work.SP500;
daily_return = (Close-Open)/Open;
OUTPUT;
RUN;

PROC PRINT DATA=NewSP500;
TITLE 'Assignment 3';
RUN;

/* 2 */
PROC MEANS DATA=NewSP500 MEAN;
VAR daily_return;
OUTPUT OUT=daily_return_average;
RUN;

DATA NewSP500;
SET work.NewSP500;
IF daily_return>4.7963922E-6 THEN Ret_Greater_Average=1;
ELSE Ret_Greater_Average=0;
RUN;

PROC PRINT DATA=NewSP500;
WHERE Ret_Greater_Average=1;
RUN;

/* 3 */ 
DATA _NULL_;
SET NewSP500;
FILE '/home/u59306293/SP500dailyreturns.txt';
WHERE Ret_Greater_Average=1;
PUT Date Open High Low Close Adj_close volumn daily_return;
RUN;

/* Part 2 */
/* 1 */
PROC MEANS DATA=NEWSP500 MEDIAN;
VAR Open;
OUTPUT;
RUN;

/* 2 */
DATA Indicated;
SET work.NewSP500;
IF Open>4487.43 THEN High_Open=1;
ELSE High_Open=0;
IF daily_return>0 THEN Pos_Return=1;
ELSE Pos_Return=0;
RUN;

PROC PRINT DATA=Indicated;
RUN;

/* 3 */
PROC FREQ DATA=Indicated;
TABLES High_Open*Pos_Return;
RUN;


/* ---------------Formatting and Plotting Data------------- */

/* ----------------------Assignment 4---------------------- */

DATA SP500;
INFILE '/home/u59306293/my_shared_file_links/haticesahinoglu0/S&P500_textData.txt' firstobs=8;
INPUT Month $1-3 Day 5-6 Year 9-12 / Open comma8.2 High comma8.2 Low comma8.2 
Close comma8.2 Adj_close comma8.2 volumn comma13.;
IF Month='Sep' THEN Month=09;
IF Month='Aug' THEN Month=08;
Date=MDY(Month, Day, Year);
Daily_Return=(Close-Open)/Open;
RUN;

PROC PRINT DATA=SP500;
TITLE 'Assignment 4';
RUN;

PROC MEANS DATA=SP500 MEAN;
VAR Daily_Return;
RUN;

DATA SP500HighReturn;
SET SP500;
IF Daily_Return > 4.7963922E-6 THEN HighReturn=1;
ELSE HighReturn=0;
RUN;

PROC PRINT DATA=SP500HighReturn;
RUN;

PROC FORMAT;
VALUE Return 1='above average'
			 0='below average';
RUN;

PROC PRINT DATA=SP500HighReturn;
FORMAT HighReturn Return.;
RUN;

ODS GRAPHICS ON;

PROC SGPLOT;
SERIES X=Date Y=Daily_Return;
FORMAT Date Date10.;
RUN;

PROC GCHART;
PIE3D HighReturn;
FORMAT HighReturn Return.;
RUN;
QUIT;

PROC SGPLOT;
VBOX Daily_Return;
RUN;

PROC SGPLOT;
HISTOGRAM Daily_Return;
RUN;

/* ----------------------Assignment 5---------------------- */

/* Part 1 */
PROC IMPORT DATAFILE='/home/u59306293/my_shared_file_links/haticesahinoglu0/BookClubNospace.csv'
OUT=BookClub DBMS=CSV;

PROC SORT DATA=BookClub OUT=SortedBookClub;
BY gender;

PROC PRINT;
TITLE 'Assignment 5';
RUN;

/* Part 2 */
PROC MEANS MEAN STDDEV;
VAR BooksRead;
BY gender;
OUTPUT OUT=Vars MEAN(BooksRead)=average STDDEV(BooksRead)= stddev;

PROC PRINT DATA=Vars;

/* part 3 */
PROC SGPLOT DATA=SortedBookClub;
WHERE gender='f';
VBAR BooksRead/GROUP=sector;
RUN;

/* Part 4 */
PROC SGPLOT DATA=SortedBookClub;
SCATTER X=age Y=BooksRead/GROUP=gender;
RUN;

/* Part 5 */
PROC FORMAT;
VALUE AGE LOW-30='Under_30'
		  30-HIGH='30_and_above';
VALUE NREAD LOW-4='Less_than_5'
			5-HIGH='5_or_more';
RUN;

PROC FREQ DATA=SortedBookClub;
TABLES age*BooksRead;
FORMAT age AGE.;
FORMAT BooksRead NREAD.;
RUN;

/* ------------------Confidence Intervals------------------ */

/* ----------------------Assignment 6---------------------- */

/* task 2 */
DATA Numbers;
INPUT data;
DATALINES;
14
22
16
16
23
43
10
5
21
;
RUN;

PROC PRINT DATA=Numbers;
TITLE 'Assignment 6';
RUN;

PROC MEANS MEAN STDDEV UCLM ALPHA=0.1;
VAR data;
RUN;

/* FIGURE OUT FORMULA SAS USES */
DATA FindFormulaUsed;
alpha = 0.1;
df = 8;
tCritical= TINV(0.9,df);
tCritical2= QUANTILE('T', 1-alpha, df);
zCritical2 = QUANTILE('NORMAL',1-alpha);
percentiletT = CDF('T', 1.39682, df);
RUN;

PROC PRINT DATA=FindFormulaUsed;

DATA Limit;
lim=18.8888889+1.39682*(10.7522607/SQRT(9));
RUN;

PROC PRINT DATA=Limit;

/* The formula uses a t-test as it the formula is the same with the t-critical value. */

/* task 3 */
/* read in SP500 */
DATA SP500;
INFILE '/home/u59306293/my_shared_file_links/haticesahinoglu0/S&P500_textData.txt' firstobs=8;
INPUT Month $1-3 Day 5-6 Year 9-12 / Open comma8.2 High comma8.2 Low comma8.2 
Close comma8.2 Adj_close comma8.2 volumn comma13.;
IF Month='Sep' THEN Month=09;
IF Month='Aug' THEN Month=08;
Date=MDY(Month, Day, Year);
Daily_Return=(Close-Open)/Open;
RUN;

PROC PRINT DATA=SP500;
RUN;

PROC MEANS DATA=SP500 MEAN STDDEV LCLM UCLM ALPHA=0.1;
VAR Daily_Return;
RUN;

/* 
As an investor, I would not invest as the upper and lower bounds of the 90% CI
are approximately the same distance from zero and also both less than 2/1000 
away from zero. As an investor, you would likely get very minimal positive return,
if any at all.
*/


/* -------------------Hypothesis Testing--------------------*/

/* ----------------------Assignment 7---------------------- */

DATA SP500;
INFILE '/home/u59306293/my_shared_file_links/haticesahinoglu0/S&P500_textData.txt' firstobs=8;
INPUT Month $1-3 Day 5-6 Year 9-12 / Open comma8.2 High comma8.2 Low comma8.2 
Close comma8.2 Adj_close comma8.2 volumn comma13.;
IF Month='Sep' THEN Month=09;
IF Month='Aug' THEN Month=08;
Date=MDY(Month, Day, Year);
Daily_Return=(Close-Open)/Open;
RUN;

/* Task1 */
PROC TTEST DATA=SP500 ALPHA=0.09 H0=4500 SIDE=L;
VAR Open;
TITLE ' Assignment 7 Task1 Test';
RUN;

/* A */
/* The test statistic is the (sample mean-H0)/(s/sqrt(n)) where s/sqrt(n) is the standard error. */
DATA TestStat;
Tvalue=(4482.6-4500)/9.1249;
RUN;

PROC PRINT DATA=TestStat;
TITLE 'Task1 Part A Output';
RUN;

/* B */
DATA Pval;
Pvalue=probt((4482.6-4500)/9.1249, 21);
Run;

PROC PRINT DATA=Pval;
TITLE 'Task1 Part B Output';
RUN;

/* C */
/* 
There is enough evidence to reject the null hypothesis that average value = 4500 in
favor of the alternative hypothesis that the average value of the variable open < 4500.
This is because the P-value=0.0349 which is less than the significance level 0.09.
*/

/* Task2 */
PROC TTEST DATA=SP500 ALPHA=0.1 H0=0 SIDE=U;
VAR Daily_Return;
TITLE 'Task2 Test';
RUN;

/* A */
/* The test statistic is the (sample mean-H0)/(s/sqrt(n)) where s/sqrt(n) is the standard error. */
DATA TestStat2;
Tvalue=(4.796E-6 - 0)/0.00103;
RUN;

PROC PRINT DATA=TestStat2;
TITLE 'Task2 Part A Output';
RUN;

/* B */
DATA Pval;
Pvalue=probt((4.796E-6 - 0)/0.00103, 21);
Run;

PROC PRINT DATA=Pval;
TITLE 'Task2 Part B Output';
RUN;

/* C */
/*
My conclusion is to not reject the null hypothesis that the average value for daily return = 0
in favor of the alternative hypothesis that the average value for daily return > 0.
This is because the p-value=0.4982 > 0.1=significance level.
*/

/* Task3 */
PROC TTEST DATA=SP500 ALPHA=0.1 H0=0 SIDE=2;
VAR Daily_Return;
TITLE 'Task3 Test';
RUN;

/* A */
/*
The pvalue for task2 was exactly half of the pvalue for task3. This is because the test is for 
both sides as opposed to just one. When doing a two sided test, you need to use alpha/2 instead.
This works since it is for a normal distribution, which is symmetric, so the area to the left
of a point is equal to the area to the right of the same point with opposite sign. 
So, the area under both sides combined is twice as much as the area under just one side.
Pval for part 3 = 0.9963, Pval for part 2 = 0.4982
*/

/* B */
/*
The histogram and qqplots are shown to show whether the variable is normally distributed.
If the bins of the histogram fit closely to the normal curve, then it is approximately normally distributed.
If the points on the qqplot are close to the given line, then the variable is approximately normally distributed.


/* ------------------Analysis of Variance------------------ */

/* ----------------------Assignment 8---------------------- */

PROC IMPORT DATAFILE='/home/u59306293/crop.data.csv'
OUT=Crop DBMS=CSV;


/* 1 */
PROC MEANS DATA=CROP MEAN;
CLASS density;
TITLE 'Assignment 8';
RUN;

PROC TTEST H0=0 ALPHA=0.05 SIDE=2;
CLASS density;
VAR yield;
TITLE 'T-Test Part 1';

/*
Value of test statistic = -3.62, this is derived from the t Value box in the
third output table from proc ttest.
Pvalue = 0.0005
My conclusion is to reject the null hypothesis that the means of the two densities are the same.
*/


/* 2 */
PROC ANOVA DATA=Crop;
class fertilizer;
model yield=fertilizer;
TITLE 'ANOVA Part 2';
RUN;

/* 
test statistic = 7.86	
pvalue = 0.0007
You can conclude that not all the means are the same since pvalue=0.0007<0.1=alpha.
Thus you reject the null hypothesis.
*/


/* 3 */
PROC ANOVA DATA=Crop;
CLASS fertilizer;
MODEL yield=fertilizer;
means fertilizer /tukey ALPHA=0.1;
TITLE 'Tukey Part 3';
RUN;

/*
By the graph at the end, the mean yields for fertilizers 1 and 2 are not significantly
different, but the mean yield for fertilizer 3 is significantly different from 1 and 2.
*/


/* -------------------Linear Regression-------------------- */

/* ----------------------Assignment 9---------------------- */

PROC IMPORT DATAFILE="/home/u59306293/House_Price.csv"
OUT=House_Price DBMS=CSV REPLACE;

/* 1 */
PROC REG;
MODEL PRICE = SQFT;
TITLE 'Assignment 9';
RUN;

/* a */
/*
variance 2815612 
this is computed as Error Sum of Squares/n-2 as show in the ANOVA table (39418571/14)


b0 -14614	
b1 67.14926
*/

PROC MEANS DATA=House_Price MEAN;
VAR sqft price;
OUTPUT OUT=MEANS MEAN(sqft price)=meanx meany;

PROC PRINT DATA=MEANS;

DATA values;
SET House_Price;
xi_xbar = (sqft-1462.81);
yi_ybar = (price-83612.50);
xi_xbar2 = xi_xbar**2;
yi_ybar2 = yi_ybar**2;
xi_yi_bar = (xi_xbar*yi_ybar);
RUN;

PROC MEANS DATA=values SUM;
VAR xi_xbar2 yi_ybar2 xi_yi_bar;
OUTPUT OUT=SUMS SUM(xi_xbar2 yi_ybar2 xi_yi_bar)=Sxx Syy Sxy;

PROC PRINT DATA=SUMS;
RUN;

DATA Params;
b1=120223937.5/1790398.44;
b0=83612.50-b1*1462.81;
RUN;

PROC PRINT DATA=Params;
TITLE 'Calculated Parameters Part 1a';
RUN;

/* b */
*PROC TTEST H0=0 ALPHA=0.05 SIDE=2;

DATA UtilityTest;
teststat=(67.14926-0)/SQRT(2815612/1790398.44); /* b1-B1/SQRT((SSE/n-2)/Sxx) */
df=16-2;
prob_greater_than_t = (1-CDF('T', teststat, df));
pval=2*prob_greater_than_t;
alpha=0.05;
RUN;

PROC PRINT;
TITLE 'Utility Test Part 1b';
RUN;

/*
Since pval=0 < 0.05=alpha, there is enough evidence to conclude that B1 is not equal to 0.

/* c */
/*
value of r squared = 0.9951409274 (this is found in third table of proc reg).

R^2 is the percent of error in the predicted values that are a result of the model.
*/

/* 2 */
PROC ANOVA DATA=House_Price;
CLASS STYLE;
MODEL PRICE = STYLE;
means STYLE /tukey ALPHA=0.05;
TITLE 'Task 2';
RUN;

/* With Pvalue 0.3455, there is not enough evidence to conclude that any of the different
mean prices for different housing styles are different. This is further shown in the
graph of Tukey's test which shows none of the means are significantly different from one another.





