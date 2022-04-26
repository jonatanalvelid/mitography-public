// Binarize an OMP (or similar mitochondria marker) image to a binary
// image of the whole neurites, for lengthwise distance-to-soma analyses

// adjust this percentImageBackground number to ~the percent of the image
// that is NOT covered with dendrite marker.
// Normally, values around 0.7-0.9 is good.
percentImageBackground = 0.95;
thresh = 4

setForegroundColor(255, 255, 255);

imnameor = getTitle();
run("Duplicate...", "title=originalImage");
selectWindow("originalImage");

for (i = 0; i < 3; i++) {
	run("Smooth");
}
getRawStatistics(nPixels, mean, min, max, std, histogram);
brightcount = 0;
countedpixels = 0;
while (countedpixels < nPixels * percentImageBackground) {
	countedpixels = countedpixels + histogram[brightcount];
	brightcount = brightcount + 0.1;
}

//setThreshold(brightcount, max);
setThreshold(thresh, max);
setOption("BlackBackground", true);
run("Convert to Mask");


for (i = 0; i < 8; i++) {
	run("Dilate");
}
for (i = 0; i < 2; i++) {
	run("Erode");
}

originalMask = getImageID();
run("Duplicate...", "title=subsetmaskImage");
selectWindow("subsetmaskImage");

// select all background blob-objects based on certain size
run("Analyze Particles...", "size=0-3000 pixel add"); 
run("Select All");
run("Clear");
//roiManager("Combine");
roiManager("fill");
selectWindow("ROI Manager");
run("Close");
subsetMask = getImageID();

// do another round of thresholding and mask creation based on those 'tiny' objects you want to exclude
//setAutoThreshold("Default dark");
//run("Create Mask");
//subsetMask = getImageID();
imageCalculator("Subtract create", originalMask, subsetMask); // simply subtract the 'tiny' objects from the original mask

// last round of thresholding... to get the final binary image
setAutoThreshold("Default dark");
setAutoThreshold("Huang dark");
run("Create Mask");

//for (i = 0; i < 0; i++) {
//	run("Erode");
//}
//for (i = 0; i < 2; i++) {
//	run("Dilate");
//}
//run("Fill Holes");


// another round of removing background blobs
// select all background blob-objects based on certain size
//midmask = getImageID();
//run("Duplicate...", "title=midsubsetmaskImage");
//selectWindow("midsubsetmaskImage");
//run("Analyze Particles...", "size=0-3000 pixel add"); 
//run("Select All");
//run("Clear");
//roiManager("Combine");
//roiManager("fill");
//selectWindow("ROI Manager");
//run("Close");

// do another round of thresholding and mask creation based on those 'tiny' objects you want to exclude
//setAutoThreshold("Default dark");
//run("Create Mask");
//midsubsetmask = getImageID();
//imageCalculator("Subtract create", midmask, midsubsetmask); // simply subtract the 'tiny' objects from the original mask

filename = substring(imnameor,0,9)+"_neuritesbinary"+".tif";
saveAs("Tiff", "E:\\PhD\\data_analysis\\Temp\\"+filename);
run("Close");
run("Close");
run("Close");
run("Close");
run("Close");
//run("Close");
//run("Close");
//run("Close");