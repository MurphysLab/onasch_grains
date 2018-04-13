/* Near-Zero Overlaps MWE
 *  (Minimal Working Example)
 *  Jeffrey N. Murphy
 *  2018-04-12
 */

newImage("NZO", "8-bit white", 100,100, 1);

xp = newArray(86.1544, 86.1393);
yp = newArray(21.1459, 21.1538);

makeSelection("line",xp,yp);

if(selectionType()==-1){print("There is no active selection.");}
else{print("Okay, so there is a selection.");}

Overlay.addSelection("red", 1);
Overlay.show;
