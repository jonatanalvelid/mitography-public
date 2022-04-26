%%% Check the distance to the nearest actin patch
function [distance] = distNearestActinPatch(xcoord,ycoord,pixelsize,imgActinDist)
    % ycoord in a normal image means the row number in MATLAB, i.e. the
    % first coordinate of a matrix. Thus x and y are flipped.
    distance = imgActinDist(round(ycoord/pixelsize),round(xcoord/pixelsize));
end