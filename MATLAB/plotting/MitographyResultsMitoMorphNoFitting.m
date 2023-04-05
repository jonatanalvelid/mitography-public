%%% 
% Get all the results from the mitography, into variables for morphology
% and boolean variables.
% Version - Only mitochondria morphology - no fitted mito width
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
%
mitosPerFile = 1000;
lastFileNumber = 12;
%%%

fileNumbers = 1:lastFileNumber;

filenameAnalysis = '_MitoAnalysisFull.txt';

%%% TAKE CARE OF ALL MITOCHONDRIA DATA

mitoWidthEllFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);
bkgParamFiles = zeros(mitosPerFile,2,lastFileNumber);
genericBinaryParamFiles = zeros(mitosPerFile,2,lastFileNumber);

for fileNum = fileNumbers
    if fileNum < 10
        filename = strcat('Image_00',int2str(fileNum),filenameAnalysis);
    else
        filename = strcat('Image_0',int2str(fileNum),filenameAnalysis);
    end
    filepath = strcat(masterFolderPath,filename);
    
    try
        data = dlmread(filepath);
        areaMito = data(1:end,4);
        lengthMito = data(1:end,5); %Ellipsoidal fit mitochondria length (major axis)
        widthEllMito = data(1:end,6); %Ellipsoidal fit mitochondria width (minor axis)
        lengthSkelMito = data(1:end,7); %Skeleton mitochondria length (skeleton part closest to the mitochondria centroid)
        
        somaparam = data(1:end,109);
        borderparam = data(1:end,110);
        bkgparam = data(1:end,116);
        genericbinaryparam = data(1:end,14);

        for i=1:length(areaMito)
            mitoAreaFiles(i,1,fileNum) = i;
            mitoAreaFiles(i,2,fileNum) = areaMito(i);
            mitoWidthEllFiles(i,1,fileNum) = i;
            mitoWidthEllFiles(i,2,fileNum) = widthEllMito(i);
            mitoLengthFiles(i,1,fileNum) = i;
            if areaMito(i) < 0.2
                mitoLengthFiles(i,2,fileNum) = lengthMito(i);
            else
                mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            end
            
            somaParamFiles(i,1,fileNum) = i;
            somaParamFiles(i,2,fileNum) = somaparam(i);
            borderParamFiles(i,1,fileNum) = i;
            borderParamFiles(i,2,fileNum) = borderparam(i);
            bkgParamFiles(i,1,fileNum) = i;
            bkgParamFiles(i,2,fileNum) = bkgparam(i);
            genericBinaryParamFiles(i,1,fileNum) = i;
            genericBinaryParamFiles(i,2,fileNum) = genericbinaryparam(i);
            
        end
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

mitoWidth = [];
mitoLength = [];
mitoAR = [];
mitoArea = [];
mitogenericbinaryparam = [];

for fileNum=fileNumbers
    for i=1:mitosPerFile
        % only take mitochondria not in soma, not at border, and not in bkg
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | bkgParamFiles(i,2,fileNum);
        if ~allcheck
            % Calculate AR as w_ell/l_ell if the area is small enough
            % (A<0.2 ?m^2), while instead use w_fit/l_ell if the
            % mitochondria is bigger. The fitted width will always be the
            % more accurate width, but since we don't have a completely 
            % accurate (fitted) length for the small mitos, the AR will be 
            % more accurate by using the ellipsoidal width and length for 
            % the smaller mitos. 
            ARtemp = mitoWidthEllFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            mitoWidth = [mitoWidth; mitoWidthFiles(i,2,fileNum)];
            mitoArea = [mitoArea; mitoAreaFiles(i,2,fileNum)];
            mitoLength = [mitoLength; mitoLengthFiles(i,2,fileNum)];
            mitoAR = [mitoAR; ARtemp];
            mitogenericbinaryparam = [mitogenericbinaryparam; genericBinaryParamFiles(i,2,fileNum)];
        end
    end 
end

clearvars -except mitoWidth mitoArea mitoLength mitoAR mitogenericbinaryparam
