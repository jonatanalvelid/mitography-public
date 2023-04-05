function leftPad(s, width) {
  while (lengthOf(s)<width) {
      s = "0"+s;
  }
  return toString(s);
}

////// USER PARMETERS
n=1;  // x tiles
m=1;  // y tiles
namenum = 1;
////////

savedir = getDirectory("Choose save directory");

id = getImageID(); 
title = getTitle(); 

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

		if (namenum==1) {
			savename = savenumtext+"_tmr"+".tif";
		} else if (namenum==2) {
			savename = savenumtext+"_sir"+".tif";
		} else if (namenum==3) {
			savename = savenumtext+"_somabinary"+".tif";
		} else if (namenum==4) {
			savename = savenumtext+"_neuritesbinary"+".tif";
		} else if (namenum==5) {
			savename = savenumtext+"_neuritesbinary_dt"+".tif";
		} else if (namenum==6) {
			savename = savenumtext+"_mitobinary"+".tif";
		}
		
		saveAs("Tiff", savedir+savename);
		
		close();
		i++;
	} 
} 
selectImage(id); 
close(); 