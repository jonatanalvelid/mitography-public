%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200513
% Handle only mito morphology and MitoSOX/OMP signal. 
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\temp_oxphos\exp1-Glucose_DIV8_280420_OXPHOS_MAP_OMP25\matlab_analysis'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);

lastFileNumber = input('What is the number of the last image? ');
mitosPerFile = 1000;
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
gaussianFitting = 1;

filenameall = '_MitoLineProfiles.txt';
filenameupper = '_MitoUpperLineProfiles.txt';
filenamebottom = '_MitoBottomLineProfiles.txt';
filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
imgNumbers = 1:lastFileNumber;

%% 
%%% ANALYSIS

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameMitoSOX = '-pex.tif';
filenameMito = '-Mitochondria.tif';

filenamecellnum = 'cellnumber.txt';
filenameoxphosthresh = 'pex-thresh.txt';
filepathcellnum = strcat(masterFolderPath,filenamecellnum);
filepathoxphosthresh = strcat(masterFolderPath,filenameoxphosthresh);
cellnums = load(filepathcellnum);
oxphos_threshs = dlmread(filepathoxphosthresh,'\t',1,0);

fileNum = 1;
for imgNum = imgNumbers
    filepathAnaSave = strFilepath(imgNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(imgNum,filenameAnalysis,masterFolderPath);
    filepathpxs = strFilepath(imgNum,filenameallPxs,masterFolderPath);
    filepathMitoSOX = strFilepath(imgNum,filenameMitoSOX,masterFolderPath);
    filepathMito = strFilepath(imgNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(imgNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(imgNum,filenameSomaBinary,masterFolderPath);
 
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
            imagebkgbinary = imread(filepathBkgBinary);
            imagebkgbinary = logical(imagebkgbinary);
        catch err
            imagebkgbinary = zeros(size(imagemitobinary));
            imagebkgbinary = logical(imagebkgbinary);
        end
        try
            imagemitosox = imread(filepathMitoSOX);
        catch err
            imagemitosox = zeros(size(imagemitobinary));
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
                mitosoxsignal = imagemitosox(singlemitobinary);
                ompsignal = imageomp(singlemitobinary);
                % get average MitoSOX and OMP signal/pixel per mito
                mitosoxsignalavg = mean(mitosoxsignal);
                ompsignalavg = mean(ompsignal);
                dataAnalysis(i,111) = mitosoxsignalavg;  % OXPHOS SIGNAL
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
                mitosoxsignal = dataAnalysis(i,111);
                if mitosoxsignal > threshsignal
                    dataAnalysis(i,112) = 1;  % OXPHOS PARAM
                else
                    dataAnalysis(i,112) = 0;
                end
            end
        end

        disp(strcat(num2str(imgNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
        fileNum = fileNum+1;
    catch err
        disp(strcat(num2str(imgNum),': No image with this number or a file reading error.'))
    end
end