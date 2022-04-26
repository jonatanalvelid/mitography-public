%%% Returns a proper filename from the input values
function [filename] = strFilepath(filenumber,filenameEnding,filepath)
    filename = strcat(filepath,sprintf('%03d',filenumber),filenameEnding);
end