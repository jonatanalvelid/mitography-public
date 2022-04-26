%%% Check if mitochondria is in the AIS
function [aisYesNo] = mitoAIS(xcoord,ycoord,pixelsize,imgAIS)
    % ycoord in a normal image means the row number in MATLAB, i.e. the
    % first coordinate of a matrix. Thus x and y are flipped.
    [ysize, xsize] = size(imgAIS);
    ypos = min(ysize, round(ycoord/pixelsize));
    xpos = min(xsize, round(xcoord/pixelsize));
    if ypos < 1
        ypos = 1;
    end
    if xpos < 1
        xpos = 1;
    end
    aisYesNo = imgAIS(ypos,xpos);
end