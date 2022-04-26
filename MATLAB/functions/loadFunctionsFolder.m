% load functions folder from matlab file in a subfolder
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
parentfolder = fullfile(parentfolder{1},'functions');
addpath(parentfolder)