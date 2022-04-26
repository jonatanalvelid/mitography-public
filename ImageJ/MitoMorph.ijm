// OXPHOS version - 201203
// MitoBinary pre-made - fed into the analysis
// No Actin - only mitochondria morphology to analyse
// No SomaBinary - do this in MATLAB instead
// Only two input images - Mitochondria and MitoBinary

setBatchMode(true);

// No photon count normalization when changing from 32-bit to 8-bit
run("Conversions...", " ");

noImages = 2;

dir = getDirectory("Choose the directory");
filelist = getFileList(dir);
Array.sort(filelist);
filenamebase = "\\"+dir+"\\";
savedir = "E:\\PhD\\data_analysis\\Temp\\"

for(r=0;r<filelist.length/noImages;r++) {
	imageindexes = newArray(noImages);
	for(s=0;s<noImages;s++) {
		print(d2s(noImages*r+s,0));
		filepath = filenamebase+filelist[noImages*r+s];
		open(filepath);
		imagename = getTitle();
		imageindexes[s] = getImageID();
		if (endsWith(imagename, "-mitochondria.tif")) {
			getPixelSize(unit, pixelWidth, pixelHeight);
			getDimensions(width, height, channels, slices, frames);
			run("Options...", "iterations=1 count=1 black");
		}
	}
	
	wait(500);
	for(s=0;s<noImages;s++) {
		selectImage(imageindexes[s]);
		run("Set Scale...", "distance=1 known="+pixelWidth+" pixel=1 unit=micron");
	}
	wait(1000);
	
	imnameor = getTitle();
	imname = substring(imnameor, 0, 9);

	//Taking the images and renaming them in a standard way.
	run("Images to Stack", "name=ImageStack title="+imname+" keep");
	noSlices = nSlices;

	if(noSlices==2) {
		run("Stack to Images");
		selectWindow("ImageStack-0001");
		rename("mitobinary");
		run("8-bit");
		selectWindow("ImageStack-0002");
		rename("MitoOriginalImageSoma");
		run("8-bit");
	} else {
		exit("You need two images to run the macro, all named with the initial substring Image_xxx.");
	}

	//Starting the analysis by binarizing the mitochondria image and calculating important parameters for them.

	run("Clear Results");
	run("Set Measurements...", "area centroid fit redirect=None decimal=3");
	selectWindow("mitobinary");
	// exclude mitos on the border
	//run("Analyze Particles...", "size=0-Infinity display exclude clear include add"); //for counting all, big and small MDVs. Remove the tiniest (noise, <~4px) later with an area threshold if necessary.
	run("Analyze Particles...", "size=0-Infinity display clear include add");  //Sec61b
	
	updateResults; 

	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary2");
	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary3");
	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary4");
	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinaryskel");
	selectWindow("mitobinary2");

	//run("Analyze Particles...", "size=0-Infinity display exclude clear include add"); //for counting all, big and small MDVs. Remove tiniest (if noise) later.
	run("Analyze Particles...", "size=0-Infinity display clear include add");  //Sec61b
	run("Flatten");

	filenamebinary=imname+"_MitoBinaryOverlay"+".tif";
	saveAs("Tiff", savedir+filenamebinary);
	run("Close");
	selectWindow("mitobinary2");
	run("Close");	
	print("Saved binary overlay...");

	length1 = nResults();
	selectWindow("mitobinary");
	if (length1 > 1) {
		roiManager("Deselect");
		roiManager("Combine");
		run("Clear Outside");
		roiManager("Delete");
	} else if (length1 == 1) {
		roiManager("Deselect");
		roiManager("Select", 0);
		run("Clear Outside");
		roiManager("Delete");
	}
	roiManager("Show All");
	roiManager("Show None");
	angle = newArray(length1);
	xcenter = newArray(length1);
	ycenter = newArray(length1);
	lengthell = newArray(length1);

	for(i=0;i<length1;i++) {
		angle[i] = getResult("Angle",i);
		xcenter[i] = getResult("X", i)/pixelWidth;
		ycenter[i] = getResult("Y", i)/pixelHeight;
		lengthell[i] = getResult("Major", i)/pixelWidth;
	}

	selectWindow("mitobinary");
	resetMinAndMax();
	run("Dilate");
	run("Dilate");
	resetMinAndMax();
	run("Divide...","value=255.000");
	imageCalculator("Multiply create","MitoOriginalImageSoma","mitobinary");
	rename("MitoImageOnlyMito");
	selectWindow("MitoImageOnlyMito");
	
	wait(200);
	IJ.renameResults("ResultsMito");
	wait(200);
	updateResults();
	run("Clear Results");
	updateResults();
	wait(200);

	wait(200);
	selectWindow("MitoImageOnlyMito");
	filenamebinary=imname+"_OnlyMitoImage"+".tif";
	saveAs("Tiff", savedir+filenamebinary);	
	print("Saved mitochondria image with only mitochondria...");

	selectWindow("mitobinary4");
	//filenamebinarytrue=imname+"_MitoBinary"+".tif";
	//saveAs("Tiff", savedir+filenamebinarytrue);	
	//print("Saved binary mitochondria image...");

	//Skeletonize the binary image and get the length of the mitochondria from the skeleton

	selectWindow("mitobinaryskel");
	run("Skeletonize (2D/3D)");
	run("Analyze Skeleton (2D/3D)", "prune=none show display");
	selectWindow("Results");
	run("Close");
	selectWindow("Branch information");
	IJ.renameResults("Branch information","Results");
	noBranch = nResults();
	noSkel = getResult("Skeleton ID",noBranch-1);
	
	print(noBranch);
	print(noSkel);
	
	mitoSkelLength = newArray(noSkel);
	mitoSkelX = newArray(noSkel);
	mitoSkelY = newArray(noSkel);
	//branchskelID = 0;
	
	for (n=0;n<noSkel;n++) {
		branches = 0;
		mitoSkelLength[n] = 0;
		mitoSkelX[n] = 0;
		mitoSkelY[n] = 0;
		//oldskelID = skelID;
		for(i=0;i<noBranch;i++) {
			branchskelID = getResult("Skeleton ID",i);
			//if (i == 0) {
			//	oldskelID = branchskelID;
			//}
			if (branchskelID == n+1) {
				branchLength = getResult("Branch length",i);
				branchXs = getResult("V1 x",i);
				branchYs = getResult("V1 y",i);
				branchX2s = getResult("V2 x",i);
				branchY2s = getResult("V2 y",i);
				//tempskellen = mitoSkelLength[n];
				//tempX = mitoSkelX[n];
				//tempy = mitoSkelY[n];
				mitoSkelLength[n] = mitoSkelLength[n] + branchLength;
				//Calculate weighted X,Y positions to get the mean position of the branches in a skeleton
				mitoSkelX[n] = mitoSkelX[n] + (minOf(branchXs,branchX2s)+abs(branchXs-branchX2s)/2)*branchLength;
				mitoSkelY[n] = mitoSkelY[n] + (minOf(branchYs,branchY2s)+abs(branchYs-branchY2s)/2)*branchLength;
				branches = branches + 1;
			}
		}
		if (branches > 0) {
			//tempX = mitoSkelX[n];
			//tempy = mitoSkelY[n];
			//tempskellen = mitoSkelLength[n];
			//Calculate the mean branch position in the skeleton of interest, to get an estimate of the skeleton centerpoint
			mitoSkelX[n] = mitoSkelX[n]/mitoSkelLength[n];
			mitoSkelY[n] = mitoSkelY[n]/mitoSkelLength[n];
		} else if (branches == 0) {
			mitoSkelLength[n] = pixelWidth;
			//mitoSkelLength[n] = 0;
		}
	}
		
	//Summarize all the parameters in a results table and save it

	wait(200);
	IJ.renameResults("Results","ResultsBranches");
	wait(200);
	selectWindow("ResultsBranches");
	wait(200);
	run("Close");
	wait(200);
	selectWindow("ResultsMito");
	wait(200);
	IJ.renameResults("ResultsMito","Results");
	wait(200);

	length1 = nResults();
	
	mitoX = newArray(length1);
	mitoY = newArray(length1);
	mitoAngle = newArray(length1);
	mitoArea = newArray(length1);
	mitoNo = newArray(length1);
	mitoLength = newArray(length1);
	lengthellipse = newArray(length1);
	widthellipse = newArray(length1);
	
	for(i=0;i<length1;i++) {
		mitoX[i] = getResult("X",i);
		mitoY[i] = getResult("Y",i);
		mitoAngle[i] = getResult("Angle",i);
		mitoArea[i] = getResult("Area",i);
		lengthellipse[i] = getResult("Major", i);
		widthellipse[i] = getResult("Minor", i);
	}
	run("Clear Results");
	for(i=0;i<length1;i++) {
		setResult("X",i,mitoX[i]);
		setResult("Y",i,mitoY[i]);
		setResult("Angle",i,mitoAngle[i]);
		setResult("Area",i,mitoArea[i]);
		setResult("LenEll",i,lengthellipse[i]);
		setResult("WidEll",i,widthellipse[i]);	
	}
	updateResults();
	
	for(n=0;n<length1;n++) {
		if (lengthOf(mitoSkelLength) > 1) {
			distances = newArray(noSkel);
			for(i=0;i<noSkel;i++) {
				distances[i] = sqrt((mitoX[n]-mitoSkelX[i])*(mitoX[n]-mitoSkelX[i])+(mitoY[n]-mitoSkelY[i])*(mitoY[n]-mitoSkelY[i]));
			}
			minima = Array.findMinima(distances,0,0);
			//Check so that the found distance minima is less than 1µm away from the mitochondria center, otherwise it most surely is not the right skeleton.
			if (distances[minima[0]] < 1) {
				mitoLength[n] = mitoSkelLength[minima[0]];
				setResult("LenSke",n,mitoLength[n]);
				setResult("MitoSkelPos",n,minima[0]+1);
			} else {
				setResult("LenSke",n,0);
				setResult("MitoSkelPos",n,0);
			}
		} else {
			mitoLength[n] = mitoSkelLength[0];
			setResult("LenSke",n,mitoLength[n]);
			setResult("MitoSkelPos",n,1);
		}
	}
	updateResults();
	
	//selectWindow("Results");
	filenametxt=imname+"_MitoAnalysis"+".txt";
	//filenamexls=imname+"_MitoAnalysis"+".xls";
	saveAs("Results", savedir+filenametxt);
	//saveAs("results", "D:\\Data analysis\\Mitochondria\\"+filenamexls);
	print("Saved listed mitochondria data...");

	selectWindow("mitobinaryskel-labeled-skeletons");
	filenameskeleton=imname+"_MitoSkeletonOverlay"+".tif";
	saveAs("Tiff", savedir+filenameskeleton);
	run("Close");
	selectWindow("mitobinaryskel");
	run("Close");	
	print("Saved skeletonized overlay...");

	//////////////////////
	
	
	run("Clear Results");
	setResult("PxWidth",0,pixelWidth);
	setResult("PxLength",0,pixelHeight);
	filenametxt=imname+"_PixelSizes"+".txt";
	saveAs("results", savedir+filenametxt);

	run("Close");
	run("Close");
	run("Close");
	run("Close");
	run("Close");
	run("Close");
	print("Finished!");
	wait(200);
	run("Close All");
}

run("Clear Results");

setBatchMode(false);