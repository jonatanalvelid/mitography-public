function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

savedir = getDirectory("Choose save directory");

id = getImageID(); 
title = getTitle(); 
n=1;
m=1;
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n; 
tileHeight = height / m; 
i=1;
for (y = 0; y < m; y++) { 
	offsetY = y * height / m; 
	for (x = 0; x < n; x++) { 
		offsetX = x * width / n; 
		selectImage(id); 
 		call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
		tileTitle = title + " [" + x + "," + y + "]"; 
 		run("Duplicate...", "title=" + tileTitle); 
		makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
 		run("Crop");

		savenum = "" + i;
		savenumtext = leftPad(savenum,3);

		namenum = 6;
		if (namenum==1) {
			nameappendix = "_tmr";
		} else if (namenum==2) {
			nameappendix = "_sir";
		} else if (namenum==3) {
			nameappendix = "_somabinary";
		} else if (namenum==4) {
			nameappendix = "_neuritesbinary";
		} else if (namenum==5) {
			nameappendixname = "_neuritesbinary_dt";
		} else if (namenum==6) {
			nameappendix = "_mitobinary";
		}
		savename = savenumtext + nameappendix + ".tif";
		
		saveAs("Tiff", savedir+savename);
		
		close();
		i++;
	} 
} 
selectImage(id); 
close(); 