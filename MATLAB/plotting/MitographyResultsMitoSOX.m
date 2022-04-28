%%% 
% Get all the results from the mitography, into variables for morphology
% and boolean variables.
% Version - MitoSOX
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
% Data folder
masterFolderPath = fullfile(datafolder,'mitosox','matlab\');
%
areathresh_wEll = 0.1;
mitosPerFile = 1000;
lastFileNumber = 3;
%%%

filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);   
try
    dataparam = dlmread(filepathparam,'',1,1);
    mitoLen = dataparam(1,3);
    actinLen = dataparam(1,1);
catch err
    mitoLen = 0;
    actinLen = 0;
end

fileNumbers = 1:lastFileNumber;

filenameAnalysis = '_MitoAnalysisFull.txt';

%%% TAKE CARE OF ALL MITOCHONDRIA DATA

mitoWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoWidthEllFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
doublepeakfitFiles = zeros(mitosPerFile,2,lastFileNumber);
mitosoxParamFiles = zeros(mitosPerFile,2,lastFileNumber);
mitosoxvalFiles = zeros(mitosPerFile,2,lastFileNumber);
ompvalFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);
bkgParamFiles = zeros(mitosPerFile,2,lastFileNumber);

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
        widthMito = data(1:end,8);
        doublepeakfit = data(1:end,29);
        mitosoxval = data(1:end,111);
        mitosoxparam = data(1:end,112);
        ompval = data(1:end,115);
        
        somaparam = data(1:end,109);
        borderparam = data(1:end,110);
        bkgparam = data(1:end,116);

        for i=1:length(areaMito)
            mitoAreaFiles(i,1,fileNum) = i;
            mitoAreaFiles(i,2,fileNum) = areaMito(i);
            mitoWidthFiles(i,1,fileNum) = i;
            mitoWidthFiles(i,2,fileNum) = widthMito(i);
            mitoWidthEllFiles(i,1,fileNum) = i;
            mitoWidthEllFiles(i,2,fileNum) = widthEllMito(i);
            mitoLengthFiles(i,1,fileNum) = i;
            if areaMito(i) < 0.2
                mitoLengthFiles(i,2,fileNum) = lengthMito(i);
            else
                mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            end
            doublepeakfitFiles(i,1,fileNum) = i;
            doublepeakfitFiles(i,2,fileNum) = doublepeakfit(i);
            
            mitosoxParamFiles(i,1,fileNum) = i;
            mitosoxParamFiles(i,2,fileNum) = mitosoxparam(i);
            mitosoxvalFiles(i,1,fileNum) = i;
            mitosoxvalFiles(i,2,fileNum) = mitosoxval(i);
            ompvalFiles(i,1,fileNum) = i;
            ompvalFiles(i,2,fileNum) = ompval(i);
            
            somaParamFiles(i,1,fileNum) = i;
            somaParamFiles(i,2,fileNum) = somaparam(i);
            borderParamFiles(i,1,fileNum) = i;
            borderParamFiles(i,2,fileNum) = borderparam(i);
            bkgParamFiles(i,1,fileNum) = i;
            bkgParamFiles(i,2,fileNum) = bkgparam(i);

        end
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

mitoWidth = [];
mitoLength = [];
mitoAR = [];
mitoArea = [];
mitoMitoSOX = [];
mitoOMP = [];
mitoMitoSOXparam = [];
mitodoublepeakparam = [];

for fileNum=fileNumbers
    for i=1:mitosPerFile
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | bkgParamFiles(i,2,fileNum);
        if mitoWidthFiles(i,2,fileNum) ~= 0 && ~allcheck
            % Calculate AR as w_ell/l_ell if the area is small enough
            % (A<0.2 ?m^2), while instead use w_fit/l_ell if the
            % mitochondria is bigger. The fitted width will always be the
            % more accurate width, but since we don't have a completely 
            % accurate (fitted) length for the small mitos, the AR will be 
            % more accurate by using the ellipsoidal width and length for 
            % the smaller mitos. 
            if mitoAreaFiles(i,2,fileNum) < areathresh_wEll
                ARtemp = mitoWidthEllFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            else
                ARtemp = mitoWidthFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            end
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            mitoWidth = [mitoWidth; mitoWidthFiles(i,2,fileNum)];
            mitoArea = [mitoArea; mitoAreaFiles(i,2,fileNum)];
            mitoLength = [mitoLength; mitoLengthFiles(i,2,fileNum)];
            mitoAR = [mitoAR; ARtemp];
            mitoMitoSOX = [mitoMitoSOX; mitosoxvalFiles(i,2,fileNum)];
            mitoOMP = [mitoOMP; ompvalFiles(i,2,fileNum)];
            mitoMitoSOXparam = [mitoMitoSOXparam; mitosoxParamFiles(i,2,fileNum)];
            mitodoublepeakparam = [mitodoublepeakparam; doublepeakfitFiles(i,2,fileNum)];
        end
    end 
end

clearvars -except mitoWidth mitoArea mitoLength mitoAR mitoMitoSOX mitoOMP mitoMitoSOXparam mitodoublepeakparam
