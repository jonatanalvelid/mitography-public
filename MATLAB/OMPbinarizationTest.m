%%%
% Binarization test of OXPHOS OMP-data
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

% folderPath = uigetdir('X:\Mitography\OXPHOS-MitographyAnalysis\RL data');
masterFolderPath = 'X:\Mitography\OXPHOS-MitographyAnalysis\RL data\';
% masterFolderPath = strcat(folderPath,'\');

pixelsize = 30/1000;  % Pixel size in µm

filenamemito = '-Mitochondria.tif';
fileNumbers = 1:1;
    
for fileNum = fileNumbers
    filepathmito = strFilepath(fileNum, filenamemito, masterFolderPath);
    
    try
        % Read the image
        imgrawmito = imread(filepathmito);
        imsize = size(imgrawmito);
        
        
    catch err
        disp(strcat(num2str(fileNum),': No image with this number, or some other error.'));
        continue
    end
    %{
    % Smooth the STED image
    imgmito = filter2(fspecial('average',1),imgrawmito);  % This equals ImageJ's "Smooth"
    
    % Binarize mitochondria images
    % Find the top x% of pixel, to get a threshold value for binarization.
    imgsort = sort(imgmito(:),'descend');
    thresh_val = imgsort(ceil(length(imgsort)*0.08));
    % Binarize smoothed vesimage
    imgbinmito0 = imbinarize(imgmito,thresh_val);
    
    % Do a series of erosion and dilation of the binary image
    ermat = [0 1 0;1 1 1;0 1 0];
    dilmat = [0 0 0 0 0 0 0;0 0 1 1 1 0 0;0 1 1 1 1 1 0;0 1 1 1 1 1 0;0 1 1 1 1 1 0;0 0 1 1 1 0 0;0 0 0 0 0 0 0];
    % Specify erosion/dilation sequence. Erosion = 1, Dilation = 0, Remove
    % small and large objects = 2
    erdilorder = [1;0];
    for n = 1:length(erdilorder)
        if erdilorder(n) == 1
            imgbinmito0 = imerode(imgbinmito0,ermat);
        elseif erdilorder(n) == 0
            imgbinmito0 = imdilate(imgbinmito0,dilmat);
        elseif erdilorder(n) == 2
            imgbinmito0 = bwareafilt(imgbinmito0, [10,10000]);
        end
    end
    % Multiply the created binary mask with the original image
    imgmito2 = imgmito .* imgbinmito0;
    % Smooth the mito img
    for n = 1:1
        imgmito2 = filter2(fspecial('average',2),imgmito2);
    end
    %}
    
    % Smooth the STED image
    imgmito = filter2(fspecial('gaussian',2),imgrawmito);  % This equals ImageJ's "Smooth"
    
    radius = 13;
    contrast = 7;
    imgmask = bernsen(imgmito,[radius*2+1 radius*2+1],contrast);
    
        % Do a series of erosion and dilation of the binary image
    ermat = [0 1 0;1 1 1;0 1 0];
    dilmat = [0 0 0 0 0 0 0;0 0 1 1 1 0 0;0 1 1 1 1 1 0;0 1 1 1 1 1 0;0 1 1 1 1 1 0;0 0 1 1 1 0 0;0 0 0 0 0 0 0];
    % Specify erosion/dilation sequence. Erosion = 1, Dilation = 0, Remove
    % small and large objects = 2
    erdilorder = [1;1;1;0;1;0;1];
    for n = 1:length(erdilorder)
        if erdilorder(n) == 1
            imgmask = imerode(imgmask,ermat);
        elseif erdilorder(n) == 0
            imgmask = imdilate(imgmask,dilmat);
        elseif erdilorder(n) == 2
            imgmask = bwareafilt(imgmask, [10,10000]);
        end
    end
    
    imgmito2 = imgmito .* imgmask;
    
    radius = 6;
    contrast = 5;
    imgmitobin = bernsen(imgmito2,[radius*2+1 radius*2+1],contrast);
    
    imtool(imgmask)
    imtool(imgmitobin)
%     imtool(imgmito)

end
