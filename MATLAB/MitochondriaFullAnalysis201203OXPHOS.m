%%%
%
% Mitography - OXPHOS (AA/control)
%
%----------------------------
%
% Version: 201203
% Handle only basic mito morphology and OXPHOS/OMP signal. 
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
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
gaussianFitting = 1;

imgNumbers = 1:lastFileNumber;

%% 
%%% ANALYSIS

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '-mitobinary.tif';
filenameSomaBinary = '-somabinary.tif';
filenameNeuritesBinary = '-neuritesbinary.tif';
filenameOxphosBinary = '-oxphosbinary.tif';
filenameOxphos = '-oxphos.tif';
filenameMito = '-mitochondria.tif';
filenameallPxs = '_PixelSizes.txt';

filenamecellnum = 'cellnumber.txt';
filenameoxphosthresh = 'oxphos-thresh.txt';
filepathcellnum = strcat(masterFolderPath,filenamecellnum);
filepathoxphosthresh = strcat(masterFolderPath,filenameoxphosthresh);
cellnums = load(filepathcellnum);
oxphos_threshs = dlmread(filepathoxphosthresh,'\t',1,0);

tukeys = nan(lastFileNumber,1);

fileNum = 1;
for imgNum = imgNumbers
    filepathAnaSave = strFilepath(imgNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(imgNum,filenameAnalysis,masterFolderPath);
    filepathpxs = strFilepath(imgNum,filenameallPxs,masterFolderPath);
    filepathOxphos = strFilepath(imgNum,filenameOxphos,masterFolderPath);
    filepathMito = strFilepath(imgNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(imgNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(imgNum,filenameSomaBinary,masterFolderPath);
    filepathNeuritesBinary = strFilepath(imgNum,filenameNeuritesBinary,masterFolderPath);
    filepathOxphosBinary = strFilepath(imgNum,filenameOxphosBinary,masterFolderPath);
 
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
            sizeData = size(dataAnalysis);
        catch err
            disp(strcat(num2str(imgNum),': File reading error.'));
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

        try
            imageoxphos = imread(filepathOxphos);
        catch err
            imageoxphos = zeros(size(imagemitobinary));
        end
        try
            imageomp = imread(filepathMito);
        catch err
            imageomp = zeros(size(imagemitobinary));
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
        
        %%% MITOCHONDRIA OXPHOS CHECK AND FLAGGING
        if ~isempty(dataAnalysis)
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlemitobinary = ismember(labelmito, i);
                % get a list of mitosox and omp pixels in this area
                oxphossignal = imageoxphos(singlemitobinary);
                ompsignal = imageomp(singlemitobinary);
                % get average MitoSOX and OMP signal/pixel per mito
                oxphossignalavg = mean(oxphossignal);
                ompsignalavg = mean(ompsignal);
                dataAnalysis(i,111) = oxphossignalavg;  % OXPHOS SIGNAL
                dataAnalysis(i,115) = ompsignalavg;  % OMP25 SIGNAL
            end

            % read oxphos threshold signal for the right cell number
            cellnum = cellnums(fileNum);
            ind = oxphos_threshs(:,1) == cellnum;
            threshsignal = oxphos_threshs(ind,2);
            %disp(imgNum),disp(fileNum),disp(cellnum),disp(ind),disp(threshsignal)
            
            % save boolean variable for which mito has mitosox signal above
            % thresh (signal) and which are below (no signal)
            for i=1:sizeData(1)
                oxphossignal = dataAnalysis(i,111);
                if oxphossignal > threshsignal
                    dataAnalysis(i,112) = 1;  % OXPHOS PARAM
                else
                    dataAnalysis(i,112) = 0;
                end
            end
        end
        
        % CALCULATE TUKEY THRESHOLD FOR AREA INSIDE NEURITES BUT OUTSIDE
        % MITOCHONDRIA AND OUTSIDE BINARY OXPHOS IMAGE THAT TAKES MOST
        % LARGE AREAS OF OXPHOS THAT ARE NOT INSIDE NON-OMP-LABELLED
        % MITOCHONDRIA
        bkginsideMask = imageneuritesbinary & ~imagemitobinary & ~imageoxphosbinary;
        bkg = imageoxphos(bkginsideMask);
        meanoxpbkg = mean(bkg);
        tukeycr = meanoxpbkg*log(4) + 1.5*meanoxpbkg*log(3);
        tukeys(imgNum) = tukeycr;
        %disp('Tukey criteria - img no')
        %disp(imgNum)
        %disp(tukeycr)
        

        disp(strcat(num2str(imgNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
        fileNum = fileNum+1;
    catch err
        disp(strcat(num2str(imgNum),': No image with this number or a file reading error.'))
    end
end
