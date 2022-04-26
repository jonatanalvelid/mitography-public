%%% 
% List all mitochondria # with a certain area, boolean-param,
% and aspect ratio. 
% Version 200612 - TMRE
%%%

%%%
% PARAMETERS
areathresh = 0.086;  % area threshold for mito do be listed
arthresh = 0.5;  % AR threshold for sticks/vesicles decision
sticks = 1;  % 1 = find sticks, 0 = no sticks
vesicles = 0;  % 1 = find vesicles, 0 = no vesicles
posnegchoice = 1;  % 1 = all + mitos (TMRE/MitoSOX), 0 = all - mitos (TMRE/MitoSOX)
%%%

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

% Analysis folder
masterFolderPath = strcat(uigetdir('X:\Mitography\TMR-MitographyAnalysis\MATLAB-RL-new'),'\');

lastFileNumber = 50;
mitosPerFile = 1000;
fileNumbers = 1:lastFileNumber;

filenameAnalysis = '_MitoAnalysisFull.txt';

%%% TAKE CARE OF ALL MITOCHONDRIA DATA

mitoWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoWidthEllFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
doublepeakfitFiles = zeros(mitosPerFile,2,lastFileNumber);
tmreParamFiles = zeros(mitosPerFile,2,lastFileNumber);
tmrevalFiles = zeros(mitosPerFile,2,lastFileNumber);
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
        tmreval = data(1:end,111);
        tmreparam = data(1:end,112);
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
            % Take the maximum of the ellipsoidal and skeletal length.
            if areaMito(i) < 0.2
                mitoLengthFiles(i,2,fileNum) = lengthMito(i);
            else
                mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            end
            doublepeakfitFiles(i,1,fileNum) = i;
            doublepeakfitFiles(i,2,fileNum) = doublepeakfit(i);
            tmreParamFiles(i,1,fileNum) = i;
            tmreParamFiles(i,2,fileNum) = tmreparam(i);
            tmrevalFiles(i,1,fileNum) = i;
            tmrevalFiles(i,2,fileNum) = tmreval(i);
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
        %disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

%%% DISPLAY THE MITOCHONDRIA NUMBER OF CHOOSEN MITOCHONDRIA 
% Decide all parameters based on input params
if ~posnegchoice && sticks
    printmessage = 'All TMRE- sticks:';  % Message to print in console
elseif posnegchoice && sticks
    printmessage = 'All TMRE+ sticks:';
elseif ~posnegchoice && vesicles
    printmessage = 'All TMRE- vesicles:';
elseif posnegchoice && vesicles
    printmessage = 'All TMRE+ vesicles:';
end
disp(printmessage)
n = 0;
for fileNum=fileNumbers
    for i=1:mitosPerFile
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | bkgParamFiles(i,2,fileNum);
        if mitoWidthFiles(i,2,fileNum) ~= 0 && mitoAreaFiles(i,2,fileNum) < areathresh && ~allcheck
            ARtemp = mitoWidthFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            if posnegchoice == tmreParamFiles(i,2,fileNum) && sticks && ARtemp < arthresh
                disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                n = n+1;
            elseif posnegchoice == tmreParamFiles(i,2,fileNum) && vesicles && ARtemp > arthresh
                disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                n = n+1;
            end
        end
    end
end
fprintf('\nFound %i mitochondria (width_fit)! \n',n), disp(''), disp('')

%%% DISPLAY THE MITOCHONDRIA NUMBER OF CHOOSEN MITOCHONDRIA 
% Decide all parameters based on input params
if ~posnegchoice && sticks
    printmessage = 'All TMRE- sticks:';  % Message to print in console
elseif posnegchoice && sticks
    printmessage = 'All TMRE+ sticks:';
elseif ~posnegchoice && vesicles
    printmessage = 'All TMRE- vesicles:';
elseif posnegchoice && vesicles
    printmessage = 'All TMRE+ vesicles:';
end
disp(printmessage)
n = 0;
for fileNum=fileNumbers
    for i=1:mitosPerFile
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | bkgParamFiles(i,2,fileNum);
        if mitoWidthFiles(i,2,fileNum) ~= 0 && mitoAreaFiles(i,2,fileNum) < areathresh && ~allcheck
            ARtemp = mitoWidthEllFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            if posnegchoice == tmreParamFiles(i,2,fileNum) && sticks && ARtemp < arthresh
                disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                n = n+1;
            elseif posnegchoice == tmreParamFiles(i,2,fileNum) && vesicles && ARtemp > arthresh
                disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                n = n+1;
            end
        end
    end
end
fprintf('\nFound %i mitochondria (width_ell)! \n',n)