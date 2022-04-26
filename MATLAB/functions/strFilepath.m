%%% Returns a proper filename from the input values
function [filename2] = strFilepath(filenumber,filenameEnding,filepath)
    if filenumber < 10
        filename2 = strcat(filepath,'Image_00',int2str(filenumber),filenameEnding);
    else
        filename2 = strcat(filepath,'Image_0',int2str(filenumber),filenameEnding);
    end
end