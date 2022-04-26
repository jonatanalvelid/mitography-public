// Binarize STED mitochondria image
run("Conversions...", " ");

noImages = 1;
//seems to be necessary in fixed samples where the membrane labeling is more dotty (OMP25 vs Tom20 rather than live vs fixed).
omp25 = 1;  //only one of these two should be 1, the other 0
tom20 = 0;  //only one of these two should be 1, the other 0
allmito = 1;  //for counting all mito, or deleting the smallest and big ones for example, to get less noise
localthreshold = 1;  //try local thresholding, Bernsen variant. Seems to work nicely on well-labelled OMP25 images.
localthresholdmethod = "Bernsen";  //local thresholding method to use.

getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);

run("Set Scale...", "distance=1 known="+pixelWidth+" pixel=1 unit=micron");
	
wait(500);

imnameor = getTitle();
imname = substring(imnameor, 0, 9);

//Taking the images and renaming them in a standard way.
rename("MitoOriginalImageSoma");
run("8-bit");

//Starting the analysis by binarizing the mitochondria image and calculating important parameters for them.
selectWindow("MitoOriginalImageSoma");
run("Duplicate...", "title=MitoOriginalImageSoma");
rename("mitobinaryaltraw");
selectWindow("mitobinaryaltraw");
//rename("mitobinaryaltraw2");
//selectWindow("mitobinaryaltraw2");

if(tom20 == 1) {
	run("Gaussian Blur...", "sigma=0.06 scaled");
	if(localthreshold == 1) {
		run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=15 parameter_1=0 parameter_2=0 white");
	} else {
		run("Make Binary");
		run("Fill Holes");
	}
} else if(omp25 == 1) {
	//run("Anisotropic Diffusion 2D", "number=20 smoothings=1 keep=20 a1=0.50 a2=0.90 dt=20 edge=5");
	//rename("mitobinaryaltraw");
	selectWindow("mitobinaryaltraw");
	run("Duplicate...", "title=mitobinaryaltraw");
	rename("mitobinaryalt2");
	selectWindow("mitobinaryalt2");
	run("Gaussian Blur...", "sigma=0.03 scaled");
	setThreshold(3, 255);
	run("Convert to Mask");
	run("Make Binary");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Divide...", "value=255.000");
	imageCalculator("Multiply create", "mitobinaryaltraw","mitobinaryalt2");
	rename("mitobinaryalt");
	if(localthreshold == 1) {
		//6h_5nM AA - Glucose + AA 5nM6h_DIV8_280420_PEX14_MAP_OMP25
		// ATTEMPT FOR PexAA (normalized) - 8-10 (smooth 0.03-0.03, thresh 6) works fine for: 
		// 3-4, 6-11, 13-14, 21, 25-27 (25-27 splits some up, can disregard that). 14/25 = quite good.
		//Fails: 5, 12 (many dimmer ones that should be considered), 15 (splits up some small that should not be split up), 18 (high neurite background, detects a lot of false small. thresh 10 works.), 19 (same issue, thresh 14 works), 20 (splits some up), 22 (misses some dimmer ones), 23-24 (splits some up, add some).
		localradius = 8;
		contrastthresh = 10;
		selectWindow("mitobinaryalt");
		//Normalize masked original image.
		run("Enhance Contrast...", "saturated=0 normalize");
		run("Gaussian Blur...", "sigma=0.03 scaled");
		run("Duplicate...", "title=mitobinaryalt");
		rename("bernsen");
		//Do local thresholding with desired method and parameters
		run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=" + localradius + " parameter_1=" + contrastthresh + " parameter_2=0 white");
		run("Erode");
		run("Dilate");
		//run("Fill Holes");

	} else {
		run("Make Binary");
		run("Fill Holes");
	}
}

selectWindow("mitobinaryalt");
rename("mitobinary");
selectWindow("mitobinary");
run("Close");
selectWindow("mitobinaryalt2");
run("Close");
selectWindow("mitobinaryaltraw");
run("Close");
selectWindow("MitoOriginalImageSoma");
run("Close");



//
//if(allmito == 1) {
//	if(tom20 == 1) {
//		run("Analyze Particles...", "size=0.015-Infinity display clear include add"); //for counting all, big and small MDVs
//	} else if(omp25 == 1) {
//		run("Analyze Particles...", "size=0.003-Infinity display clear include add"); //for counting all, big and small MDVs
//	}
//} else if(allmito == 0) {
//	//run("Analyze Particles...", "size=0.08-3.00 display exclude clear include add"); - for normal
//	//run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big ones
//	//run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big and small ones
//	run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for confocal
//}
//updateResults; 

//selectWindow("mitobinary");
//run("Duplicate...", "title=mitobinary2");
//selectWindow("mitobinary2");
//if(allmito == 1) {
//	if(tom20 == 1) {
//		run("Analyze Particles...", "size=0.015-Infinity display clear include add"); //for counting all, big and small MDVs
//	} else if(omp25 == 1) {
//		run("Analyze Particles...", "size=0.003-Infinity display clear include add"); //for counting all, big and small MDVs
//	}
//} else if(allmito == 0) {
//	//run("Analyze Particles...", "size=0.08-3.00 display exclude clear include add"); - for normal
//	//run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big ones
//	//run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big and small ones
//	run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for confocal
//}
//run("Flatten");
//
//length1 = nResults();
//
//wait(200);
//selectWindow("mitobinary");
//
//run("Close");
//run("Close");
