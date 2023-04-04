%%% 
% Get all the results from the mitography run on peroxisomes (PEX),
% into variables for morphology and boolean variables.
% Version - OMP
%%%

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
    masterFolderPath = fullfile(datafolder,'fluo-signal-levels','pex','matlab-ct\');
else
    masterFolderPath = strcat(uigetdir('X:\LOCAL\PATH\HERE'),'\');
end
%
areathresh_wEll = 0.1;
mitosPerFile = 1000;
lastFileNumber = 27;
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
pexParamFiles = zeros(mitosPerFile,2,lastFileNumber);
pexvalFiles = zeros(mitosPerFile,2,lastFileNumber);
ompvalFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
neuritesParamFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);

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
        %disp(join([num2str(fileNum),': ',num2str(length(areaMito)),' mitos']));
        lengthMito = data(1:end,5); %Ellipsoidal fit mitochondria length (major axis)
        widthEllMito = data(1:end,6); %Ellipsoidal fit mitochondria width (minor axis)
        lengthSkelMito = data(1:end,7); %Skeleton mitochondria length (skeleton part closest to the mitochondria centroid)
        pexval = data(1:end,111);
        pexparam = data(1:end,112);
        ompval = data(1:end,115);
        
        neuritesparam = data(1:end,107);
        somaparam = data(1:end,109);
        borderparam = data(1:end,110);

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
            
            pexParamFiles(i,1,fileNum) = i;
            pexParamFiles(i,2,fileNum) = pexparam(i);
            pexvalFiles(i,1,fileNum) = i;
            pexvalFiles(i,2,fileNum) = pexval(i);
            ompvalFiles(i,1,fileNum) = i;
            ompvalFiles(i,2,fileNum) = ompval(i);
            
            neuritesParamFiles(i,1,fileNum) = i;
            neuritesParamFiles(i,2,fileNum) = neuritesparam(i);
            somaParamFiles(i,1,fileNum) = i;
            somaParamFiles(i,2,fileNum) = somaparam(i);
            borderParamFiles(i,1,fileNum) = i;
            borderParamFiles(i,2,fileNum) = borderparam(i);

        end
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

mitoWidth = [];
mitoLength = [];
mitoAR = [];
mitoArea = [];
mitoOMP = [];
mitoPEX = [];
mitoPEXparam = [];
mitonums = [];

for fileNum=fileNumbers
    n = 0;
    for i=1:mitosPerFile
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | ~neuritesParamFiles(i,2,fileNum);
        if mitoWidthEllFiles(i,2,fileNum) ~= 0 && ~allcheck
            n = n + 1;
            % Calculate AR as w_ell/l_ell if the area is small enough
            % (A<0.2 um^2), while instead use w_fit/l_ell if the
            % mitochondria is bigger. The fitted width will always be the
            % more accurate width, but since we don't have a completely 
            % accurate (fitted) length for the small mitos, the AR will be 
            % more accurate by using the ellipsoidal width and length for 
            % the smaller mitos. 
            ARtemp = mitoWidthEllFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            mitoWidth = [mitoWidth; mitoWidthEllFiles(i,2,fileNum)];
            mitoArea = [mitoArea; mitoAreaFiles(i,2,fileNum)];
            mitoLength = [mitoLength; mitoLengthFiles(i,2,fileNum)];
            mitoAR = [mitoAR; ARtemp];
            mitoPEX = [mitoPEX; pexvalFiles(i,2,fileNum)];
            mitoOMP = [mitoOMP; ompvalFiles(i,2,fileNum)];
            mitoPEXparam = [mitoPEXparam; pexParamFiles(i,2,fileNum)];
        end
    end
    disp(join([num2str(fileNum),': ',num2str(n),' mitos']))
    mitonums = [mitonums; n];
end

clearvars -except mitoWidth mitoArea mitoLength mitoAR mitoPEX mitoOMP mitoPEXparam mitoinfo cellnums mitonums
