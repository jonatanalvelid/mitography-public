// Binarize STED mitochondria image

noImages = 1;
outerproffactor = 3;
//seems to be necessary in fixed samples where the membrane labeling is more dotty (OMP25 vs Tom20 rather than live vs fixed).
omp25 = 1;  //only one of these two should be 1, the other 0
tom20 = 0;  //only one of these two should be 1, the other 0
allmito = 1;  //for counting all mito, or deleting the smallest and big ones for example, to get less noise
localthreshold = 1;  //try local thresholding, Bernsen variant. Seems to work nicely on well-labelled OMP25 images.
localthresholdmethod = "Bernsen";  //local thresholding method to use.

dir = getDirectory("Choose the directory");
savedir = "D:\\Data analysis\\Mitography\\Temp\\";
filelist = getFileList(dir);
Array.sort(filelist);
filenamebase = "\\"+dir+"\\";

for(r=0;r<filelist.length/noImages;r++) {
	for(s=0;s<noImages;s++) {
		print(d2s(noImages*r+s,0));
		filepath = filenamebase+filelist[noImages*r+s];
		open(filepath);
		if(s==0) {
			getPixelSize(unit, pixelWidth, pixelHeight);
			getDimensions(width, height, channels, slices, frames);
			run("Options...", "iterations=1 count=1 black");		
		} 
		run("Set Scale...", "distance=1 known="+pixelWidth+" pixel=1 unit=micron");
	}
	
	wait(500);
	
	imnameor = getTitle();
	imname = substring(imnameor, 0, 9);

	//Taking the images and renaming them in a standard way.
	rename("MitoOriginalImageSoma");

	//Starting the analysis by binarizing the mitochondria image and calculating important parameters for them.
	selectWindow("MitoOriginalImageSoma");
	run("Duplicate...", "title=MitoOriginalImageSoma");
	rename("mitobinaryalt");
	selectWindow("mitobinaryalt");
	if(tom20 == 1) {
		run("Gaussian Blur...", "sigma=0.06 scaled");
		if(localthreshold == 1) {
			run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");
		} else {
			run("Make Binary");
			run("Fill Holes");
		}
	} else if(omp25 == 1) {
		run("Gaussian Blur...", "sigma=0.04 scaled"); //Try this, for the OMP25 labeling at least
		if(localthreshold == 1) {
			run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=15 parameter_1=0 parameter_2=0 white");
		} else {
			run("Make Binary");
			run("Fill Holes");
		}
	}
	selectWindow("mitobinaryalt");
	rename("mitobinary");
	
	run("Clear Results");
	run("Set Measurements...", "area centroid fit redirect=None decimal=3");
	selectWindow("mitobinary");
	
	if(allmito == 1) {
		if(tom20 == 1) {
			run("Analyze Particles...", "size=0.015-Infinity display clear include add"); //for counting all, big and small MDVs
		} else if(omp25 == 1) {
			run("Analyze Particles...", "size=0.006-Infinity display clear include add"); //for counting all, big and small MDVs
		}
	} else if(allmito == 0) {
		//run("Analyze Particles...", "size=0.08-3.00 display exclude clear include add"); - for normal
		//run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big ones
		//run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big and small ones
		run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for confocal
	}
	updateResults; 

	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary2");
	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary3");
	selectWindow("mitobinary");
	run("Duplicate...", "title=mitobinary4");
	selectWindow("mitobinary2");
	if(allmito == 1) {
		if(tom20 == 1) {
			run("Analyze Particles...", "size=0.015-Infinity display clear include add"); //for counting all, big and small MDVs
		} else if(omp25 == 1) {
			run("Analyze Particles...", "size=0.006-Infinity display clear include add"); //for counting all, big and small MDVs
		}
	} else if(allmito == 0) {
		//run("Analyze Particles...", "size=0.08-3.00 display exclude clear include add"); - for normal
		//run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big ones
		//run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all the mitochondria areas, also the big and small ones
		run("Analyze Particles...", "size=0.08-Infinity display exclude clear include add"); //for confocal
	}
	run("Flatten");
	
	filenamebinary=imname+"_MitoBinaryOverlay"+".tif";
	saveAs("Tiff", savedir+filenamebinary);
	run("Close");
	selectWindow("mitobinary2");
	run("Close");	
	print("Saved binary overlay...");

	length1 = nResults();
	
	wait(200);
	selectWindow("mitobinary");
	
	filenamemitoroi = imname + "_MitoROISet"+".zip";
	roiManager("Save", savedir + filenamemitoroi); 
	
	wait(200);
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
	run("Duplicate...", "title=mitoskeleton");
	selectWindow("MitoImageOnlyMito");
	
	wait(500);
	IJ.renameResults("ResultsMito");
	wait(500);

	selectWindow("mitobinary4");
	filenamebinarytrue=imname+"_MitoBinary"+".tif";
	saveAs("Tiff", savedir+filenamebinarytrue);	
	print("Saved binary mitochondria image...");
	
	//Skeletonize the binary image and get the length of the mitochondria from the skeleton
	
	selectWindow("mitoskeleton");
	run("Gaussian Blur...", "sigma=0.08 scaled");	
	run("Make Binary");
	run("Fill Holes");
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
	
	for (n=0;n<noSkel;n++) {
		branches = 0;
		mitoSkelLength[n] = 0;
		mitoSkelX[n] = 0;
		mitoSkelY[n] = 0;
		for(i=0;i<noBranch;i++) {
			skelID = getResult("Skeleton ID",i);
			if (skelID == n+1) {
				branchLength = getResult("Branch length",i);
				branchXs = getResult("V1 x",i);
				branchYs = getResult("V1 y",i);
				branchX2s = getResult("V2 x",i);
				branchY2s = getResult("V2 y",i);
				mitoSkelLength[n] = mitoSkelLength[n] + branchLength;
				mitoSkelX[n] = mitoSkelX[n] + (minOf(branchXs,branchX2s)+abs(branchXs-branchX2s)/2)*branchLength;
				mitoSkelY[n] = mitoSkelY[n] + (minOf(branchYs,branchY2s)+abs(branchYs-branchY2s)/2)*branchLength;
				branches = branches + 1;
			}
		}
		if (branches > 0) {
			mitoSkelX[n] = mitoSkelX[n]/mitoSkelLength[n];
			mitoSkelY[n] = mitoSkelY[n]/mitoSkelLength[n];
		} else if (branches == 0) {
			mitoSkelLength[n] = pixelWidth;
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
		//mitoAngle[i] = getResult("Angle",i);
		mitoArea[i] = getResult("Area",i);
		lengthellipse[i] = getResult("Major", i);
		//widthellipse[i] = getResult("Minor", i);
	}
	run("Clear Results");
	for(i=0;i<length1;i++) {
		setResult("X",i,mitoX[i]);
		setResult("Y",i,mitoY[i]);
		//setResult("Angle",i,mitoAngle[i]);
		setResult("Area",i,mitoArea[i]);
		setResult("LenEll",i,lengthellipse[i]);
		//setResult("WidEll",i,widthellipse[i]);	
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
	saveAs("Results", savedir+filenametxt);
	print("Saved listed mitochondria data...");

	selectWindow("mitoskeleton-labeled-skeletons");
	filenameskeleton=imname+"_MitoSkeletonOverlay"+".tif";
	saveAs("Tiff", savedir+filenameskeleton);
	run("Close");
	selectWindow("mitoskeleton");
	run("Close");	
	print("Saved skeletonized overlay...");

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
	wait(1000);
	run("Close All");
}

run("Clear Results");
setResult("OMP25",0,omp25);
setResult("Tom20",0,tom20);
setResult("AllMito",0,allmito);
setResult("LocThresh",0,localthreshold);
setResult("LocThreshMethod",0,localthresholdmethod);
filenametxt="ImageJAnalysisParameters"+".txt";
saveAs("results", savedir+filenametxt);

run("Close");
