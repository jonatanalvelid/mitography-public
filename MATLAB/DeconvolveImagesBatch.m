%%%
% Mitography - Deconvolution of set of images (folder batch)
%----------------------------
% Version: 200226
% Last updated features: New script
%
% @jonatanalvelid
%%%

clear

% Input parameters
px_size = 30;  % pixel size in nm of input images
fwhmpsf = 70;  % FWHM of imaging PSF in nm

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\TMR-MitographyAnalysis\Raw data - test'),'\');
masterFolderPathsave = strcat(uigetdir('X:\Mitography\TMR-MitographyAnalysis\RL data - test'),'\');
fileList = dir(fullfile(masterFolderPath, 'Image*.tif'));
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(7:9));
end
lastFileNumber = max(filenumbers);

% fileNumbers = 1:lastFileNumber;
fileNumbers = 16:25;

filenameallmito = '-Mitochondria.tif';
filenameallmitosave = '-Mitochondria.tif';

for fileNum = fileNumbers
    filepathmito = strFilepath(fileNum,filenameallmito,masterFolderPath);
    filepathmitosave = strFilepath(fileNum,filenameallmitosave,masterFolderPathsave);
    
    try
        % Read the mitochondria image
        imgmito = imread(filepathmito);
        
        % Deconvolve image (after smoothing it to dampen noise in deconimg)
        imgmitodecon = uint8(rldeconv(imgaussfilt(imgmito,0.8), fwhmpsf, px_size));
        
        disp(filepathmitosave)
        % Save deconvolved image
        imwrite(imgmitodecon,filepathmitosave,'tiff'); 
        disp('Saved!')
        
    catch err
        disp('Failed')
    end
    
    
end

