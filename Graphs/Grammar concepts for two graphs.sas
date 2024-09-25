* Grammar of two graphics;

proc sgplot data=sashelp.class;
	scatter y=weight x=height;
	run;

* Data source: empirical values from a SAS data set;
* Variables:  emprical values, given;
* Algebra/relationship: crossed, each variable denotes a coordinate along an axis;
* Levels of measure: continuous by continuous;
* Transformations:  none;
* Geometric objects:  points;
* Coordinate system:  cartesian;
* Aesthetics:  default;
* Facets:  one frame;
* Guides:  axes;


proc sgplot data=sashelp.class;
	vbar age;
	run;

* Data source: empirical values from a SAS data set;
* Variables:  one empirical values, the other to be derived;
* Algebra/relationship: crossed, each variable denotes a coordinate along an axis;
* Levels of measure: categorical by continuous;
* Transformations:  counts within category;
* Geometric objects:  areas (or very fat lines);
* Coordinate system:  cartesian;
* Aesthetics:  default;
* Facets:  one frame;
* Guides:  axes;
