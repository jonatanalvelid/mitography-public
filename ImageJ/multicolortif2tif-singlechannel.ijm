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

function saveimages(filename, savedir, savenum, namesuffix1, namesuffix2, namesuffix3) {
		open(filename);
		run("Stack to Images");
		savenumtext = leftPad(savenum,3);
		savename1="Image_"+savenumtext+"-"+namesuffix1+".tif";
		savename2="Image_"+savenumtext+"-"+namesuffix2+".tif";
		savename3="Image_"+savenumtext+"-"+namesuffix3+".tif";
		saveAs("Tiff", savedir+savename1);
		close();
		saveAs("Tiff", savedir+savename2);
		close();
		saveAs("Tiff", savedir+savename3);
		close();
}

for(r=0;r<filelist.length;r++) {
	if(endsWith(filelist[r],'.tif')) {
		print(filelist[r]);
		filepath = filenamebase+filelist[r];
		print(filepath);
		filename_split = split(filelist[r],'_');
		filesavenum = filename_split[1];
		filesavenum = split(filesavenum,'.');
		filesavenum = filesavenum[0];
		filenameprefix = filename_split[0];
		filenameprefix = toString(filenameprefix);
		saveimages(filepath, savedir, ""+filesavenum, "map2", "oxphos", "mitochondria");
	}
}
