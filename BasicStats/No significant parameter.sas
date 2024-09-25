* A model that explains a lot of variations without
   any individually significant parameters;

data class;
	set y.class;
	female = sex = "F";
	hsq = height*height;
	ageh = age*height;
	run;

proc reg data=class;
	model weight = female height hsq age ageh;
	run;

proc glm data=class;
	class sex;
	model weight = sex age|height height*height / ss2;
	run;

proc reg data=class;
	model weight = female height hsq age ageh;
	test hsq, ageh;
	run;

proc glm data=class;
	class sex;
	model weight = sex age height ;
	run;
