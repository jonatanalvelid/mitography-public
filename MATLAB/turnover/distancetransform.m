%%%%%%%%%%%%%%
% PARAMETERS
folderpath = 'D:\Data analysis\Temp\distancetransform\';
filenameSomaBinary = '003_somabinary.tif';
filenameNeuritesbinary = '003_neuritesbinary.tif';
image_savename = 'neuritesbinary_dt_fused.tif';
%%%%%%%%%%%%%%

filename_neuritesbinary = strcat(folderpath,filenameNeuritesbinary);
filename_somabinary = strcat(folderpath,filenameSomaBinary);
filename_imagesave = strcat(folderpath,image_savename);

image_neuritesbinary = imread(filename_neuritesbinary);
image_neuritesbinary = logical(image_neuritesbinary);

image_somabinary = imread(filename_somabinary);
image_somabinary = logical(image_somabinary);

imdata = bwdistgeodesic(logical(image_neuritesbinary), logical(image_somabinary), 'quasi-euclidean');
imdata = uint16(imdata);
t = Tiff(filename_imagesave, 'w');
t.setTag('ImageLength', size(imdata,1));
t.setTag('ImageWidth', size(imdata,2));
t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
t.setTag('BitsPerSample', 16);
t.setTag('SamplesPerPixel', size(imdata,3));
t.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
t.setTag('Software', 'MATLAB');
t.write(imdata);
t.close();