README.md

This is an ImageJ macro for determining features of grain boundary interfaces, wherein the grains are modelled by ellipses which represent a reconstruction of the original grain boundaries. 


1. The straight-line compromise boundary

The purpose is described in Onasch (1993); Pierson (2014) is an open-access thesis with a description of the method. 





Two sample data files have been provided by _____. The TIF is an image of a thin section of material under a microscope with the desired ellipses drawn on it. The image file is unnecessary, however it provides a check for the data. The CSV is a data file containing coordinates for the ellipses drawn using EllipseFit. 

Data in CSV file: *ID,X,Y,Max,Min,Area,R,Phi*

* ID  :  id number for each ellipse
* x   :  x coordinate (px)
* y   :  y coordinate (px)
* max :  maximum radius of an ellipse (px)
* min :  minimum radius of an ellipse (px)
* R   :  ellipse ratio ( max / min)
* Phi :  orientation of the long axis of ellipse





## References:

1. Charles M. Onasch, "Determination of pressure solution shortening in sandstones", *Tectonophysics*, **1993**, 227, pp. 145-159. DOI: [](https://doi.org/10.1016/0040-1951(93)90092-X)
2. Nichole Pierson, "Assessing Layer Parallel Shortening in the Easter Colorado Front Range Using Tin Section Analysis and Analog Sandbox Models". MSc Thesis, University of Nebraska - Lincoln, Department of Earth and Atmospheric Sciences, 2014. URL: [http://digitalcommons.unl.edu/geoscidiss/51](htp://digitalcommons.unl.edu/geoscidiss/51)