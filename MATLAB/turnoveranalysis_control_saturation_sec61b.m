%%%
% Mitography - Turnover analysis
% Analysis the bleedthrough ratio of TMR and SiR (lower limit of
% measurements) in single dye labelled samples
%----------------------------
% Version: 201109
% Last updated features: First version
%
% @jonatanalvelid
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('T:\Mitography'),'\');
%fileList = dir(fullfile(masterFolderPath,'*_vb.tif'));
fileList = dir(fullfile(masterFolderPath,'*_tmr.tif'));
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(1:3));
end
%lastFileNumber = max(filenumbers);

threshsize = 8;  % Lower threshold size in pixels for binary mitochondria

filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenameMitoBinary = '_mitobinary.tif';
filenameSomaBinary = '_somabinary.tif';
filenameTMR = '_tmr.tif';
filenameSiR = '_sir.tif';

filenameAnalysisSave = '_turnoveranalysis.txt';

%fileNumbers = 1:lastFileNumber;

for fileNum = filenumbers
    filepathpxs = strFilepath2(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath2(fileNum,filenameallMito,masterFolderPath);
    filepathMitoBinary = strFilepath2(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath2(fileNum,filenameSomaBinary,masterFolderPath);
    filepathSiR = strFilepath2(fileNum,filenameSiR,masterFolderPath);
    filepathTMR = strFilepath2(fileNum,filenameTMR,masterFolderPath);
    
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
        
        % Load tmr image 
        imagetmr = imread(filepathTMR);
        
        % Load sir image 
        imagesir = imread(filepathSiR);
        
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
            %disp(xpos), disp(ypos)
            datamito(i,params+1) = imagesomabinary(ypos,xpos);
        end
        
        % Get total tmr and sir signal in each mito and save to mitoinfo
        imj_circ_corr = 0.8;
        for i = 1:num
            singlemitobinary = ismember(labelmito, i);
            mitocirc = regionprops(singlemitobinary,{'Circularity'});
            singlemitotmr = imagetmr(singlemitobinary);
            singlemitosir = imagesir(singlemitobinary);
            datamito(i,params+3) = sum(singlemitotmr);  % Total TMR signal
            datamito(i,params+4) = sum(singlemitosir);  % Total SiR signal
            datamito(i,params+5) = mitocirc.Circularity * imj_circ_corr;  % Mito circularity, with a correction factor to be similar to the ImageJ circularity
        end

        % Save data
        disp(strcat(num2str(fileNum),': Done.'))
%         dlmwrite(filepathAnaSave,datamito,'delimiter','\t');
        writematrix(datamito,filepathAnaSave,'Delimiter','tab')
    catch err
        fprintf(1,'Line of error:\n%i\n',err.stack(end).line);
        fprintf(1,'The identifier was:\n%s\n',err.identifier);
        fprintf(1,'There was an error! The message was:\n%s\n',err.message);
    end 
    
end