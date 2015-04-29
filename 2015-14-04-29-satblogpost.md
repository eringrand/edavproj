---
layout: post
title: SAT Scores for the High Schools in New York City
description: Erin, Maura, Stephen, Xu and Casey's final project. 
tags: blog post
---


# SAT Scores for High Schools in New York City
_[Link to the our project repositiory](https://github.com/eringrand/edavproj)_


# The plan:  

1. What were our goals?  What questions did we seek to answer? 
   
   Considering the importance of higher education in an increasingly knowledge based economy, we performed an exploratory data analysis of SAT performance 
   (i,e reading, math, and writing scores) on all public schools in New York City in relation to various attributes that might potentially have an influence, with 
   the following objectives:
   
   1) Understand what attributes actually influence SAT performance
   2) Visualize the relationships between assessment data and community information in a clear and concise fashion
   

   Questions we desire to answer:
   1) whether there is a correlation between SAT scores and other school metrics
   2) whether income and poverty rate by neighborhood influence SAT performance
   3) whether we could tell which schools are speciality schools on the map
   
1. Where did we get our data? What are the problems with our data?

   We obtained data on 2012 SAT Scores and NYC public schools from NYC OpenData website, with the rest of the data coming from various sources, such as 
   nyc.gov and school.nyc.gov 

   1. [NYC OpenData SAT Scores 2012](https://data.cityofnewyork.us/Education/SAT-Results/f9bf-2cp4)
   1. [NYC OpenData DOE High School Directory 2014-2015](https://data.cityofnewyork.us/Education/DOE-High-School-Directory-2014-2015/n3p6-zve2)
   1. [Income by ZipCode](http://zipatlas.com/us/city-comparison/median-household-income.html)
   1. [Income by Neighborhood](http://furmancenter.org/research/sonychan/2013-state-of-new-york-citys-housing-and-neighborhoods-report)
   1. Class Sizes 2010-2011 
   1. School Safety Report
   1. Neighborhood Shape File
   
   In the process of data munging, we encountered several problems. First and foremost, a number of schools were missing SAT scores along with other school metrics. 
   As a solution, we just deleted them from the dataset. Another problem came from the structure of the data. Some data are arranged by neighborhood or school district,
   while others are sorted by zipcode. So we had to find ways to order data by the same metric, i.e, converting zipcodes to neighborhood or vice versa. The third problem, 
   however minor, was the inconsistency of the time of the datasets. Some datasets were from 2012, such as SAT scores, whereas others were from 2011 or periods before. 

   ## Problems / Issues / Concerns with the Data

   1. _Missing data:_ We lose a lot of data from schools that didn't report their scores.
   1. _Time:_ The data we're using come from vastly different years.  
   1. Aggrating the information in a way that makes the most sense. (Zipcodes? Neighborhoods? School Districts? Boroughs?)

1. d3 Plot (Stephen) 

1. Clustering (Erin) High-Medium-Low SAT Score

   1) Cluster the SAT scores with a simple KMEANS algorithm 
   2) Joined all the tables together with their cluster ID
   3) Looked at the correlation / overlap between the three types of SAT scores
   4) Looked at scatter plots of normalized feature vectors to see if they were visually correlated with SAT scores in any way.


1. Survey (Maura + Casey)
   
   
1. What parts of the data were interesting?

1. Demonstration of our code.

1. Discussion of our vizualitions and results. 

1. Further Improvement




## Data Columns

_Pulled some variables that we thought might be important._

1. SAT scores 
1. Avg Household Income
1. Poverty
1. school gender ratios, school class sizes
1. Safety concerns

## Data Mundging

1. Join all the tables together
1. Normalize
1. Get locations


## Tools

1. For the data: R
2. For the map: D3


# Code Demonstration

1. R code for joining tables
1. R code for correlation 
1. Image? 

# Visualization

1. Link?
1. Image? 






