openfolder = "PATH/HERE"
savefolder = "PATH/HERE"

function binarize(inputfolder, outputfolder, filename) {
	open(inputfolder + filename);
	resetMinAndMax();
	setOption("ScaleConversions", true);
	run("8-bit");
	run("Auto Threshold", "method=Otsu white");
	setOption("BlackBackground", true);
	run("Dilate");
	run("Dilate");
	run("Erode");
	run("Erode");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Grays");
	saveAs("Tiff", outputfolder + filename);
	close();
}

list = getFileList(openfolder);
for (i=0; i < list.length; i++){
	binarize(openfolder, savefolder, list[i]);
}
