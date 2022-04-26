dir = getDirectory("Choose the directory");
savedir = "E:\\PhD\\data_analysis\\Temp\\";
filelist = getFileList(dir);
//Array.sort(filelist);
filenamebase = "\\"+dir+"\\";

function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

function saveimages(filename, savedir, savenum) {
		run("Bio-Formats Importer", "open=" + filename + " color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
		savenumtext = leftPad(savenum,3);
		savename=savenumtext+"_sir"+".tif";
		saveAs("Tiff", savedir+savename);
		close();
		run("Bio-Formats Importer", "open=" + filename + " color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
		savename=savenumtext+"_tmr"+".tif";
		saveAs("Tiff", savedir+savename);
		close();
}

for(r=0;r<filelist.length;r++) {
	if(endsWith(filelist[r],'.msr')) {
		print(filelist[r]);
		filepath = filenamebase+filelist[r];
		filename_split = split(filelist[r],'.');
		filesavenum = filename_split[0];
		saveimages(filepath, savedir, ""+filesavenum);
	}
}
