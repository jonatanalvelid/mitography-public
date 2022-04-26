function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

function saveimages(filename, savedir, savenum) {
		open(filename);
		savenumtext = leftPad(savenum,3);
		savename=savenumtext+"_merged"+".tif";
		saveAs("Tiff", savedir+savename);
		close();
}

////////

dir1 = getDirectory("Choose tmr directory");
dir2 = getDirectory("Choose sir directory");
savedir = getDirectory("Choose save directory");
filelist1 = getFileList(dir1);
filelist2 = getFileList(dir2);
filenamebase1 = "\\"+dir1+"\\";
filenamebase2 = "\\"+dir2+"\\";
filenamebasesave = "\\"+savedir+"\\";

for(r=0;r<filelist1.length;r++) {
	if(endsWith(filelist1[r],'.tif')) {
		print(filelist1[r]);
		filepath1 = filenamebase1+filelist1[r];
		filepath2 = filenamebase2+filelist2[r];
		filename_split = split(filelist1[r],'_');
		filesavenum = filename_split[0];
		// open images
		print(filepath1);
		open(filepath1);
		id1 = getImageID();
		print(id1);
		print(filepath2);
		open(filepath2);
		id2 = getImageID();
		print(id2);
		// add channels
		imageCalculator("Add", id1,id2);
		selectImage(id1);
		// save image
		savenumtext = leftPad(filesavenum,3);
		savename = savenumtext+"_sir+tmr"+".tif";
		saveAs("Tiff", savedir+savename);
		close("*");
	}
}
