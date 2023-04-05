%%%
% Turnover analysis
% Analysis the turnover ratio of mito proteins versus to the distance
% from the soma.
%
% @jonatanalvelid
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
    masterFolderPath = fullfile(datafolder,'turnover','\');  % no example data
else
    masterFolderPath = strcat(uigetdir('X:\LOCAL\PATH\HERE'),'\');
end
% Filename endings for the two images with there different labels: label 1
% and label 2
filenameLabel1 = '_label1.tif';
filenameLabel2 = '_label2.tif';
%%%

fileList = dir(fullfile(masterFolderPath,'*'+filenameLabel1));
for i = 1:length(fileList)
    filenumbers(i) = str2double(fileList(i).name(1:3));
end

threshsize = 8;  % Lower threshold size in pixels for binary mitochondria

filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '_somabinary.tif';
filenameNeuritesbinary = '_neuritesbinary.tif';
filenameAxonDistInfo = '_axondistinfo.txt';
filenameAnalysisSave = '_turnoveranalysis.txt';

for fileNum = filenumbers
    filepathpxs = strFilepath2(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath2(fileNum,filenameallMito,masterFolderPath);
    filepathMitoBinary = strFilepath2(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath2(fileNum,filenameSomaBinary,masterFolderPath);
    filepathNeuritesbinary = strFilepath2(fileNum,filenameNeuritesbinary,masterFolderPath);
    filepathLabel1 = strFilepath2(fileNum,filenameLabel1,masterFolderPath);
    filepathLabel2 = strFilepath2(fileNum,filenameLabel2,masterFolderPath);
    filepathAxonDistInfo = strFilepath2(fileNum,filenameAxonDistInfo,masterFolderPath);
    
    filepathAnaSave = strFilepath2(fileNum,filenameAnalysisSave,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',1,1);
        [~,params] = size(datamito);
        
        % Read the pixel size (in nm)
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        % Load binary mitochondria image 
        imagemitobinary = imread(filepathMitoBinary);
        imsize = size(imagemitobinary);
        
        % Load label 1 image 
        imagelabel1 = imread(filepathLabel1);
        
        % Load label 2 image 
        imagelabel2 = imread(filepathLabel2);
        
        % Remove small objects and make labelled binary mitochondria image
        %imagemitobinary = bwareaopen(imagemitobinary, threshsize);
        [labelmito, num] = bwlabel(imagemitobinary');
        labelmito = labelmito';
        
        % Mark those mitochondria that are in "soma" areas
        try
            imagesomabinary = imread(filepathSomaBinary);
            imagesomabinary = logical(imagesomabinary);
        catch err
            imagesomabinary = zeros(size(imagemitobinary));
            imagesomabinary = logical(imagesomabinary);
        end
        for i = 1:num
            xpos = datamito(i,1);
            xpos = round(xpos/pixelsize);
            ypos = datamito(i,2);
            ypos = round(ypos/pixelsize);
            % Make sure all coordinates are in the range of the img size
            xpos = min(max(xpos,1),imsize(2));
            ypos = min(max(ypos,1),imsize(1));
            datamito(i,params+1) = imagesomabinary(ypos,xpos);
        end

        % Get the distance from the soma along the axon to the mitochondria
        % Create .txt file that carries information about the
        % seed point for the bwdistgeodesic transformation, and the
        % previous distance along the axon.
        % Read the axon distance info
        datadistinfo = dlmread(filepathAxonDistInfo,'',1,1);
        seedx = datadistinfo(1); seedy = datadistinfo(2); prevdist = datadistinfo(3);
        % Read the binary AIS-image (axon image)
        imageneuritesbin = imread(filepathNeuritesbinary);
        imageneuritesbin = logical(imageneuritesbin);
        aisdist = bwdistgeodesic(imageneuritesbin, seedx, seedy, 'quasi-euclidean') + prevdist;
        for i = 1:num
            xpos = datamito(i,1);
            xpos = round(xpos/pixelsize);
            ypos = datamito(i,2);
            ypos = round(ypos/pixelsize);
            % Make sure all coordinates are in the range of the img size
            xpos = min(max(xpos,1),imsize(2));
            ypos = min(max(ypos,1),imsize(1));
            datamito(i,params+2) = aisdist(ypos,xpos) * pixelsize;
        end
        % Round the distances to three decimals
        datamito(:,params+2) = round(datamito(:,params+2),2);
        
        % Get total label 1 and label 2 signal in each mito and save to mitoinfo
        imj_circ_corr = 0.8;
        for i = 1:num
            singlemitobinary = ismember(labelmito, i);
            mitocirc = regionprops(singlemitobinary,{'Circularity'});
            singlemitolabel1 = imagelabel1(singlemitobinary);
            singlemitolabel2 = imagelabel2(singlemitobinary);
            datamito(i,params+3) = sum(singlemitolabel1);  % Total label 1 signal
            datamito(i,params+4) = sum(singlemitolabel2);  % Total label 2 signal
            datamito(i,params+5) = mitocirc.Circularity * imj_circ_corr;  % Mito circularity, with a correction factor to be similar to the ImageJ circularity
        end

        % Save data
        disp(strcat(num2str(fileNum),': Done.'))
        writematrix(datamito,filepathAnaSave,'Delimiter','tab')
    catch err
        fprintf(1,'Line of error:\n%i\n',err.stack(end).line);
        fprintf(1,'The identifier was:\n%s\n',err.identifier);
        fprintf(1,'There was an error! The message was:\n%s\n',err.message);
    end 
    
end