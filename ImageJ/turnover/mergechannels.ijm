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

dir1 = getDirectory("Choose 580 directory");
dir2 = getDirectory("Choose vb directory");
dir3 = getDirectory("Choose bin mito directory");
dir4 = getDirectory("Choose bin neurites directory");
savedir = getDirectory("Choose save directory");
filelist1 = getFileList(dir1);
filelist2 = getFileList(dir2);
filelist3 = getFileList(dir3);
filelist4 = getFileList(dir4);
filenamebase1 = "\\"+dir1+"\\";
filenamebase2 = "\\"+dir2+"\\";
filenamebase3 = "\\"+dir3+"\\";
filenamebase4 = "\\"+dir4+"\\";
filenamebasesave = "\\"+savedir+"\\";

for(r=0;r<filelist1.length;r++) {
	if(endsWith(filelist1[r],'.tif')) {
		print(filelist1[r]);
		filepath1 = filenamebase1+filelist1[r];
		filepath2 = filenamebase2+filelist2[r];
		filepath3 = filenamebase3+filelist3[r];
		filepath4 = filenamebase4+filelist4[r];
		filename_split = split(filelist1[r],'_');
		filesavenum = filename_split[0];
		// open images
		open(filepath1);
		open(filepath2);
		open(filepath3);
		open(filepath4);
		// merge channels
		run("Merge Channels...", "c1=[" + filelist1[r] + "] c2=[" + filelist2[r] + "] c3=[" + filelist3[r] + "] c4=[" + filelist4[r] +"] create ignore");
		// save image
		savenumtext = leftPad(filesavenum,3);
		savename = savenumtext+"_merged"+".tif";
		saveAs("Tiff", savedir+savename);
		close();
	}
}
