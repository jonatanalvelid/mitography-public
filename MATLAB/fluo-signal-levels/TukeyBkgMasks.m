%%%
% Tukey bkg mask calucation - take signal from this
% area to calculate background of fluoresence signal to use for calculating
% the Tukey threshold for boolean signal +/-. For OXPHOS/PEX for example.
%
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
% Use example data (True) or local data (False)
example_data = false;
% Data folder
if example_data
    masterFolderPath = fullfile(datafolder,'fluo-signal-levels','oxphos','matlab\');
else
    masterFolderPath = strcat(uigetdir('X:\LOCAL\PATH\HERE'),'\');
end
%%%

lastFileNumber = input('What is the number of the last image? ');
mitosPerFile = 1000;

imgNumbers = 1:lastFileNumber;

filenameMitoBinary = '-mitobinary.tif';
filenameNeuritesBinary = '-neuritesbinary.tif';
filenameOxphosBinary = '-oxphosbinary.tif';
filenameSave = '-oxphosbkgbinary.tif';

for imgNum = imgNumbers
    filepathMitoBinary = strFilepath(imgNum,filenameMitoBinary,masterFolderPath);
    filepathNeuritesBinary = strFilepath(imgNum,filenameNeuritesBinary,masterFolderPath);
    filepathOxphosBinary = strFilepath(imgNum,filenameOxphosBinary,masterFolderPath);
    savepath = strFilepath(imgNum,filenameSave,masterFolderPath);
 
    try
        % Read images
        imagemitobinary = imread(filepathMitoBinary);
        imagemitobinary = logical(imagemitobinary);
        try
            imageneuritesbinary = imread(filepathNeuritesBinary);
            imageneuritesbinary = logical(imageneuritesbinary);
        catch err
            imageneuritesbinary = zeros(size(imagemitobinary));
            imageneuritesbinary = logical(imageneuritesbinary);
        end
        try
            imageoxphosbinary = imread(filepathOxphosBinary);
            imageoxphosbinary = logical(imageoxphosbinary);
        catch err
            imageoxphosbinary = zeros(size(imagemitobinary));
            imageoxphosbinary = logical(imageoxphosbinary);
        end

        bkginsideMask = imageneuritesbinary & ~imagemitobinary & ~imageoxphosbinary;
        
        imwrite(bkginsideMask, savepath)
        
    catch err
        disp(strcat(num2str(imgNum),': No image with this number or a file reading error.'))
    end
end

