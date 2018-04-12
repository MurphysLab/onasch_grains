# Onasch Grains

This is an ImageJ macro for determining features of grain boundary interfaces, wherein the grains are modelled by ellipses which represent a reconstruction of the original grain boundaries. 

Using the intersections of these reconstructed grain boundaries, *i.e.* the grain-fitting ellipses, a straight-line compromise boundary is determined. From this, the width of the compressed region as well as the total width are determined along the line perpendicular to the midpoint of the compromise boundary. 

The process, including its purpose and technical significance, is described in Onasch (1993); Pierson (2014) is an open-access thesis with a description of the method. 


![Original figure from Onasch (1993)](/img/onasch_original.png)

This process has been adapted using ImageJ to solve the analysis of overlapping ellipses:

![Figure outlining process, adapted from Onasch (1993)](/img/onasch_grains_algorithm_figure.png)



## Method

The method used by this algorithm determines the points at which two ellipses intersect using the polygonal approximation of the ROI in ImageJ. Typically ImageJ's **makeEllipse** function produces 72-sided polygons when rendered as regions of interest (ROIs). In practice, this means that the method is an approximation compared to analytic calculations of ellipse intersections. However this is sufficinetly accurate for the intended purpose and has the added benefit that it can be extended to any other pair of [convex polygons](https://en.wikipedia.org/wiki/Convex_polygon). 

* **ellipse_intersections.ijm** : The "Ellipse Intersections" macro provides a simple demonstration of the method which requires no additional data input. Simply open with ImageJ (or [FIJI](http://fiji.sc/Fiji)) and click ***Run*** to execute and see the results.

### The algorithm: 

1. For all ellipses:
    1. Make ellipse ROI
    1. Rotate, translate, and make the intervals regular
    1. add to ROI manager.
2. Loop through, comparing all pairs of ellipses
    1. Get the ROIs
    1. Check for intersections
    1. If they intersect, determine the line between the intersection points
    1. Find midpoint; calculate line perpendicular (L).
    1. Find points where L intersects the two ellipses.
    1. Calculate the min and max distances from those intersections
    1. Record distances.
    1. Draw the lines

In step 2.2, checking for intersections, check is performed, utilizing the nature of ellipses, to determine whether the distance between two ellipse centres is greater than the sum of the [semi-major axes](https://en.wikipedia.org/wiki/Semi-major_and_semi-minor_axes) of the ellipses. This provides time-savings relative to the process to determine where and if two polygons intersect for all pairs of polygons.


## Input Data 

The CSV is a data file containing coordinates for the ellipses drawn using EllipseFit. The output file may require editing to remove prefatory lines in order for ImageJ to recognize it (*i.e.* There should be no lines preceeding the column labels.)

The CSV file is expected to be organized with the following columns:

*ID,X,Y,Max,Min,Area,R,Phi*

* **ID**  :  id number for each ellipse
* **x**   :  centre x coordinate (px)
* **y**   :  centre y coordinate (px)
* **max** :  semi-major axis of the ellipse (px)
* **min** :  semi-minor axis of the ellipse (px)
* **R**   :  ellipse ratio ( max / min)
* **Phi** :  orientation of the long axis of ellipse

The image input is typically a TIF of a thin section of geological material under a petrographic microscope. The desired ellipses may already be drawn on it, however this is not a data input. The image file is unnecessary, however it provides a check for the data. 

Two sample data files have been provided by _____. 


## User Inputs



## Output Data

![Numbered ellipses on a blank canvas using input data.](/img/ellipse_input_blank_sm.png)
![Numbered ellipses on a blank canvas with compromise boundaries and compression axes drawn.](/img/results_blank_sm.png)


## References:

1. Charles M. Onasch, "Determination of pressure solution shortening in sandstones", *Tectonophysics*, **1993**, 227, pp. 145-159. DOI: [](https://doi.org/10.1016/0040-1951(93)90092-X)
2. Nichole Pierson, "Assessing Layer Parallel Shortening in the Easter Colorado Front Range Using Tin Section Analysis and Analog Sandbox Models". MSc Thesis, University of Nebraska - Lincoln, Department of Earth and Atmospheric Sciences, 2014. URL: [http://digitalcommons.unl.edu/geoscidiss/51](htp://digitalcommons.unl.edu/geoscidiss/51)