/* Quick Orientation Plot
 *
 * Jeffrey N. Murphy, 2018
 *	
 *	Plot the results from onasch_grains.ijm
 *	
 */

// User Inputs

// Plot Method
// Choose "a" or "b"
// "a" = plot relative to decrease; 
// "b" = plot relative to maximum shortening

method = "a"; 

// Plot Dimensions
radius = 100;
margin = 10;

// Colour Values (range 0-255)
grey1 = 220;
grey2 = 240;
data1 = 30;
data2 = 35;

// Fit Ellipse
c_fit = "440066ff"; //Colour: orangered = FF5700, alpha = 0.25 => 44
w_fit = 3; // linewidth in pixels





newImage("Plot", "8-bit white", 2*(radius+margin), 2*(radius+margin), 1);
centre = radius + margin;
makeOval(margin,margin,2*radius,2*radius);
changeValues(255,255,grey1);
run("Select None");

xpts = newArray(2*nResults);
ypts = newArray(2*nResults);
theta = newArray(2*nResults);

if(method=="b"){
	scale = 0;
	for(n=0; n<nResults; n++){scale=maxOf(scale,getResult("PctShort",n));}
}
else if(method=="a"){
	scale = 1;
}

for(n=0; n<nResults; n++){
	i = getResult("ID1",n);
	j = getResult("ID2",n);
	pct_short = getResult("PctShort",n);
	angle = getResult("Angle",n);
	if(method=="b"){ L = pct_short/scale*radius; }
	else if(method=="a"){ L = (100-pct_short)/100*radius; }

	x = L*cos(PI/180*angle)+centre;
	y = L*sin(PI/180*angle)+centre;
	xpts[n] = x;
	ypts[n] = y;
	theta[n] = angle;
	setPixel(x,y,data1);
	// Mirror
	x = L*cos(PI/180*(180+angle))+centre;
	y = L*sin(PI/180*(180+angle))+centre;
	setPixel(x,y,data2);
	xpts[n+nResults] = x;
	ypts[n+nResults] = y;
	theta[n+nResults] = angle+180;
}

rank_theta = Array.rankPositions(theta);
xnew = newArray(2*nResults);
ynew = newArray(2*nResults);
for(i=0; i<xnew.length; i++){
	xnew[i] = xpts[rank_theta[i]];
	ynew[i] = ypts[rank_theta[i]];
}


// makeSelection("Polygon",xpts,ypts);
makeSelection("Polygon",xnew,ynew);
wait(2000);
run("Fit Ellipse"); 
changeValues(grey1,grey1,grey2);
Overlay.addSelection(c_fit,w_fit);
Overlay.show();
run("Select None");

// https://imagej.nih.gov/ij/macros/DrawEllipse.txt
  List.setMeasurements;
  print(List.getList); // list all measurements
  x = List.getValue("X");
  y = List.getValue("Y");
  a = List.getValue("Major");
  b = List.getValue("Minor");
  angle = List.getValue("Angle");
  AR = List.getValue("AR");