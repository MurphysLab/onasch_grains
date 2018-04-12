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
	// First Ellipse (A)
	ID_A = getResult("ID",n);
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
		// Second Ellipse (B)
		ID_B = getResult("ID",m);
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

		// Find Intersections Between Ellipses A & B

		n_int_EE = countIntersectionsBrute(xptsA,yptsA,xptsB,yptsB);
		print("EE Intersections: " + n_int_EE);
		getSelectionCoordinates(xI,yI);
		Overlay.addSelection("880099FF", strokeWidth);
		Overlay.show;
		
		extend = 100;
		perpNormMidPtVectorCW(xI,yI,extend);
		getSelectionCoordinates(xV,yV);
		Overlay.addSelection("88FF2200", strokeWidth);
		Overlay.show;
		
		n_int_LE = ellipseLineIntersections(xV,yV,xptsA,yptsA,xptsB,yptsB);
		print("LE Intersections: " + n_int_LE);
		Overlay.addSelection("88FF2200", 1);
		Overlay.show;



		
		
	}
}


// FUNCTIONS



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




// From Ellipse Intersections



function segmentIntersectionX(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2){
	// Note that "B" vector is the 
	// p(t) = u0 + a * v0			// "A"" vector
	// p(s) = u1 + b * v1			// "B" vector
	x00 = xa1; y00 = ya1; 			// u0 = (x00,y00)
	x01 = xa2 - xa1; y01 = ya2 - ya1;	// v0 = (x01,y01)
	x10 = xb1; y10 = yb1;			// u1 = (x10,y10)
	x11 = xb2 - xb1; y11 = yb2 - yb1;	// v1 = (x11,y11)
	crossproduct2D = x01*y11 - y01*x11;	// if crossproduct2D == 0, the lines are parallel
	//print(crossproduct2D);
	if(crossproduct2D != 0){
		d = x11 * y01 - x01 * y11;				// determinant
		b = (1/d) * ( (x00 - x10)*y01 - (y00 - y10)*x01 ); 	// indicates position on the "B" vector
		a = (1/d) * ( (x00 - x10)*y11 - (y00 - y10)*x11 ); 	// indicates position on the "A" vector
		xint = x00 + a*x01; yint = y00 + a*y01;			// the (xint,yint) where the lines intersect
		if(a>=0 && a<=1 && b<=1 && b>=0){correct = 1;}else{correct = 0;}// this should preclude all values except the desired intersection
		//if(correct){
		//print("correct: " + correct + " & CP: " + crossproduct2D + " & a: " + a + " & b: " + b + " & xint: " + xint + " & yint: " + yint);
		//}
		// CP, a, b, xint, yint,
		return newArray(correct,crossproduct2D,a,b,xint,yint);
	}
	else { 
		return newArray(0,0,0,0,0,0);
		//print("correct: " + 0 + " & CP: " + 0 + " & a: " + (1/0) + " & b: " + (1/0) + " & xint: " + "---" + " & yint: " + "---");
	}
	// Note: if I was solely interested in overlapping segments, could use box/range overlap to test...
}


function segmentIntersectionLE(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2){
	// A is line; B is ellipse
	// Note that "B" vector is the 
	// p(t) = u0 + a * v0			// "A"" vector
	// p(s) = u1 + b * v1			// "B" vector
	x00 = xa1; y00 = ya1; 			// u0 = (x00,y00)
	x01 = xa2 - xa1; y01 = ya2 - ya1;	// v0 = (x01,y01)
	x10 = xb1; y10 = yb1;			// u1 = (x10,y10)
	x11 = xb2 - xb1; y11 = yb2 - yb1;	// v1 = (x11,y11)
	crossproduct2D = x01*y11 - y01*x11;	// if crossproduct2D == 0, the lines are parallel
	//print(crossproduct2D);
	if(crossproduct2D != 0){
		d = x11 * y01 - x01 * y11;				// determinant
		b = (1/d) * ( (x00 - x10)*y01 - (y00 - y10)*x01 ); 	// indicates position on the "B" vector
		a = (1/d) * ( (x00 - x10)*y11 - (y00 - y10)*x11 ); 	// indicates position on the "A" vector
		xint = x00 + a*x01; yint = y00 + a*y01;			// the (xint,yint) where the lines intersect
		// Only B (the ellipse) is limited
		if(b<=1 && b>=0){correct = 1;}else{correct = 0;}// this should preclude all values except the desired intersection
		//if(correct){
		//print("correct: " + correct + " & CP: " + crossproduct2D + " & a: " + a + " & b: " + b + " & xint: " + xint + " & yint: " + yint);
		//}
		// CP, a, b, xint, yint,
		return newArray(correct,crossproduct2D,a,b,xint,yint);
	}
	else { 
		return newArray(0,0,0,0,0,0);
		//print("correct: " + 0 + " & CP: " + 0 + " & a: " + (1/0) + " & b: " + (1/0) + " & xint: " + "---" + " & yint: " + "---");
	}
	// Note: if I was solely interested in overlapping segments, could use box/range overlap to test...
}



function ellipseLineIntersections(xL,yL,xA,yA,xB,yB){
	// Intersections of one line (L) and two ellipses (A&B)
	x_int = newArray(0);
	y_int = newArray(0);
	a_int = newArray(0); // Record the line's scalar to determine sequence at the end
	for(i=1; i<xA.length; i++){
		a = segmentIntersectionLE(xL[0],yL[0],xL[1],yL[1],xA[i-1],yA[i-1],xA[i],yA[i]); //xB[j-1],yB[j-1],xB[j],yB[j]
		if(a[0]){
			//print("INT "+ i);
			a_int = Array.concat(a_int,a[2]);
			x_int = Array.concat(x_int,a[4]);
			y_int = Array.concat(y_int,a[5]);
		}
	}
	for(j=1; j<xB.length; j++){
		a = segmentIntersectionLE(xL[0],yL[0],xL[1],yL[1],xB[j-1],yB[j-1],xB[j],yB[j]);
		if(a[0]){
			print("INT "+ j);
			a_int = Array.concat(a_int,a[2]);
			x_int = Array.concat(x_int,a[4]);
			y_int = Array.concat(y_int,a[5]);
		}
	}
	// ideally should check for duplicates before the end

	if(a_int.length == 4){
		// new x & y positions,
		// arranged by order of scalar a.
		x_pos = newArray(4);
		y_pos = newArray(4);
		rank = Array.rankPositions(a_int); 
		for(i=0; i<4; i++){
			x_pos[i] = x_int[rank[i]];
			y_pos[i] = y_int[rank[i]];
		}
	
		makeSelection("polyline",x_pos,y_pos);
	}
	return x_int.length;
}







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

function fullLoopCoords(){
	// extend selctions of ellipses or polyline shapes to make a full loop
	getSelectionCoordinates(xpts,ypts);
	xnew = Array.concat(xpts,xpts[0]);
	ynew = Array.concat(ypts,ypts[0]);
	makeSelection("polyline",xnew,ynew);
}

function countIntersectionsBrute(xA,yA,xB,yB){
	x_int = newArray(0);
	y_int = newArray(0);
	for(i=1; i<xA.length; i++){
		for(j=1; j<xB.length; j++){
			a = segmentIntersectionX(xA[i-1],yA[i-1],xA[i],yA[i],xB[j-1],yB[j-1],xB[j],yB[j]);
			if(a[0]){
				// draw intersection
				/*
				xB_int = a[3]*(xB[j]-xB[j-1])+xB[j-1];
				xA_int = a[2]*(xA[i]-xA[i-1])+xA[i-1];
				yB_int = a[3]*(yB[j]-yB[j-1])+yB[j-1];
				yA_int = a[2]*(yA[i]-yA[i-1])+yA[i-1];
				makeLine(xA_int,yA_int,xB_int,yB_int);
				Overlay.addSelection("ff0000",2);
				Overlay.show;
				wait(300);
				makeOval(xA_int-1,yA_int-1,2,2);
				Overlay.addSelection("",0,"CCFFFF00");
				wait(300);
				
				print(""+i+", " + j);
				Array.print(a);
				makeLine(xA[i-1],yA[i-1],xA[i],yA[i]);
				Overlay.addSelection("0066ff",2);
				Overlay.show;
				makeLine(xB[j-1],yB[j-1],xB[j],yB[j]);
				Overlay.addSelection("008822",2);
				Overlay.show;
				*/
				x_int = Array.concat(x_int,a[4]);
				y_int = Array.concat(y_int,a[5]);
				//wait(200);
			}
		}
	}
	// ideally should check for duplicates before the end
	makeSelection("polyline",x_int,y_int);
	return x_int.length;
}

function perpNormMidPtVectorCW(xA,yA,multiply){
	// note: arrays should have length of 2
	// extend is scaled length 
	// CCW: (x,y) -> (-y,x)
	// CW:  (x,y) -> (y,-x)
	x_centre = 0.5*(xA[0]+xA[1]);
	y_centre = 0.5*(yA[0]+yA[1]);
	L = sqrt( pow(xA[1]-xA[0],2) + pow(yA[1]-yA[0],2) );
	x_cw = ( yA[1]-yA[0] ) / L;
	y_cw = -1 * ( xA[1]-xA[0] ) / L;
	xv = newArray(x_centre,x_centre+x_cw*multiply);
	yv = newArray(y_centre,y_centre+y_cw*multiply);
	makeSelection("line",xv,yv);
}


