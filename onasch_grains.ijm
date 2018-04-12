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







 // Function: Rotate, translate, scale, & select combation
// note: selection must already be centred
// half_true is the condition for the 0.5 offset.
function selectionCombo(xPoints,yPoints,angle,degrees_true,scale_factor,x_offset,y_offset,half_true){
	x_centre = 0; y_centre = 0;
	if(half_true){half = 0.5;}else{half = 0;}
	if(degrees_true){ angle = PI*angle/180; }
	cos_theta = cos(angle);
	sin_theta = sin(angle);
	
	x_new = Array.copy(xPoints);
	y_new = Array.copy(yPoints);
	
	for(i=0; i<x_new.length; i++){
		x_new[i] = scale_factor*(cos_theta*(xPoints[i]-x_centre) - sin_theta*(yPoints[i]-y_centre)) + x_centre + x_offset + half;
		y_new[i] = scale_factor*(sin_theta*(xPoints[i]-x_centre) + cos_theta*(yPoints[i]-y_centre)) + x_centre + y_offset + half;
	}
	makeSelection("polygon",x_new,y_new);
}





for(n=0; n<nResults; n++){
	x = getResult("X",n);
	y = getResult("Y",n);
	r_min = getResult("Min",n);
	r_max = getResult("Max",n);
	ratio = getResult("R",n);
	phi = getResult("Phi",n);
	
}
