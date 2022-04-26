% Compares two binary images and returns the size of the overlapping area
% in the units given as input through the pixel size pxs. 
function [areaoverlap] = overlappingArea(image1,image2,pxs)
    overlapimage = image1 .* image2;
    areaoverlap = sum(sum(overlapimage))*pxs*pxs;
end