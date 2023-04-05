%%%
% Mitography - morphology - NO FITTING
% Analyses all info spitted out from the ImageJ Mitography script,
% and gives the info including binary parameters per mitochondria out.
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
    masterFolderPath = fullfile(datafolder,'morphology','matlab\');
else
    masterFolderPath = strcat(uigetdir('X:\LOCAL\PATH\HERE'),'\');
end

% Maximum number of mitos per image
mitosPerFile = 1000;
%%%

lastFileNumber = input('What is the number of the last image? ');

filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
fileNumbers = 1:lastFileNumber;

%% 
%%% COMBINE THE MITO FILES, AND GET BINARY PARAMETERS

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameBkgBinary = '-BkgBinary.tif';
filenameAISBinary = '-AISBinary.tif';
filenameGenericBinary = '-GenericBinary.tif';
filenameMito = '_OnlyMitoImage.tif';

for fileNum = fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathWid = strFilepath(fileNum,filenameWidths,masterFolderPath);
    filepathUpperWid = strFilepath(fileNum,filenameUpperWidths,masterFolderPath);
    filepathBottomWid = strFilepath(fileNum,filenameBottomWidths,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathMito = strFilepath(fileNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathBkgBinary = strFilepath(fileNum,filenameBkgBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
    filepathGenericBinary = strFilepath(fileNum,filenameGenericBinary,masterFolderPath);
    filepathAllFitsWid = strFilepath(fileNum,filenameAllFitsWidths,masterFolderPath);
    filepathAllFitsUpperWid = strFilepath(fileNum,filenameAllFitsUpperWidths,masterFolderPath);
    filepathAllFitsBottomWid = strFilepath(fileNum,filenameAllFitsBottomWidths,masterFolderPath);
 
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
            sizeData = size(dataAnalysis);
            dataWid = dlmread(filepathWid);
            dataUpperWid = dlmread(filepathUpperWid);
            dataBottomWid = dlmread(filepathBottomWid);
            dataAllFitsWid = dlmread(filepathAllFitsWid);
            dataAllFitsUpperWid = dlmread(filepathAllFitsUpperWid);
            dataAllFitsBottomWid = dlmread(filepathAllFitsBottomWid);
        catch err
            disp(strcat(num2str(fileNum),': File reading error.'));
        end
        % Read images
        imagemitobinary = imread(filepathMitoBinary);
        imagemitobinary = logical(imagemitobinary);
        try
            imageaisbinary = imread(filepathAISBinary);
            imageaisbinary = logical(imageaisbinary);
        catch err
            imageaisbinary = zeros(size(imagemitobinary));
            imageaisbinary = logical(imageaisbinary);
        end
        try
            imagesomabinary = imread(filepathSomaBinary);
            imagesomabinary = logical(imagesomabinary);
        catch err
            imagesomabinary = zeros(size(imagemitobinary));
            imagesomabinary = logical(imagesomabinary);
        end
        try
            imagebkgbinary = imread(filepathBkgBinary);
            imagebkgbinary = logical(imagebkgbinary);
        catch err
            imagebkgbinary = zeros(size(imagemitobinary));
            imagebkgbinary = logical(imagebkgbinary);
        end
        try
            imagegenericmapbinary = imread(filepathGenericBinary);
            imagegenericmapbinary = logical(imagegenericmapbinary);
        catch err
            imagegenericmapbinary = zeros(size(imagemitobinary));
            imagegenericmapbinary = logical(imagegenericmapbinary);
        end
        

        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        %%% SMALL AREA PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,4) ~= 0 && dataAnalysis(i,4) <= 0.05
                    dataAnalysis(i,20) = 1; %Mito area smaller than 0.05?m^2
                end
            end
        end
%         disp('mito small done')
        
        %%% MITOCHONDRIA BINARY SOMA CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                insomaparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagesomabinary);
                if insomaparam ~= 0
                    dataAnalysis(i,109) = 1;  % SOMA
                elseif insomaparam == 0
                    dataAnalysis(i,109) = 0;  % SOMA
                end
            end
        end
        
        %%% MITOCHONDRIA BINARY BKG CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                inbkgparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagebkgbinary);
                if inbkgparam ~= 0
                    dataAnalysis(i,116) = 1;  % BKG
                elseif inbkgparam == 0
                    dataAnalysis(i,116) = 0;  % BKG
                end
            end
        end
        
        %%% MITOCHONDRIA GENERIC BINARY MAP CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                inbkgparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagegenericmapbinary);
                if inbkgparam ~= 0
                    dataAnalysis(i,14) = 1;  % BINARY
                elseif inbkgparam == 0
                    dataAnalysis(i,14) = 0;  % BINARY
                end
            end
        end
 
        %%% MITOCHONDRIA BINARY BORDER CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                % label mitos with flipped axes, to mimic ImageJ labeling
                [labelmito, num] = bwlabel(imagemitobinary');
                % flip axes back
                labelmito = labelmito';
                % mark all mitochondria that are touching the border
                %imagemitobin = imbinarize(labelmito);
                bordermitoimg1 = imagemitobinary - imclearborder(imagemitobinary);
                n = 2;
                imagemitobinary2 = imagemitobinary(n+1:end-n,n+1:end-n);
                bordermitoimg2 = imagemitobinary2 - imclearborder(imagemitobinary2);
                bordermitoimg2 = padarray(bordermitoimg2,[n n]);
                labelbordermitoimg = labelmito .* (bordermitoimg1 | bordermitoimg2);
                bordermito = nonzeros(unique(labelbordermitoimg));
                for m = bordermito
                    dataAnalysis(m,110) = 1;  % BORDER
                end
            end
        end
        
        disp(strcat(num2str(fileNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end
end
