%%%%%
% Random mito-actin patch distance simulation
% -------------------------------------------------------
% Use the actin patches and all actin maps from the actual images,
% simulate positions in the image, check if they are inside the actin
% (i.e. inside the neuron) and if so, check the distance to the closest
% actin patch P. Compare the resulting distribution with the real P dist.
% @Jonatan Alvelid
% Created: 2018-10-12
%%%%%

clear all

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(filename))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);
datafolder = fullfile(doubleparentfolder{1},'example-data');

%%%
% Parameters
% data folder
masterFolderPath = fullfile(datafolder,'morphology','main-matlab\');
%%%

lastFileNumber = input('What is the number of the last image? ');
filenumbers = 1:lastFileNumber;

filenameAnalysis = '_MitoAnalysisFull.txt';
noMito = nan(lastFileNumber,1);

for fileNum = filenumbers
    if fileNum < 10
        filename = strcat('Image_00',int2str(fileNum),filenameAnalysis);
    else
        filename = strcat('Image_0',int2str(fileNum),filenameAnalysis);
    end
    filepath = strcat(masterFolderPath,filename);
    try
        data = dlmread(filepath);
        areaMito = data(1:end,4);
        noMito(fileNum) = length(areaMito);
    catch err
        disp('hey')
    end
end

noSim = round(noMito*1);
%allPatchDist = nan(sum(noSim(~isnan(noSim))),1);
allPatchDist = [];

for fileNum = filenumbers
    try
        % Read the pixel size
        filenamePxs = '_PixelSizes.txt';
        filepathpxs = strFilepath(fileNum,filenamePxs,masterFolderPath);
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);

        % Read images of interest
        filenameNeuron = '_NeuronBinary.tif';
        filenameSoma = '_SomaBinary.tif';
        filenamePatchesBinary = '_PatchesBinary.tif';
        filepathneuron = strFilepath(fileNum,filenameNeuron,masterFolderPath);
        filepathsoma = strFilepath(fileNum,filenameSoma,masterFolderPath);
        filepathpatches = strFilepath(fileNum,filenamePatchesBinary,masterFolderPath);
        imgneuron = imread(filepathneuron);
        imgsoma = imread(filepathsoma);
        imgpatches = imread(filepathpatches);
        imgneuron = imgneuron .* (1 - imgsoma);
        imgneuron = bwareaopen(imgneuron, 500);
        % Find pixels which are ~=0 in imgneuron
        pospix = find(imgneuron);
        for i = 1:noSim(fileNum)
            imsize = size(imgneuron);
            %posx = rand()*imsize(2)*pixelsize;  % Position in the image in ?m
            %posy = rand()*imsize(1)*pixelsize;  % Position in the image in ?m
            
            % Randomly pick one of the ~=0 pixels
            randidx = randperm(length(pospix),1);
            imgidx = pospix(randidx);
            [row,col] = ind2sub(imsize,imgidx);
            posx = col*pixelsize;
            posy = row*pixelsize;

            if imgneuron(ceil(posy/pixelsize),ceil(posx/pixelsize)) ~= 0
                % Create a distance map from the actin patches image
                distimg = bwdist(imgpatches)*pixelsize;
                % Calculate the distance to the nearest actin patch
                distance = distNearestActinPatch(posx,posy,pixelsize,distimg);
                %allPatchDist(sum(noSim(1:fileNum-1))+i) = distance;
                allPatchDist = [allPatchDist;distance];
%                 disp(distance);
            end
        end
    catch err
        disp(strcat(num2str(fileNum),': Cannot find image.'));
    end
end

nanmean(allPatchDist)
nanstd(allPatchDist)

histogram(allPatchDist,0:0.25:10,'Normalization','probability')
ylim([0 0.25])

%[h,p,k2stat] = kstest2(allPatchDist,mitopatchdistall);
%p