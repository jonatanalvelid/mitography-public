%%%
% Mitography - only mito signal (start from PEX), no morphology
%
%%%

clear

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(filename))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);

masterFolderPath = strcat(uigetdir('D:\Data analysis\Mitography\AA-PEX\analysis-pex_start\exp2ct\pex-matlab_analysis'),'\');

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
filenamePEXBinary = '-pexbinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameNeuritesBinary = '-neuritesbinary.tif';
filenamePEX = '-pex.tif';
filenameMito = '-mitochondria.tif';

filenamecellnum = 'cellnumber.txt';
filenameompthresh = 'omp-thresh.txt';
filepathcellnum = strcat(masterFolderPath,filenamecellnum);
filepathompthresh = strcat(masterFolderPath,filenameompthresh);
cellnums = load(filepathcellnum);
omp_threshs = dlmread(filepathompthresh,'\t',1,0);

fileNum = 1;
for imgNum = imgNumbers
    filepathAnaSave = strFilepath(imgNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(imgNum,filenameAnalysis,masterFolderPath);
    filepathpxs = strFilepath(imgNum,filenameallPxs,masterFolderPath);
    filepathPEX = strFilepath(imgNum,filenamePEX,masterFolderPath);
    filepathMito = strFilepath(imgNum,filenameMito,masterFolderPath);
    filepathPEXBinary = strFilepath(imgNum,filenamePEXBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(imgNum,filenameSomaBinary,masterFolderPath);
    filepathNeuritesBinary = strFilepath(imgNum,filenameNeuritesBinary,masterFolderPath);
 
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
            sizeData = size(dataAnalysis);
        catch err
            disp(strcat(num2str(imgNum),': File reading error.'));
        end
        % Read images
        imagepexbinary = imread(filepathPEXBinary);
        imagepexbinary = logical(imagepexbinary);
        try
            imageaisbinary = imread(filepathAISBinary);
            imageaisbinary = logical(imageaisbinary);
        catch err
            imageaisbinary = zeros(size(imagepexbinary));
            imageaisbinary = logical(imageaisbinary);
        end
        try
            imagesomabinary = imread(filepathSomaBinary);
            imagesomabinary = logical(imagesomabinary);
        catch err
            imagesomabinary = zeros(size(imagepexbinary));
            imagesomabinary = logical(imagesomabinary);
        end
        try
            imageneuritesbinary = imread(filepathNeuritesBinary);
            imageneuritesbinary = logical(imageneuritesbinary);
        catch err
            imageneuritesbinary = zeros(size(imagepexbinary));
            imageneuritesbinary = logical(imageneuritesbinary);
        end
        try
            imagebkgbinary = imread(filepathBkgBinary);
            imagebkgbinary = logical(imagebkgbinary);
        catch err
            imagebkgbinary = zeros(size(imagepexbinary));
            imagebkgbinary = logical(imagebkgbinary);
        end
        try
            imagemito = imread(filepathMito);
        catch err
            imagemito = zeros(size(imagepexbinary));
        end
        try
            imagepex = imread(filepathPEX);
        catch err
            imagepex = zeros(size(imagepexbinary));
        end

        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        %%% BINARY SOMA CHECK AND FLAGGING
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
        
        %%% BINARY NEURITES CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                inneuritesparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imageneuritesbinary);
                if inneuritesparam ~= 0
                    dataAnalysis(i,107) = 1;  % NEURITES
                elseif inneuritesparam == 0
                    dataAnalysis(i,107) = 0;  % NEURITES
                end
            end
        end
                
        %%% BINARY BORDER CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                % label mitos with flipped axes, to mimic ImageJ labeling
                [labelpex, num] = bwlabel(imagepexbinary');
                % flip axes back
                labelpex = labelpex';
                % mark all mitochondria that are touching the border
                %imagemitobin = imbinarize(labelmito);
                borderpeximg1 = imagepexbinary - imclearborder(imagepexbinary);
                n = 2;
                imagepexbinary2 = imagepexbinary(n+1:end-n,n+1:end-n);
                borderpeximg2 = imagepexbinary2 - imclearborder(imagepexbinary2);
                borderpeximg2 = padarray(borderpeximg2,[n n]);
                labelborderpeximg = labelpex .* (borderpeximg1 | borderpeximg2);
                borderpex = nonzeros(unique(labelborderpeximg));
                for m = borderpex
                    dataAnalysis(m,110) = 1;  % BORDER
                end
            end
        end
        
        %%% MITOMARKER CHECK AND FLAGGING
        if ~isempty(dataAnalysis)
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlepexbinary = ismember(labelpex, i);
                % get a list of pex and mitomarker pixels in this area
                ompsignal = imagemito(singlepexbinary);
                pexsignal = imagepex(singlepexbinary);
                % get average mitosignal and PEX signal/pixel per mito
                ompsignalavg = mean(ompsignal);
                pexsignalavg = mean(pexsignal);
                dataAnalysis(i,111) = ompsignalavg;  % OMP25 SIGNAL (or other mito marker)
                dataAnalysis(i,115) = pexsignalavg;  % PEX SIGNAL
            end

            % read oxphos threshold signal for the right cell number
            cellnum = cellnums(fileNum);
            ind = omp_threshs(:,1) == cellnum;
            threshsignal = omp_threshs(ind,2);
            %disp(imgNum),disp(fileNum),disp(cellnum),disp(ind),disp(threshsignal)
            
            % save boolean variable for which mito has mitomarker signal above
            % thresh (signal) and which are below (no signal)
            for i=1:sizeData(1)
                ompsignal = dataAnalysis(i,111);
                if ompsignal > threshsignal
                    dataAnalysis(i,112) = 1;  % MITOMARKER PARAM
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