////Text here is obsolete, automated for a whole directory now.
//Before running, open three images in order; the original actin image, 
//the original mitochondria image and the manually created binary mask
//showing where the stripes are in the actin image. 
//All three window/image/file titles should start with "Image_XXX", 
//where XXX is a three digit ID number.
//Mark any of these three images and start the script.

setBatchMode(true);
noImages = getNumber("How many images do you have per image? With SomaBinary=4, without SomaBinary=3.",4);
tol = 255/4;
actinprofilefactor = 2;
mitoprofilefactor = 0.75;
actinlineprofilewidth = 10;
mitochondrialineprofilewidth = 5;
outerproffactor = 3;
outerprofenddistance = 0.3;   //limit on checking this: 0.35*6 = 2.1
linelen = 1; //in µm
omp25 = 0;  //only one of these two should be 1, the other 0
tom20 = 1;  //only one of these two should be 1, the other 0
allmito = 1;  //for counting all mito, or deleting the smallest and big ones for example, to get less noise
localthreshold = 1;  //try local thresholding, Bernsen variant. Seems to work nicely on well-labelled OMP25 images.
localthresholdmethod = "Bernsen";  //local thresholding method to use.

dir = getDirectory("Choose the directory");
filelist = getFileList(dir);
Array.sort(filelist);
filenamebase = "\\"+dir+"\\";
savedir = "C:\\Users\\giovanna.coceano\\Documents\\temp\\"

for(r=0;r<filelist.length/noImages;r++) {
	imageindexes = newArray(noImages);
	for(s=0;s<noImages;s++) {
		print(d2s(noImages*r+s,0));
		filepath = filenamebase+filelist[noImages*r+s];
		open(filepath);
		imagename = getTitle();
		imageindexes[s] = getImageID();
		if (endsWith(imagename, "Mitochondria.tif")) {
			getPixelSize(unit, pixelWidth, pixelHeight);
			getDimensions(width, height, channels, slices, frames);
			run("Options...", "iterations=1 count=1 black");
			linelenpx = linelen/pixelWidth;
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
	if(noSlices==4) {
		run("Stack to Images");
		selectWindow("ImageStack-0001");
		rename("ActinOriginalImageSoma");

		selectWindow("ImageStack-0002");
		rename("MitoOriginalImageSoma");
		selectWindow("ImageStack-0003");
		run("8-bit");
		rename("NonStripesMaskOriginalImage");
		selectWindow("ImageStack-0004");
		run("8-bit");
		rename("SomaMaskOriginalImage");	

		selectWindow("SomaMaskOriginalImage");
		resetMinAndMax();
		run("Invert");
		run("Divide...", "value=255");
		imageCalculator("Multiply create","ActinOriginalImageSoma","SomaMaskOriginalImage");
		rename("ActinOriginalImage");
		run("Duplicate...", "title=ActinOriginalImageProfiles");
		selectWindow("ActinOriginalImageSoma");
		run("Close");
	} else if(noSlices==3) {
		run("Stack to Images");
		selectWindow("ImageStack-0001");
		rename("ActinOriginalImage");
		run("Duplicate...", "title=ActinOriginalImageProfiles");
		selectWindow("ImageStack-0002");
		rename("MitoOriginalImageSoma");
		selectWindow("ImageStack-0003");
		rename("NonStripesMaskOriginalImage");
	} else {
		exit("You need three or four images to run the macro, all named with the initial substring Image_xxx. Opened in order; one actin image, one mitochondria image, one non-stripes binary mask and optionally one soma binary mask.");
	}

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
		run("Gaussian Blur...", "sigma=0.04 scaled");
		if(localthreshold == 1) {
			run("Auto Local Threshold", "method=" + localthresholdmethod + " radius=15 parameter_1=0 parameter_2=0 white");
		} else {
			run("Make Binary");
			run("Fill Holes");
		}
	}

	if(noSlices == 4) {
		imageCalculator("Multiply create","mitobinaryalt","SomaMaskOriginalImage");
		rename("mitobinary");
	} else if(noSlices == 3) {
		selectWindow("mitobinaryalt");
		rename("mitobinary");
	}
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
		run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all mitochondria, also big and small ones
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
		run("Analyze Particles...", "size=0.02-Infinity display exclude clear include add"); //for getting all mitochondria, also big and small ones
	}
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
	run("Duplicate...", "title=mitoskeleton");
	selectWindow("MitoImageOnlyMito");

	wait(500);
	IJ.renameResults("ResultsMito");
	wait(500);

	updateResults();
	run("Clear Results");
	updateResults();
	wait(500);
	//Generate mitochondria line profiles at the centroid

	for(i=0; i<length1; i++) {
		if(angle[i]*2*PI/360 > PI/2) {
			angleorth = angle[i]*2*PI/360 - PI/2;
			xstart1 = xcenter[i]-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i]+0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i]+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i]-0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		} else {
			angleorth = angle[i]*2*PI/360 + PI/2;
			xstart1 = xcenter[i]+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i]-0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i]-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i]+0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		}

		updateResults();
		makeLine(xstart1,ystart1,xend1,yend1,mitochondrialineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x", m, pixelWidth*(m+1));
				updateResults();
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
			updateResults();
		}
	}

	filenametxt=imname+"_MitoLineProfiles"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved listed mitochondria center line profiles..");
	wait(500);
	run("Clear Results");

	//Generate mitochondria line profiles at the upper half of the mitochondria

	wait(500);
	for(i=0; i<length1; i++) {
		if (lengthell[i] < 1.8) {
			if (lengthell[i]/outerproffactor < outerprofenddistance/1.5) {
				outerpos = lengthell[i]/2 - outerprofenddistance/1.5;
			} else {
				outerpos = lengthell[i]/outerproffactor;
			}
		} else {
			outerpos = lengthell[i]/2 - outerprofenddistance;
		}
		if(angle[i]*2*PI/360 > PI/2) {
			angleorth = angle[i]*2*PI/360 - PI/2;
			// Use positions at 1/6 of the L and 5/6 of the L along the L of the mito as the outer line profiles
			//xstart1 = xcenter[i]-lengthell[i]/outerproffactor*sin(angleorth)-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//ystart1 = ycenter[i]-lengthell[i]/outerproffactor*cos(angleorth)+0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			//xend1 = xcenter[i]-lengthell[i]/outerproffactor*sin(angleorth)+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//yend1 = ycenter[i]-lengthell[i]/outerproffactor*cos(angleorth)-0.5*linelenpx*mitoprofilefactor*sin(angleorth);

			// Use positions at 0.15 and L-0.15 along the L of the mito as the outer line profiles, in order to get more uniform for long and short mitochondria.
			xstart1 = xcenter[i] - outerpos*sin(angleorth) - 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i] - outerpos*cos(angleorth) + 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i] - outerpos*sin(angleorth) + 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i] - outerpos*cos(angleorth) - 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		} else {
			angleorth = angle[i]*2*PI/360 + PI/2;
			//xstart1 = xcenter[i]+lengthell[i]/outerproffactor*sin(angleorth)+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//ystart1 = ycenter[i]+lengthell[i]/outerproffactor*cos(angleorth)-0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			//xend1 = xcenter[i]+lengthell[i]/outerproffactor*sin(angleorth)-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//yend1 = ycenter[i]+lengthell[i]/outerproffactor*cos(angleorth)+0.5*linelenpx*mitoprofilefactor*sin(angleorth);

			xstart1 = xcenter[i] + outerpos*sin(angleorth) + 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i] + outerpos*cos(angleorth) - 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i] + outerpos*sin(angleorth) - 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i] + outerpos*cos(angleorth) + 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		}

		makeLine(xstart1,ystart1,xend1,yend1,mitochondrialineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x", m, pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	filenametxt=imname+"_MitoUpperLineProfiles"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved listed mitochondria upper line profiles..");
	wait(500);
	run("Clear Results");

	//Generate mitochondria line profiles at the bottom half of the mitochondria

	wait(500);
	for(i=0; i<length1; i++) {
		if (lengthell[i] < 1.8) {
			if (lengthell[i]/outerproffactor < outerprofenddistance/1.5) {
				outerpos = lengthell[i]/2 - outerprofenddistance/1.5;
			} else {
				outerpos = lengthell[i]/outerproffactor;
			}
		} else {
			outerpos = lengthell[i]/2 - outerprofenddistance;
		}
		if(angle[i]*2*PI/360 > PI/2) {
			angleorth = angle[i]*2*PI/360 - PI/2;
			//xstart1 = xcenter[i]+lengthell[i]/outerproffactor*sin(angleorth)-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//ystart1 = ycenter[i]+lengthell[i]/outerproffactor*cos(angleorth)+0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			//xend1 = xcenter[i]+lengthell[i]/outerproffactor*sin(angleorth)+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//yend1 = ycenter[i]+lengthell[i]/outerproffactor*cos(angleorth)-0.5*linelenpx*mitoprofilefactor*sin(angleorth);

			xstart1 = xcenter[i] + outerpos*sin(angleorth) - 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i] + outerpos*cos(angleorth) + 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i] + outerpos*sin(angleorth) + 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i] + outerpos*cos(angleorth) - 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		} else {
			angleorth = angle[i]*2*PI/360 + PI/2;
			//xstart1 = xcenter[i]-lengthell[i]/outerproffactor*sin(angleorth)+0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//ystart1 = ycenter[i]-lengthell[i]/outerproffactor*cos(angleorth)-0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			//xend1 = xcenter[i]-lengthell[i]/outerproffactor*sin(angleorth)-0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			//yend1 = ycenter[i]-lengthell[i]/outerproffactor*cos(angleorth)+0.5*linelenpx*mitoprofilefactor*sin(angleorth);

			xstart1 = xcenter[i] - outerpos*sin(angleorth) + 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			ystart1 = ycenter[i] - outerpos*cos(angleorth) - 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
			xend1 = xcenter[i] - outerpos*sin(angleorth) - 0.5*linelenpx*mitoprofilefactor*cos(angleorth);
			yend1 = ycenter[i] - outerpos*cos(angleorth) + 0.5*linelenpx*mitoprofilefactor*sin(angleorth);
		}

		makeLine(xstart1,ystart1,xend1,yend1,mitochondrialineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x", m, pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	filenametxt=imname+"_MitoBottomLineProfiles"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved listed mitochondria bottom line profiles..");
	wait(500);
	run("Clear Results");

	wait(500);
	selectWindow("MitoImageOnlyMito");
	filenamebinary=imname+"_OnlyMitoImage"+".tif";
	saveAs("Tiff", savedir+filenamebinary);	
	print("Saved mitochondria image with only mitochondria...");

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
			branchskelID = getResult("Skeleton ID",i);
			if (branchskelID == n+1) {
				branchLength = getResult("Branch length",i);
				branchXs = getResult("V1 x",i);
				branchYs = getResult("V1 y",i);
				branchX2s = getResult("V2 x",i);
				branchY2s = getResult("V2 y",i);
				mitoSkelLength[n] = mitoSkelLength[n] + branchLength;
				//Calculate weighted X,Y positions to get the mean position of the branches in a skeleton
				mitoSkelX[n] = mitoSkelX[n] + (minOf(branchXs,branchX2s)+abs(branchXs-branchX2s)/2)*branchLength;
				mitoSkelY[n] = mitoSkelY[n] + (minOf(branchYs,branchY2s)+abs(branchYs-branchY2s)/2)*branchLength;
				branches = branches + 1;
			}
		}
		if (branches > 0) {
			//Calculate the mean branch position in the skeleton of interest, to get an estimate of the skeleton centerpoint
			mitoSkelX[n] = mitoSkelX[n]/mitoSkelLength[n];
			mitoSkelY[n] = mitoSkelY[n]/mitoSkelLength[n];
		} else if (branches == 0) {
			mitoSkelLength[n] = pixelWidth;
		}
	}

	//Summarize all the parameters in a results table and save it

	wait(500);
	IJ.renameResults("Results","ResultsBranches");
	wait(500);
	selectWindow("ResultsBranches");
	wait(500);
	run("Close");
	wait(500);
	selectWindow("ResultsMito");
	wait(500);
	IJ.renameResults("ResultsMito","Results");
	wait(500);

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

	//Multiply the actinoriginalimage with a dilated mitochondria binary image, in order to remove
	//a lot of background noise/other filaments without mitochondria that could affect the actin
	//line profiles and fitting.

	selectWindow("mitobinary3");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	run("Dilate");
	resetMinAndMax();
	run("Divide...","value=255.000");
	imageCalculator("Multiply create","ActinOriginalImageProfiles","mitobinary3");
	rename("ActinOriginalImageMitoProfiles");
	selectWindow("ActinOriginalImageProfiles");
	run("Close");

	//Split up the mitochondria dependent on if they are in a filament with visible stripes or not,
	//do this based on the binary mask that manually has been produced and saved.

	selectWindow("NonStripesMaskOriginalImage");
	run("Duplicate...", "title=StripesMaskOriginalImage");
	selectWindow("NonStripesMaskOriginalImage");
	run("Divide...", "value=255.000");
	imageCalculator("Multiply create","ActinOriginalImage","NonStripesMaskOriginalImage");
	rename("NonStripesIntermediate");
	imageCalculator("Multiply create","NonStripesIntermediate","mitobinary3");
	rename("NonStripesImage");

	selectWindow("NonStripesImage");
	run("Duplicate...", "title=PatchesBinary");
	selectWindow("PatchesBinary");
	run("Make Binary");
	run("Dilate");

	selectWindow("NonStripesIntermediate");
	run("Duplicate...", "title=PatchesBinary2");
	selectWindow("PatchesBinary2");
	run("Make Binary");
	run("Dilate");

	selectWindow("StripesMaskOriginalImage");
	resetMinAndMax();
	run("Invert");
	run("Divide...", "value=255.000");
	imageCalculator("Multiply create","ActinOriginalImage","StripesMaskOriginalImage");
	rename("StripesIntermediate");
	imageCalculator("Multiply create","StripesIntermediate","mitobinary3");
	rename("StripesImage");

	selectWindow("NonStripesImage");
	filenamenonstripes=imname+"_NonStripesImage"+".tif";
	saveAs("Tiff", savedir+filenamenonstripes);
	run("Close");
	print("Saved non-stripes image...");

	selectWindow("StripesImage");
	filenamestripes=imname+"_StripesImage"+".tif";
	saveAs("Tiff", savedir+filenamestripes);
	run("Close");
	print("Saved stripes image...");

	selectWindow("mitobinary3");
	run("Close");

	//Divide up mitochondria into two lists, one with mitochondria in the presence of stripes and one without stripes.
	//Save two images where the "binary stripes position mask" and its inverse has been multiplied with the mitochondria image.
	//Also save the two lists of parameters for stripes and non-stripes mitochondria as separate files.
	selectWindow("StripesMaskOriginalImage");
	noMito = lengthOf(mitoX);
	mitoStripesNo = newArray();
	mitoNonStripesNo = newArray();	
	for(k=0;k<noMito;k++) {
		xpos = mitoX[k]/pixelWidth;
		ypos = mitoY[k]/pixelHeight;
		pixval = getPixel(xpos,ypos);
		if(pixval == 0) {
			mitoNonStripesNo = Array.concat(mitoNonStripesNo,k);
		} else {
			mitoStripesNo = Array.concat(mitoStripesNo,k);	
		}
	}

	selectWindow("StripesMaskOriginalImage");	
	filenamestripesmask=imname+"_StripesMask"+".tif";
	saveAs("Tiff", savedir+filenamestripesmask);
	run("Close");
	print("Saved stripes mask image...");

	selectWindow("NonStripesMaskOriginalImage");	
	filenamenonstripesmask=imname+"_NonStripesMask"+".tif";
	saveAs("Tiff", savedir+filenamenonstripesmask);
	run("Close");
	print("Saved non-stripes mask image...");

	length = lengthOf(mitoNonStripesNo);
	run("Clear Results");
	for (i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		setResult("X",i,mitoX[pos]);
		setResult("Y",i,mitoY[pos]);
		setResult("Angle",i,mitoAngle[pos]);
		setResult("Area",i,mitoArea[pos]);
		setResult("LenEll",i,lengthellipse[pos]);
		setResult("WidEll",i,widthellipse[pos]);	
		setResult("LenSke",i,mitoLength[pos]);
	}

	filenametxt=imname+"_MitoNonStr"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved mitochondria in non-stripes data...");


	length = lengthOf(mitoStripesNo);
	run("Clear Results");
	for (i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		setResult("X",i,mitoX[pos]);
		setResult("Y",i,mitoY[pos]);
		setResult("Angle",i,mitoAngle[pos]);
		setResult("Area",i,mitoArea[pos]);
		setResult("LenEll",i,lengthellipse[pos]);
		setResult("WidEll",i,widthellipse[pos]);
		setResult("LenSke",i,mitoLength[pos]);	
	}

	filenametxt=imname+"_MitoStripes"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved mitochondria in stripes data..");

	//Get the actin line profiles of the filaments at the centroid coordinates of all the mitochondria.
	//First for the stripes mitochondria, and following this the non-stripes mitochondria.
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfiles"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in stripes...");

	//Get another actin line profile, the wide one, in case the fitting of the first one fails.
	//A wide one should be more easily fitted, but might not generate an as exact value. 
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfilesAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in stripes...");

	//Get stripes line profiles for upper and lower part of the mitochondria as well, normal and alternative
	//Start with upper
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfilesUpper"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in stripes...");

	//Get another actin upper line profile, the wide one, in case the fitting of the first one fails.
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfilesUpperAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in stripes...");

	//Now get lower line profiles
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfilesBottom"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in stripes...");

	//Get another actin lower line profile, the wide one, in case the fitting of the first one fails.
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}
		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinStripesLineProfilesBottomAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in stripes...");


	//Non-stripes line profiles below.

	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	length = lengthOf(mitoNonStripesNo);

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;
		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}

	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfiles"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in non-stripes...");

	//Get another actin line profile, the wide one, in case the fitting of the first one fails.
	//A wide one should be more easily fitted, but might not generate an as exact value. 
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+0.5*actinprofilefactor*linelenpx*cos(angleorth);
			ystart2 = ycenter-0.5*actinprofilefactor*linelenpx*sin(angleorth);
			xend2 = xcenter-0.5*actinprofilefactor*linelenpx*cos(angleorth);
			yend2 = ycenter+0.5*actinprofilefactor*linelenpx*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfilesAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in non-stripes...");

	//Get non-stripes line profiles for upper and lower part of the mitochondria as well, normal and alternative
	//Start with upper
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfilesUpper"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in stripes...");

	//Get another non-stripes actin upper line profile, the wide one, in case the fitting of the first one fails.
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfilesUpperAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in stripes...");

	//Now get non-stripes actin lower line profiles
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidth);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}

		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfilesBottom"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved actin line profiles at mitochondria positions in stripes...");

	//Get another non-stripes actin lower line profile, the wide one, in case the fitting of the first one fails.
	run("Clear Results");
	selectWindow("ActinOriginalImageMitoProfiles");

	for(i=0;i<length;i++) {
		pos = mitoNonStripesNo[i];
		lengthEllipse = lengthellipse[pos];
		actinlineprofilewidthlong = lengthEllipse/pixelWidth;
		angle = mitoAngle[pos];
		xcenter = mitoX[pos]/pixelWidth;
		ycenter = mitoY[pos]/pixelHeight;

		if(angle*2*PI/360 > PI/2) {
			angleorth = angle*2*PI/360 - PI/2;
			xstart2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter+lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter+lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
		} else {
			angleorth = angle*2*PI/360 + PI/2;
			xstart2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)+0.5*linelenpx*actinprofilefactor*cos(angleorth);
			ystart2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)-0.5*linelenpx*actinprofilefactor*sin(angleorth);
			xend2 = xcenter-lengthellipse[pos]/pixelWidth/outerproffactor*sin(angleorth)-0.5*linelenpx*actinprofilefactor*cos(angleorth);
			yend2 = ycenter-lengthellipse[pos]/pixelWidth/outerproffactor*cos(angleorth)+0.5*linelenpx*actinprofilefactor*sin(angleorth);
		}

		makeLine(xstart2,ystart2,xend2,yend2,actinlineprofilewidthlong);
		lineProfile = getProfile();
		len=lineProfile.length;

		//Generate one "line profile" with the x-values of the line profiles, add it in the first results column.
		if(i==0) {
			for(m=0;m<len;m++) {
				setResult("x",m,pixelWidth*(m+1));
			}
		}
		for(n=0;n<len;n++) {
		setResult(i+1, n, lineProfile[n]); 
		}
	}

	updateResults; 
	selectWindow("Results");
	filenametxt=imname+"_ActinNonStripesLineProfilesBottomAlternative"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved alternative actin line profiles at mitochondria positions in stripes...");

	run("Clear Results");


	length = lengthOf(mitoStripesNo);	
	for(i=0;i<length;i++) {	
		setResult("StrMitoNo",i,mitoStripesNo[i]+1);
	}

	length = lengthOf(mitoNonStripesNo);	
	for(i=0;i<length;i++) {	
		setResult("NonStrMitoNo",i,mitoNonStripesNo[i]+1);
	}

	filenametxt=imname+"_StripesNonStripesMitoNo"+".txt";
	saveAs("results", savedir+filenametxt);
	print("Saved mitochondria numbers for non-stripes and stripes mitochondria...");


	run("Clear Results");
	setResult("PxWidth",0,pixelWidth);
	setResult("PxLength",0,pixelHeight);
	filenametxt=imname+"_PixelSizes"+".txt";
	saveAs("results", savedir+filenametxt);

	selectWindow("PatchesBinary");
	filenamepatches=imname+"_PatchesBinary"+".tif";
	saveAs("Tiff", savedir+filenamepatches);
	run("Close");
	print("Saved patches image...");

	selectWindow("PatchesBinary2");
	filenamepatches2=imname+"_PatchesBinaryAlternative"+".tif";
	saveAs("Tiff", savedir+filenamepatches2);
	run("Close");
	print("Saved alternative patches image...");

	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	//run("Close");
	print("Finished!");
	wait(1000);
	//run("Close All");
}

run("Clear Results");
setResult("ActLineProfLen",0,linelen*actinprofilefactor);
setResult("ActLineProfWidth",0,actinlineprofilewidth);
setResult("MitoLineProfLen",0,linelen*mitoprofilefactor);
setResult("MitoLineProfWidth",0,mitochondrialineprofilewidth);
setResult("Tolerance",0,tol);
setResult("Tom20Labeling",0,tom20);
setResult("OMP25Labeling",0,omp25);
setResult("AllMitoVariable",0,allmito);
setResult("WithSomaBinary",0,noImages-3);
setResult("OutLineProfFactor",0,outerproffactor);
setResult("OutLineProfEndDist",0,outerprofenddistance);
setResult("LocalThreshold",0,localthreshold);
setResult("LocalThresholdMethod",0,localthresholdmethod);
filenametxt="ImageJAnalysisParameters"+".txt";
saveAs("results", savedir+filenametxt);
setBatchMode(false);
