function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

function saveimages(filename, savedir, savenum) {
		open(filename);
		savenumtext = leftPad(savenum,3);
		savename=savenumtext+"_mitobinary"+".tif";
		saveAs("Tiff", savedir+savename);
		close();
}

////////

dir = getDirectory("Choose the directory");
savedir = dir;
filelist = getFileList(dir);
//Array.sort(filelist);
filenamebase = "\\"+dir+"\\";

for(r=0;r<filelist.length;r++) {
	if(endsWith(filelist[r],'.tif')) {
		print(filelist[r]);
		filepath = filenamebase+filelist[r];
		filename_split = split(filelist[r],'_');
		filesavenum = filename_split[0];
		saveimages(filepath, savedir, ""+filesavenum);
	}
}
