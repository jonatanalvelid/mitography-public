%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200317
% New script to handle TMR data, with TMR binary maps, with a boolean
% output variable saying if the mitochondria has TMR or not, and the
% average TMR signal inside the mitochondria.
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\NEW\Metabolism\Control\OMP25'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);
try
    dataparam = readtable(filepathparam);
    mitoLineProfLength = dataparam.MitoLineProfLen;
    actinLineProfLength = dataparam.ActLineProfLen;
catch err
    mitoLineProfLength = input('What is the mitochondria line profile length (um)? ');
    actinLineProfLength = input('What is the actin line profile length (um)? ');
end

lastFileNumber = input('What is the number of the last image? ');
dendFiles = input('Are there AIS-files? (1=yes) ');
mitosPerFile = 1000;
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
actinSingleGaussTol = 0.96;
actinDoubleGaussTol = 0.96;
actinGaussMinDistance = 0.100;
gaussianFitting = 1;

filenameall = '_MitoLineProfiles.txt';
filenameupper = '_MitoUpperLineProfiles.txt';
filenamebottom = '_MitoBottomLineProfiles.txt';
filenameallNo = '_StripesNonStripesMitoNo.txt';
filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenameallMask = '_NonStripesMask.tif';
filenamePatchesBinary = '_PatchesBinaryAlternative.tif';
% filenameallDend = '_DendritesBinary.tif';
filenameallDend = '-AISBinary.tif';  % Use this if you named the files differently
fileNumbers = 1:lastFileNumber;
% fileNumbers = 1;

%% 
%%% COMBINE THE MITO AND ACTIN FILES, TO SAVE THE LOCAL ACTIN WIDTH WITH
%%% EVERY MITOCHONDRIA DIRECTLY, IN THE SAME FILE, INSTEAD OF READING FROM
%%% ALL THREE FILES AT THE SAME TIME LATER AT THE TIME OF PLOTTING.

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoStripes = '_MitoStripes.txt';
% filenameMitoNonStripes = '_MitoNonStr.txt';
filenameStripes = '_ActinStripes.txt';
filenameNonStripes = '_ActinNonStripes.txt';
filenameStripesUpper = '_ActinStripesUpper.txt';
filenameNonStripesUpper = '_ActinNonStripesUpper.txt';
filenameStripesBottom = '_ActinStripesBottom.txt';
filenameNonStripesBottom = '_ActinNonStripesBottom.txt';
filenameMitoNumStr = '_StripesNonStripesMitoNo.txt';
filenameMitoNumDend = '_MitoInDend.txt';
filenameWidths = '_MitoWidths.txt';
filenameUpperWidths = '_MitoUpperWidths.txt';
filenameBottomWidths = '_MitoBottomWidths.txt';
filenameAllFitsWidths = '_MitoAllFitsWidths.txt';
filenameAllFitsUpperWidths = '_MitoAllFitsUpperWidths.txt';
filenameAllFitsBottomWidths = '_MitoAllFitsBottomWidths.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenamePatchesBinary = '_PatchesBinaryAlternative.tif';
filenameNeuronBinary = '_NeuronBinary.tif';
filenameSomaBinary = '_SomaBinary.tif';
filenameAISBinary = '-AISBinary.tif';
filenameMito = '_OnlyMitoImage.tif';

for fileNum = fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathWid = strFilepath(fileNum,filenameWidths,masterFolderPath);
    filepathUpperWid = strFilepath(fileNum,filenameUpperWidths,masterFolderPath);
    filepathBottomWid = strFilepath(fileNum,filenameBottomWidths,masterFolderPath);
    filepathMitoStr = strFilepath(fileNum,filenameMitoStripes,masterFolderPath);
    % filepathMitoNonStr = strFilepath(fileNum,filenameMitoNonStripes,masterFolderPath);
    filepathStr = strFilepath(fileNum,filenameStripes,masterFolderPath);
    filepathNonStr = strFilepath(fileNum,filenameNonStripes,masterFolderPath);
    filepathStrUpper = strFilepath(fileNum,filenameStripesUpper,masterFolderPath);
    filepathNonStrUpper = strFilepath(fileNum,filenameNonStripesUpper,masterFolderPath);
    filepathStrBottom = strFilepath(fileNum,filenameStripesBottom,masterFolderPath);
    filepathNonStrBottom = strFilepath(fileNum,filenameNonStripesBottom,masterFolderPath);
    filepathMitoStrNum = strFilepath(fileNum,filenameMitoNumStr,masterFolderPath);
    filepathMitoNoDend = strFilepath(fileNum,filenameMitoNumDend,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathMito = strFilepath(fileNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathPatchesBinary = strFilepath(fileNum,filenamePatchesBinary,masterFolderPath);
    filepathNeuronBinary = strFilepath(fileNum,filenameNeuronBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
    filepathAllFitsWid = strFilepath(fileNum,filenameAllFitsWidths,masterFolderPath);
    filepathAllFitsUpperWid = strFilepath(fileNum,filenameAllFitsUpperWidths,masterFolderPath);
    filepathAllFitsBottomWid = strFilepath(fileNum,filenameAllFitsBottomWidths,masterFolderPath);
    
    try
        dataMitoStr = dlmread(filepathMitoStr,'',1,1);
    catch err
        disp(strcat(num2str(fileNum),': No stripes mitochondria'))
        dataMitoStr = [];
    end
    
    try
        try
            dataAnalysis = dlmread(filepathAnaSave);
            sizeData = size(dataAnalysis);
        catch err
            disp(strcat(num2str(fileNum),': File reading error.'));
        end
        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);

        %%% MITOCHONDRIA TMRE CHECK AND FLAGGING & OMP25 SIGNAL CHECK
        % Load TMRE image
        imageomp = imread(filepathMito);
        % Load binary mitochondria image 
        imagemitobinary = imread(filepathMitoBinary);
        % Remove small objects and make labelled binary mitochondria image
        % flip axes of imagemitobinary so numbering matches previous
        % numbering in imageJ, i.e. in mitoAnalysis.text file
        imjbinsizelim = 0.006;  % binary object size limit in ImageJ (OMP = 0.006 um^2)
        imagemitobinary = bwareaopen(imagemitobinary,round(imjbinsizelim/pixelsize^2));
        [labelmito, num] = bwlabel(imagemitobinary');
        % flip axes back
        labelmito = labelmito';
        
        %{
        % mark all mitochondria that are touching the border
        imagemitobin = imbinarize(labelmito);
        bordermitoimg = imagemitobin - imclearborder(imagemitobin);
        labelbordermitoimg = labelmito .* bordermitoimg;
        bordermito = unique(labelbordermitoimg);
        bordermito(1) = [];  % remove 0 entry
        for i = bordermito
            dataAnalysis(i,110) = 1;
        end
%}
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlemitobinary = ismember(labelmito, i);
                % get a list of tmr pixels in this area
                ompsignal = imageomp(singlemitobinary);
                % get average TMRE signal/pixel per mito, save to data (110)
                ompsignalavg = mean(ompsignal);
                dataAnalysis(i,115) = ompsignalavg;
%                 else
%                     dataAnalysis(i,111) = nan;
%                 end
            end
        end
        
        
        disp(strcat(num2str(fileNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end
end