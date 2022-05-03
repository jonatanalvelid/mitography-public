function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

function saveimages(filename, savedir, savenum, nameappendix) {
		open(filename);
		savenumtext = leftPad(savenum,3);
		savename=savenumtext + nameappendix + ".tif";
		saveAs("Tiff", savedir+savename);
		close();
}

////////

dir = getDirectory("Choose the directory");
savedir = dir;
filelist = getFileList(dir);
filenamebase = "\\"+dir+"\\";
nameappendix = "_mitobinary";

for(r=0;r<filelist.length;r++) {
	if(endsWith(filelist[r],'.tif')) {
		print(filelist[r]);
		filepath = filenamebase+filelist[r];
		filename_split = split(filelist[r],'_');
		filesavenum = filename_split[0];
		saveimages(filepath, savedir, ""+filesavenum, nameappendix);
	}
}
