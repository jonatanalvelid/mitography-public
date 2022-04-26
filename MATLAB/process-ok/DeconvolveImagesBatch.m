%%%
% Mitography - Deconvolution of set of images (folder batch)
%
% @jonatanalvelid
%%%

clear

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(filename))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);
datafolder = fullfile(doubleparentfolder{1},'example-data');

%%%
% Parameters
% deconvolution
px_size = 30;  % pixel size in nm of input images
fwhmpsf = 70;  % FWHM of imaging PSF in nm
% data folder
masterFolderPath = fullfile(datafolder,'tmre','raw\');
masterFolderPathSave = fullfile(datafolder,'tmre','raw','rl\');
%%%

fileList = dir(fullfile(masterFolderPath, 'Image*.tif'));
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(7:9));
end
lastFileNumber = max(filenumbers);

fileNumbers = 1:lastFileNumber;

filenameallmito = '-Mitochondria.tif';
filenameallmitosave = '-Mitochondria.tif';

for fileNum = fileNumbers
    filepathmito = strFilepath(fileNum,filenameallmito,masterFolderPath);
    filepathmitosave = strFilepath(fileNum,filenameallmitosave,masterFolderPathSave);
    
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

