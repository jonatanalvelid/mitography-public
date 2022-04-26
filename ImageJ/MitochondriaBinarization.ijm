// Binarize STED mitochondria image
// Version: 2020-05-08
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
if(tom20 == 1) {
	run("Gaussian Blur...", "sigma=0.06 scaled");
	if(localthreshold == 1) {
		run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=15 parameter_1=0 parameter_2=0 white");
	} else {
		run("Make Binary");
		run("Fill Holes");
	}
} else if(omp25 == 1) {
	run("Gaussian Blur...", "sigma=0.04 scaled");
	run("Duplicate...", "title=mitobinaryaltraw");
	rename("mitobinaryalt2");
	selectWindow("mitobinaryalt2");
	setThreshold(2, 255);
	run("Convert to Mask");
	run("Make Binary");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Divide...", "value=255.000");
	imageCalculator("Multiply create", "mitobinaryaltraw","mitobinaryalt2");
	rename("mitobinaryalt");
	//run("Gaussian Blur...", "sigma=0.08 scaled");
	if(localthreshold == 1) {
		// WORKS GOOD FOR TMRE (without normalizing image between binarization steps)
		//localradius = 8;
		//contrastthresh = 3;
		// ATTEMPT FOR MITOSOX - 8-15 works fine for all images, 3 of them it's a bit borderline, but it's the best compromise (since it seems like we do have to compromise)
		//localradius = 8;
		//contrastthresh = 15;
		// ATTEMPT FOR TMRE (normalized) - 7-15 works fine for: 1-24, (13 - very tricky, mitos with OMP-gradients), (17 - missing some small mitos, works with 6-15)
		localradius = 8;
		contrastthresh = 3;
		selectWindow("mitobinaryalt");
		//Normalize masked original image.
		run("Enhance Contrast...", "saturated=0 normalize");
		run("Duplicate...", "title=mitobinaryalt");
		rename("bernsen");
		//Do local thresholding with desired method and parameters
		run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=" + localradius + " parameter_1=" + contrastthresh + " parameter_2=0 white");
		run("Erode");
		run("Dilate");
		run("Fill Holes");

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
