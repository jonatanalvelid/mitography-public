// Binarize STED mitochondria image
// Version: 2020-11-17
run("Conversions...", " ");

noImages = 1;
//seems to be necessary in fixed samples where the membrane labeling is more dotty (OMP25 vs Tom20 rather than live vs fixed).
allmito = 1;  //for counting all mito, or deleting the smallest and big ones for example, to get less noise
localthreshold = 1;  //try local thresholding, Bernsen variant. Seems to work nicely on well-labelled OMP25 images.
localthresholdmethod = "Bernsen";  //local thresholding method to use.
thresh1 = 37;
thresh2 = thresh1-5;
smoothsize = 0.03;

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

run("Duplicate...", "title=mitobinaryaltraw");
rename("mitobinaryalt2");
selectWindow("mitobinaryalt2");
run("Gaussian Blur...", "sigma="+smoothsize+" scaled");
selectWindow("mitobinaryaltraw");
setThreshold(thresh1, 255);
run("Convert to Mask");
run("Make Binary");
//run("Erode");
run("Dilate");
run("Dilate");
//run("Dilate");
run("Divide...", "value=255.000");
imageCalculator("Multiply create", "mitobinaryaltraw","mitobinaryalt2");
rename("mitobinaryalt");
//run("Gaussian Blur...", "sigma=0.08 scaled");
selectWindow("mitobinaryalt");

run("Duplicate...", "title=mitobinaryalt");
rename("bernsen");

setThreshold(thresh2, 255);
run("Convert to Mask");
run("Make Binary");

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
