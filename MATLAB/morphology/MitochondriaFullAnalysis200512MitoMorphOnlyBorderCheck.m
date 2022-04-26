%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200512
% New script to handle only mito morphology. 
% For AA treated OXPHOS and PEX data, but can be used for all.
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\NEW\Antimycin Treatments_April2020\6h_5nM AA\Glucose_DIV8_280420_PEX14_MAP_OMP25'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);
try
    dataparam = readtable(filepathparam);
    mitoLineProfLength = dataparam.MitoLineProfLen;
    actinLineProfLength = dataparam.ActLineProfLen;
catch err
    mitoLineProfLength = input('What is the mitochondria line profile length (um)? ');
    actinLineProfLength = input('What is the actin line profile length (um)? ');
end

lastFileNumber = input('What is the number of the last image? ');
mitosPerFile = 1000;
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
gaussianFitting = 1;

fileNumbers = 1:lastFileNumber;
% fileNumbers = 1;

%% 
%%% COMBINE THE MITO AND ACTIN FILES, TO SAVE THE LOCAL ACTIN WIDTH WITH
%%% EVERY MITOCHONDRIA DIRECTLY, IN THE SAME FILE, INSTEAD OF READING FROM
%%% ALL THREE FILES AT THE SAME TIME LATER AT THE TIME OF PLOTTING.

filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameBkgBinary = '-BkgBinary.tif';
filenameAISBinary = '-AISBinary.tif';
filenameMito = '_OnlyMitoImage.tif';
filenameallPxs = '_PixelSizes.txt';

for fileNum = fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathMito = strFilepath(fileNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathBkgBinary = strFilepath(fileNum,filenameBkgBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
 
    try
        try
            dataAnalysis = dlmread(filepathAnaSave);
            sizeData = size(dataAnalysis);
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

        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
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