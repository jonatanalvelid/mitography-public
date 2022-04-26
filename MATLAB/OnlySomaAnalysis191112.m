%%%
%
% Version: 191112
% Just binary soma variable analysis.
%
% SOMETHING IN THIS SCRIPT IS NOT WORKING!
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);

lastFileNumber = input('What is the number of the last image? ');
fileNumbers = 1:lastFileNumber;


%% 
%%% COMBINE THE MITO AND ACTIN FILES, TO SAVE THE LOCAL ACTIN WIDTH WITH
%%% EVERY MITOCHONDRIA DIRECTLY, IN THE SAME FILE, INSTEAD OF READING FROM
%%% ALL THREE FILES AT THE SAME TIME LATER AT THE TIME OF PLOTTING.

filenameAnalysis = '_MitoAnalysisFull.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameSomaBinary = '_SomaBinary.tif';
filenameallPxs = '_PixelSizes.txt';
filenameMitoBinary = '_MitoBinary.tif';

for fileNum = fileNumbers
    
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    
    try
        try
            dataAnalysis = dlmread(filepathAna);
            sizeData = size(dataAnalysis);
        catch err
            disp(strcat(num2str(fileNum),': File reading error.'));
        end
        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        % Read the binary mito and patches images
        imagemitobinary = imread(filepathMitoBinary);
        imagemitobinary = logical(imagemitobinary);
        % Read the binary soma image, if it exists
        try
            imagesomabinary = imread(filepathSomaBinary);
            imagesomabinary = logical(imagesomabinary);
        catch err
            disp(strcat(num2str(fileNum),': No binary soma image.'))
            imagesomabinary = zeros(size(imagemitobinary));
            imagesomabinary = logical(imagesomabinary);
        end
        
        %%% MITOCHONDRIA BINARY SOMA CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                insomaparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagesomabinary);
                if insomaparam ~= 0
                    dataAnalysis(i,109) = 1;
                elseif insomaparam == 0
                    dataAnalysis(i,109) = 0;
                end
            end
        end
        
        disp(strcat(num2str(fileNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
    catch err
        disp(err)
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end
end