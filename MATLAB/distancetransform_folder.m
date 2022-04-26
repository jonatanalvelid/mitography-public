%%%
% Mitography - Turnover analysis
% Distance transform a whole folder of neuritesbinary + somabinary
%----------------------------
% Version: 201112
% Last updated features: First version
%
% @jonatanalvelid
%%%
clear
% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\temp_analysis_turnover\controls\flipping'),'\');
fileList_nb = dir(fullfile(masterFolderPath,'*_neuritesbinary.tif'));
fileList_sb = dir(fullfile(masterFolderPath,'*_somabinary.tif'));

for i = 1:length(fileList_nb)
    filenumbers(i) = str2num(fileList_nb(i).name(1:3));
end

filenamenb = '_neuritesbinary.tif';
filenamesb = '_somabinary.tif';

for fileNum = filenumbers
    filepathnb = strFilepath2(fileNum,filenamenb,masterFolderPath);
    filepathsb = strFilepath2(fileNum,filenamesb,masterFolderPath);
    
    nb = imread(filepathnb);
    try
        sb = imread(filepathsb);
    catch err
        imagesomabinary = zeros(size(nb));
    end
    disttrans(nb,sb,sprintf('%03d',fileNum));
end

function disttrans(nb, sb, imnum)
    imdata = bwdistgeodesic(logical(nb), logical(sb), 'quasi-euclidean');
    imdata = uint16(imdata);
    t = Tiff(strcat('E:\PhD\data_analysis\Temp\',imnum,'_neuritesbinary_dt.tif'),'w');
    t.setTag('ImageLength',size(imdata,1));
    t.setTag('ImageWidth', size(imdata,2));
    t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    t.setTag('BitsPerSample', 16);
    t.setTag('SamplesPerPixel', size(imdata,3));
    t.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    t.setTag('Software', 'MATLAB');
    t.write(imdata);
    t.close();
end
