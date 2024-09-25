* Text Input and Merge Data exercise;

* We have some data on the strength of El Niño/La Niña, and we would
    like to see if it is related to the Mendota ice cover data.  The
    strength of El Niño/La Niña is rated on a scale of 1 to 7 in our
    data source (the original NOAA data is more fine grained both in
    temperature and time, but we'll leave that for another day).;

*--------;
* Part 1 ;
*--------;
* The first problem is the form of the data we are given.  Write a 
    SAS DATA step that reads in these data.  Recode the strength of
    the effect on a scale of 1 = Weak La Niña to 7 = Strong La Niño
    (where 4 = the omitted years).;

El Niño	
Weak	
1951	
1963	
1968	
1969	
1976	 
1977	 
2004	 
2006		 
Mod	
1986	
1987	
1994	
2002	
Strong	
1957	
1965	
1972	
1982	
1991	
1997	
2009	
La Niña		
Weak		 	
1950	
1956	
1962	
1967	
1971	
1974	
1984	
1995	
2000
Mod	
1954	
1964	
1970	
1998	
1999	
2007	
2010	
Strong
1955
1973
1975
1988

* data from http://ggweather.com/enso/oni.htm;

* Hint:  input each line of text into a temporary variable, test its
    contents, and assign its data to the appropriate variable.  Use a
    RETAIN statement to prevent data values from being reset to missing
    on each execution of the DATA step.;
* We will eventually want the year to be a numeric variable, so be sure
    to make that conversion.  You can use the INPUT function to do
    this (the INPUT *function* works similar to an INFORMAT).;

*--------;
* Part 2 ;
*--------;
* The next task is to fill in the missing years and code their strength
    as 4.  One approach to this is to create a second data set that
    lists all the years in our data range (1950 to 2010), then merge
    the two data sets, replacing the missing strength of El Niño/La Niña
    with a 4.;

* How many strong El Niño years have there been?  Check you data set
    against the text data above.  On a scale of 1 to 7, what has the
    average effect of El Niño/La Niña been?  Why do we expect it to be
    nearly 4?;

*--------;
* Part 3 ;
*--------;
* Next we merge the El Niño/La Niña data with the Mendota Ice data
    (located in y:\sas\data).  The years given in the data sets
    do not match.  In the El Niño/La Niña data the year is when
    a given Winter started, while in the Mendota Ice data it is
    the year of the Winter's end.  Fix this and merge the data
    sets.;

* Is there a correlation between duration of ice cover (the variable
    "days") and the strength of El Niño/La Niña? Is there a 
    correlation between year and El Niño/La Niña?  What does a
    regression model suggest if we use both strength and year
    to predict ice cover?  Which model predicts an earlier
    opening of the Lake?;
