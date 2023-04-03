// Binarize STED PEX image
// Type 1 - global thresholding
run("Conversions...", " ");
imgname = getTitle()

// Parameters
// Thresholds to adjust to signal and background levels
thresh1 = 15;
thresh2 = thresh1-5;
smoothsize = 0.03;
// Save folder of binary image
savefolder = "D:/Data analysis/Mitography/AA-PEX/analysis-pex_start/exp1aa/pexbinary/"
// Img number
imgnumber = substring(imgname, 6, 9)

getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);

run("Set Scale...", "distance=1 known="+pixelWidth+" pixel=1 unit=micron");
	
wait(500);

imnameor = getTitle();
imname = substring(imnameor, 0, 9);

// Taking the images and renaming them in a standard way.
rename("PexOriginalImageSoma");
run("8-bit");

// Starting the analysis by binarizing the pexchondria image and calculating important parameters for them.
selectWindow("PexOriginalImageSoma");
run("Duplicate...", "title=PexOriginalImageSoma");
rename("pexbinaryaltraw");
selectWindow("pexbinaryaltraw");

run("Duplicate...", "title=pexbinaryaltraw");
rename("pexbinaryalt2");
selectWindow("pexbinaryalt2");
run("Gaussian Blur...", "sigma="+smoothsize+" scaled");
selectWindow("pexbinaryaltraw");
setThreshold(thresh1, 255);
run("Convert to Mask");
run("Make Binary");
run("Dilate");
run("Dilate");
run("Divide...", "value=255.000");
imageCalculator("Multiply create", "pexbinaryaltraw","pexbinaryalt2");
rename("pexbinaryalt");
selectWindow("pexbinaryalt");

run("Duplicate...", "title=pexbinaryalt");
rename("bernsen");

setThreshold(thresh2, 255);
run("Convert to Mask");
run("Make Binary");
run("Erode");
run("Dilate");

selectWindow("pexbinaryalt");
rename("pexbinary");
selectWindow("pexbinary");
run("Close");
selectWindow("pexbinaryalt2");
run("Close");
selectWindow("pexbinaryaltraw");
run("Close");
selectWindow("PexOriginalImageSoma");
run("Close");

// Save binary image
saveAs("Tiff", savefolder+"Image_"+imgnumber+"-pexbinary.tif");
run("Close");

