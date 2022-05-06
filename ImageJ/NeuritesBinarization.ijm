// Binarize an image (map2, mito membrane marker bkg, etc) to a binary
// image of the whole neurites, for lengthwise distance-to-soma analyses

// adjust percentImageBackground number to ~the percent of the image
// that is NOT covered with dendrite marker.
// Normally values around 0.7-0.9.
// adjust thresh to background 
percentImageBackground = 0.85;
thresh = 3;
numsmooth = 3;
numdil = 8;
numerode = 5;

setForegroundColor(255, 255, 255);

imnameor = getTitle();
run("Duplicate...", "title=originalImage");
selectWindow("originalImage");

for (i = 0; i < numsmooth; i++) {
	run("Smooth");
}
getRawStatistics(nPixels, mean, min, max, std, histogram);
brightcount = 0;
countedpixels = 0;
while (countedpixels < nPixels * percentImageBackground) {
	countedpixels = countedpixels + histogram[brightcount];
	brightcount = brightcount + 0.1;
}

setThreshold(thresh, max);
setOption("BlackBackground", true);
run("Convert to Mask");


for (i = 0; i < numdil; i++) {
	run("Dilate");
}
for (i = 0; i < numerode; i++) {
	run("Erode");
}

originalMask = getImageID();
run("Duplicate...", "title=subsetmaskImage");
selectWindow("subsetmaskImage");

// select all background blob-objects based on certain size
// adjust max blob size (3000 below)
run("Analyze Particles...", "size=0-3000 pixel add"); 
run("Select All");
run("Clear");
roiManager("fill");
selectWindow("ROI Manager");
run("Close");
subsetMask = getImageID();

// another round of thresholding and mask creation based on those 'tiny' objects you want to exclude
imageCalculator("Subtract create", originalMask, subsetMask); // simply subtract the 'tiny' objects from the original mask

// last round of thresholding... to get the final binary image
setAutoThreshold("Default dark");
setAutoThreshold("Huang dark");
run("Create Mask");

filename = substring(imnameor,0,9)+"_neuritesbinary"+".tif";
saveAs("Tiff", "E:\\PhD\\data_analysis\\Temp\\"+filename);
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");