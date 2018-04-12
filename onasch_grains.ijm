/*   Onasch Grain Overlaps
 * 
 *   Jeffrey N. Murphy, 2018
 *   updated: 2018-04-11
 *  
 *   ImageJ macro to determine overlaps between  
 *   pairs of ellipses that partially overlap
 *   (their perimiters intersect at 2 points)
 *   and to calculate the compression perpendicular
 *   to the interface as per Onasch (1993).
 * 
 *   Data in CSV File:
 *     x   :  x coordinate (px)
 *     y   :  y coordinate (px)
 *     max :  maximum radius of an ellipse (px)
 *     min :  minimum radius of an ellipse (px)
 *     R   :  ellipse ratio ( max / min)
 *     Phi :  orientation of the long axis of ellipse
 *   
 *     ID,X,Y,Max,Min,Area,R,Phi
 *   
 *   
 *   If the CSV data is not in pixel (px) units, then 
 *   change the 'scale_factor' to a px/<unit> value.
 * 
 * Notes:
 * 
 * makeEllipse(x1, y1, x2, y2, aspectRatio)
 *   Creates an elliptical selection, 
 *   where x1,y1,x2,y2 specify the major axis of the ellipse 
 *   and aspectRatio (<=1.0) is the ratio of the 
 *   lengths of minor and major axis.
 * 
 */


// User Inputs:

scale_factor = 1;//76/100; // px / um




// Macro
 

function rotateLine(x_centre,y_centre,length,angle_deg){
	// x1, y1, x2, y2
	a = newArray(4);
	angle = PI*angle_deg/180;
	cos_theta = cos(angle);
	sin_theta = sin(angle);

	// X
	a[0] = x_centre - length/2*cos_theta;
	a[2] = x_centre + length/2*cos_theta;
	// Y
	a[1] = y_centre - length/2*sin_theta;
	a[3] = y_centre + length/2*sin_theta;
	return a;
}




Overlay.clear;

// Drawing Ellipses
for(n=0; n<nResults; n++){
	x = scale_factor*getResult("X",n);
	y = scale_factor*getResult("Y",n);
	r_min = scale_factor*getResult("Min",n);
	r_max = scale_factor*getResult("Max",n);
	d_max = 2*r_max;
	ratio = getResult("R",n);
	phi = getResult("Phi",n);
	aspectRatio = 1/ratio; // inverse
	a = rotateLine(x,y,d_max,phi);
	makeEllipse( a[0],a[1],a[2],a[3], aspectRatio);
	strokeColor =  "0066ff";
	strokeWidth = 5;
	Overlay.addSelection(strokeColor, strokeWidth);
	Overlay.show;
}


for(n=0; n<nResults-1; n++){
	x = scale_factor*getResult("X",n);
	y = scale_factor*getResult("Y",n);
	r_min = scale_factor*getResult("Min",n);
	r_max = scale_factor*getResult("Max",n);
	d_max = 2*r_max;
	ratio = getResult("R",n);
	phi = getResult("Phi",n);
	aspectRatio = 1/ratio; // inverse
	a = rotateLine(x,y,d_max,phi);
	makeEllipse( a[0],a[1],a[2],a[3], aspectRatio);
	fullLoopCoords();
	getSelectionCoordinates(xA,yA);
	for(m=1; m<nResults; m++){
		xM = scale_factor*getResult("X",m);
		yM = scale_factor*getResult("Y",m);
		r_minM = scale_factor*getResult("Min",m);
		r_maxM = scale_factor*getResult("Max",m);
		d_maxM = 2*r_maxM;
		ratioM = getResult("R",n);
		phiM = getResult("Phi",n);
		aspectRatioM = 1/ratioM; // inverse
		b = rotateLine(xM,yM,d_maxM,phiM);
		makeEllipse( b[0],b[1],b[2],b[3], aspectRatioM);
		fullLoopCoords();
		getSelectionCoordinates(xB,yB);

		// Compare
		
	}
}




