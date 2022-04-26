%%%
%
% Mitography - OXPHOS (AA/control) - Tukey bkg calc mask
%
%----------------------------
%
% Version: 210301
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\antimycin'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);

lastFileNumber = input('What is the number of the last image? ');
mitosPerFile = 1000;

imgNumbers = 1:lastFileNumber;

%% 
%%% ANALYSIS

filenameMitoBinary = '-mitobinary.tif';
filenameNeuritesBinary = '-neuritesbinary.tif';
filenameOxphosBinary = '-oxphosbinary.tif';
filenameSave = '-oxphosbkgbinary.tif';

fileNum = 1;
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

