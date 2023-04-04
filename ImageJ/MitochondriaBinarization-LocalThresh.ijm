// Binarize STED mitochondria image
// Type 2 - local thresholding
run("Conversions...", " ");

setOption("BlackBackground", true);

//////////////////////////////////

// Threshold to adjust to background levels
thresh1 = 2;
// Adjust localradius and contrastthresh for local thresholding depending on the signal level and resolution
//localradius = ~7-10;	contrastthresh = ~3-15;
localradius = 8;
contrastthresh = 3;

savefolder = "C:\\SAVE\\PATH\\HERE\\"

//////////////////////////////////

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

// Adjust gaussian blurring radius if needed
run("Gaussian Blur...", "sigma=0.04 scaled");
run("Duplicate...", "title=mitobinaryaltraw");
rename("mitobinaryalt2");
selectWindow("mitobinaryalt2");
setThreshold(thresh1, 255);
run("Convert to Mask");
run("Make Binary");
run("Erode");
run("Dilate");
run("Dilate");
run("Divide...", "value=255.000");
imageCalculator("Multiply create", "mitobinaryaltraw","mitobinaryalt2");
rename("mitobinaryalt");

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

filename = substring(imnameor,0,9)+"_MitoBinary"+".tif";
saveAs("Tiff", savefolder+filename);

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
