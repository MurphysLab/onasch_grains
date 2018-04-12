// Ellipse Intersections
// Jeffrey N. Murphy, 2018


function segmentIntersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2){
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
		if(a>=1 && b<=1 && b>=0){correct = 1;}else{correct = 0;}// this should preclude all values except the desired intersection
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
	getSelectionCoordinates(xpts,ypts);
	xnew = Array.concat(xpts,xpts[0]);
	ynew = Array.concat(ypts,ypts[0]);
	makeSelection("polyline",xnew,ynew);
}








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
getSelectionCoordinates(xpts1,ypts2);

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
getSelectionCoordinates(xpts2,ypts2);
makeSelection("polyline",xpts2,ypts2);

print(xpts2[0])
print(xpts2[xpts2.length-1]);

print(ypts2[0])
print(ypts2[ypts2.length-1]);






