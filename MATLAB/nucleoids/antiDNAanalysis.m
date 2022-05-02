%%%
% Mitography - anitDNA analysis
% Analysing number of nucleoids in mitochondria, based on DNA and
% Tom20-staining.
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
% data folder
masterFolderPath = fullfile(datafolder,'nucleoids','dna','matlab\');
%%%

fileList = dir(fullfile(masterFolderPath, 'Image_*.txt'));
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(7:9));
end
lastFileNumber = max(filenumbers);

filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenamenucleoids = '_Nucleoids.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '-MitoBinary.tif';
filenameAISBinary = '_Map2Binary.tif';
fileNumbers = 1:lastFileNumber;

for fileNum = fileNumbers
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath(fileNum,filenameallMito,masterFolderPath);
    filepathnucleoids = strFilepath(fileNum,filenamenucleoids,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',1,1);
        datanucleoids = dlmread(filepathnucleoids,'',1,1);
        [~,params] = size(datamito);
        
        % Read the pixel size (in nm)
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1)/1000;
        
        % Load binary mitochondria image 
        imagemitobinaryraw = imread(filepathMitoBinary);
        imsize = size(imagemitobinaryraw);
        
        % Load binary Map2 image 
        imagemap2binary = imread(filepathAISBinary);
        imagemap2binary = imagemap2binary/max(max(imagemap2binary));
        
        % Make binary nucleoid center map 
        nucleoidmap = zeros(size(imagemitobinaryraw));
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
        
        % Remove small objects and objects on border and make labelled binary mitochondria image
        threshsizelo = (sqrt(0.08)/pixelsize)^2;  % Lo size thresh in pxls for bin mito
        threshsizehi = (sqrt(4)/pixelsize)^2;  % Hi size thresh in pxls for bin mito
        imagemitobinary = imclearborder(imagemitobinaryraw);  % Remove border objects
        imagemitobinary = bwareafilt(imbinarize(imagemitobinary), [threshsizelo threshsizehi]);
        [labelmito, num] = bwlabel(imagemitobinary');
        labelmito = labelmito';
        
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
        writematrix(datamito,filepathAnaSave,'Delimiter','tab')
    catch err
        disp(strcat(num2str(fileNum),': General error.'));
    end 
    
end