// Binarize STED mitochondria image
// AA Experiment 5
// Version: 2021-02-01
run("Conversions...", " ");

thresh1 = 17;
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
run("Dilate");
run("Dilate");
run("Divide...", "value=255.000");
imageCalculator("Multiply create", "mitobinaryaltraw","mitobinaryalt2");
rename("mitobinaryalt");
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
