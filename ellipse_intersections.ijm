// Ellipse Intersections
// Jeffrey N. Murphy, 2018


newImage("New Image", "8-bit white", 1024, 1024, 1);

// hypothetical ellipses

Overlay.clear;


aspectRatio1 = 0.4;
angle_deg1 = 60; 
x_centre = getWidth/2+130;
y_centre = getWidth/2+70;
L1 = 580;
a = rotateLine(x_centre,y_centre,L1,angle_deg1);
makeEllipse(a[0],a[1],a[2],a[3], aspectRatio1);

strokeColor =  "ffbb00";
strokeWidth = 3;
Overlay.addSelection(strokeColor, strokeWidth);
Overlay.show;

fullLoopCoords();
getSelectionCoordinates(xptsA,yptsA);




aspectRatio2 = 0.75;
angle_deg2 = -20; 
x_centre = getWidth/2-65;
y_centre = getWidth/2-20;
L2 = 320;
a = rotateLine(x_centre,y_centre,L2,angle_deg2);
makeEllipse(a[0],a[1],a[2],a[3], aspectRatio2);

strokeColor =  "88ff00";
strokeWidth = 3;
Overlay.addSelection(strokeColor, strokeWidth);
Overlay.show;

fullLoopCoords();
getSelectionCoordinates(xptsB,yptsB);
//

// Check to see that "fullLoopCoords" worked.
if( (xptsB[0]==xptsB[xptsB.length-1]) && (yptsB[0]==yptsB[yptsB.length-1]) ){
	print("fullLoopCoords worked");
}
else{
	print("fullLoopCoords failed");
}

print("Ellipse A edges: " + (xptsA.length-1));
print("Ellipse B edges: " + (xptsA.length-1));


makeSelection("polyline",xptsA,yptsA);
wait(300);
makeSelection("polyline",xptsB,yptsB);
wait(300);

n_int_EE = countIntersectionsBrute(xptsA,yptsA,xptsB,yptsB);
print("EE Intersections: " + n_int_EE);
getSelectionCoordinates(xI,yI);
Overlay.addSelection("880099FF", strokeWidth);
Overlay.show;

extend = 1;
perpNormMidPtVectorCW(xI,yI,extend);
getSelectionCoordinates(xV,yV);
Overlay.addSelection("88FF2200", strokeWidth);
Overlay.show;

n_int_LE = ellipseLineIntersections(xV,yV,xptsA,yptsA,xptsB,yptsB);
print("LE Intersections: " + n_int_LE);
Overlay.addSelection("88FF2200", 1);
Overlay.show;











// Functions


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
