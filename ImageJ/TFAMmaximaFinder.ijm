// Find and save positions of nucleoids, as labelled with TFAM, in mitochondria

// Prominence of TFAM peak finder
peakprom = 6;
savedir = "PATH/HERE";
dir = getDirectory("Select the directory");
filelist = getFileList(dir);
Array.sort(filelist);
filenamebase = "\\"+dir+"\\";

for(i=0;i<filelist.length;i++){
	if(endsWith(filelist[i],".tif") && indexOf(filelist[i],"DNA")>=0){
		print(d2s(i,0));
    	// Open image
		filepath = filenamebase+filelist[i];
		open(filepath);
		// Get dimensions
		getPixelSize(unit, pixelWidth, pixelHeight);
		getDimensions(width, height, channels, slices, frames);
		run("Options...", "iterations=1 count=1 black");
		run("Set Scale...", "distance=1 known="+pixelWidth+" pixel=1 unit=micron");
		
		wait(500);
		
		imnameor = getTitle();
		imname = substring(imnameor, 0, 9);
	
		// Rename the image in a standard way
		rename("TFAMraw");
		// Pre-process image
		run("Smooth");
		run("Smooth");
		run("Smooth");
		// Detect nucleoids
		run("Find Maxima...", "prominence="+d2s(peakprom,0)+" output=[Point Selection]");
		// Get coordinates and peak value of nucleoids
		run("Set Measurements...", "mean centroid redirect=None decimal=3");
		run("Measure");
		updateResults;
		// Save nucleoid measurement results
		filenametxt=imname+"_Nucleoids"+".txt";
		saveAs("Results", savedir+filenametxt);
		print("Saved TFAM data...");
		run("Close");
		// Save flattened nuceloid marked image
		run("Flatten");
		filenamebinary=imname+"_NucleoidOverlay"+".tif";
		saveAs("Tiff", savedir+filenamebinary);
		run("Close");
		run("Close");
		print("Saved maxima overlay...");
	}
}

run("Clear Results");
setResult("PeakProm",0,peakprom);
setResult("NumSmooths",0,3);
filenametxt="ImageJAnalysisParametersTFAM"+".txt";
saveAs("results", savedir+filenametxt);
print("Saved analysis parameters...");
