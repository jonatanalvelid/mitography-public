%%%
% Mitography - anitDNA analysis
% Analysing number of nucleoids in mitochondria, based on DNA and
% Tom20-staining.
%----------------------------
% Version: 200312
% Last updated features: New script
%
% @jonatanalvelid
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('T:\Mitography'),'\');
fileList = dir(fullfile(masterFolderPath, 'Image_*.txt'));
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(7:9));
end
lastFileNumber = max(filenumbers);

threshsize = 8;  % Lower threshold size in pixels for binary mitochondria

filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenamenucleoids = '_Nucleoids.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '-MitoBinary.tif';
% filenameSomaBinary = '-SomaBinary.tif';
filenameAISBinary = '_Map2Binary.tif';
% filenameAxonDistInfo = '_AxonDistInfo.txt';
fileNumbers = 1:lastFileNumber;

for fileNum = fileNumbers
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath(fileNum,filenameallMito,masterFolderPath);
    filepathnucleoids = strFilepath(fileNum,filenamenucleoids,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
%     filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
%     filepathAxonDistInfo = strFilepath(fileNum,filenameAxonDistInfo,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',1,1);
        datanucleoids = dlmread(filepathnucleoids,'',1,1);
        [~,params] = size(datamito);
        
        % Read the pixel size (in nm)
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1)/1000;
        
        % Load binary mitochondria image 
        imagemitobinary = imread(filepathMitoBinary);
        imsize = size(imagemitobinary);
        
        % Load binary Map2 image 
        imagemap2binary = imread(filepathAISBinary);
        imagemap2binary = imagemap2binary/max(max(imagemap2binary));
        
        % Make binary nucleoid center map 
        nucleoidmap = zeros(size(imagemitobinary));
        [numnucl, ~] = size(datanucleoids);
        for i = 1:numnucl
            xpos = datanucleoids(i,2);
            xpos = round(xpos/pixelsize);
            ypos = datanucleoids(i,3);
            ypos = round(ypos/pixelsize);
            % Make sure all coordinates are in the range of the img size
            xpos = min(max(xpos,1),imsize(2));
            ypos = min(max(ypos,1),imsize(1));
            nucleoidmap(ypos,xpos) = 1;
        end
        
        % Remove small objects and make labelled binary mitochondria image
        imagemitobinary = bwareaopen(imagemitobinary, threshsize);
        [labelmito, num] = bwlabel(imagemitobinary');
        labelmito = labelmito';
        
%         % Mark those mitochondria that are in "soma" areas
%         try
%             imagesomabinary = imread(filepathSomaBinary);
%             imagesomabinary = logical(imagesomabinary);
%         catch err
%             imagesomabinary = zeros(size(imagemitobinary));
%             imagesomabinary = logical(imagesomabinary);
%         end
%         for i = 1:num
%             xpos = datamito(i,1);
%             xpos = round(xpos/pixelsize);
%             ypos = datamito(i,2);
%             ypos = round(ypos/pixelsize);
%             % Make sure all coordinates are in the range of the img size
%             xpos = min(max(xpos,1),imsize(2));
%             ypos = min(max(ypos,1),imsize(1));
%             datamito(i,params+1) = imagesomabinary(ypos,xpos);
%         end
        
        % Get number of nucleoids in each mito and save to mitoinfo
        % Also save map2/or not as a binary variable in datamito
        for i = 1:num
            singlemitobinary = ismember(labelmito, i);
            singlemitonucleoids = nucleoidmap.*singlemitobinary;
            datamito(i,params+1) = sum(sum(singlemitonucleoids));
            datamito(i,params+2) = mitoAIS(datamito(i,2),datamito(i,1),pixelsize,imagemap2binary);
        end

        % Save data
        disp(strcat(num2str(fileNum),': Done.'))
%         dlmwrite(filepathAnaSave,datamito,'delimiter','\t');
        writematrix(datamito,filepathAnaSave,'Delimiter','tab')
    catch err
        disp(strcat(num2str(fileNum),': General error.'));
    end 
    
end