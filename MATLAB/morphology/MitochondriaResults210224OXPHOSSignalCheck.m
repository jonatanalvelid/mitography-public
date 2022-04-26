%%% 
%
% Get OXPHOS signal values and plot them, for all mitochondria, to find a
% threshold for the oxphos+/-.
% Version 210224 - OXPHOS
%
%%%
clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\antimycin\exp4_dec20\matlab_analysis'),'\');
%masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\antimycin\exp5_jan21\matlab_analysis'),'\');
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

areathresh_wEll = 0.1;
mitosPerFile = 1000;
lastFileNumber = 50;

filenameAnalysis = '_MitoAnalysisFull.txt';
fileNumbersCells4 = [1 3;4 5;6 7;8 10;11 13;14 16;17 19;20 22;23 25;26 27;28 30;31 33;34 36;37 39;40 41];
fileNumbersCells5 = [1 2;3 6;7 9;10 13;14 16;17 19;20 22;23 25;26 27;28 30;31 33;34 35;36 37;38 39;41 42;43 44;45 47;48 49];
tukeys = [];
nmito = [];

oxphosParamFiles = zeros(mitosPerFile,2,lastFileNumber);
oxphosvalFiles = zeros(mitosPerFile,2,lastFileNumber);
ompvalFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);

for cellno = 1:18
    fileNumbers = fileNumbersCells4(cellno,1):fileNumbersCells4(cellno,2);

    for fileNum = fileNumbers
        if fileNum < 10
            filename = strcat('Image_00',int2str(fileNum),filenameAnalysis);
        else
            filename = strcat('Image_0',int2str(fileNum),filenameAnalysis);
        end
        filepath = strcat(masterFolderPath,filename);

        try
            data = dlmread(filepath);
            oxphosval = data(1:end,111);
            oxphosparam = data(1:end,112);
            ompval = data(1:end,115);

            somaparam = data(1:end,109);
            borderparam = data(1:end,110);

            for i=1:length(oxphosval)
                oxphosParamFiles(i,1,fileNum) = i;
                oxphosParamFiles(i,2,fileNum) = oxphosparam(i);
                oxphosvalFiles(i,1,fileNum) = i;
                oxphosvalFiles(i,2,fileNum) = oxphosval(i);
                ompvalFiles(i,1,fileNum) = i;
                ompvalFiles(i,2,fileNum) = ompval(i);

                somaParamFiles(i,1,fileNum) = i;
                somaParamFiles(i,2,fileNum) = somaparam(i);
                borderParamFiles(i,1,fileNum) = i;
                borderParamFiles(i,2,fileNum) = borderparam(i);

            end
        catch err
            disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
        end  
    end

    mitoOXPHOS = [];
    mitoOMP = [];
    mitoOXPHOSparam = [];

    for fileNum=fileNumbers
        for i=1:mitosPerFile
            allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum);
            if oxphosvalFiles(i,2,fileNum) > 0 && ~allcheck
                mitoOXPHOS = [mitoOXPHOS; oxphosvalFiles(i,2,fileNum)];
                mitoOMP = [mitoOMP; ompvalFiles(i,2,fileNum)];
                mitoOXPHOSparam = [mitoOXPHOSparam; oxphosParamFiles(i,2,fileNum)];
            end
        end 
    end

    meanoxp = mean(mitoOXPHOS);
    tukeycr = meanoxp*log(4) + 1.5*meanoxp*log(3);
    tukeys = [tukeys tukeycr];
    nmito = [nmito length(oxphosval)];
    disp('Tukey criteria - cell no')
    disp(cellno)
    disp(tukeycr)
    disp(meanoxp)
    
    histogram(mitoOXPHOS,'NumBins',100)
    
end

clearvars -except mitoWidth mitoArea mitoLength mitoAR mitoOXPHOS mitoOMP mitoOXPHOSparam tukeys nmito