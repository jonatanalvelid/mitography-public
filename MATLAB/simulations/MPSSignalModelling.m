PSFxy = 0.040;
PSFz = 0.100;
PSFGauxy = 0.230;
PSFGauz = 0.600;
pxs = 0.005;
imgsize = 0.75;
ringdiameter = 0.300;
dotdist = 0.01;
angleamountmissing = 30;
MPSmissing = 1;

ringradius = ringdiameter/2;
ndots = round(pi*ringdiameter/dotdist);
angledotdist = 2*pi/ndots;
angleamountmissingrad = 2*pi*angleamountmissing/360;
len = imgsize/pxs;
xall = 1:len;
zall = 1:len;
xall = xall.*pxs;
zall = zall.*pxs;

PSFGau2D = zeros(round(imgsize/pxs),round(imgsize/pxs));
PSFLor3D = zeros(round(imgsize/pxs),round(imgsize/pxs));
PSFLor2D = zeros(round(imgsize/pxs),round(imgsize/pxs));
xc = imgsize/pxs/2;
zc = imgsize/pxs/2;

for i=1:imgsize/pxs
    for j=1:imgsize/pxs
        PSFLor3D(i,j) = 1 / ((j-xc)^2/(PSFxy/pxs/2)^2 + (i-zc)^2/(PSFz/pxs/2)^2 + 1);
        PSFLor2D(i,j) = 1 / ((j-xc)^2/(PSFxy/pxs/2)^2 + (i-zc)^2/(PSFGauz/pxs/2)^2 + 1);
        PSFGau2D(i,j) = exp(-((j-xc)^2/(2*(PSFGauxy/pxs/2.35482)^2)+(i-zc)^2/(2*(PSFGauz/pxs/2.35482)^2)));
    end
end

PSFLor3D = PSFLor3D./max(max(PSFLor3D));
PSFLor2D = PSFLor2D./max(max(PSFLor2D));
PSFGau2D = PSFGau2D./max(max(PSFGau2D));

% MPS model - Complete ring
imgMPScomplete = zeros(round(imgsize/pxs),round(imgsize/pxs));
sizeim = size(imgMPScomplete);
for i=1:ndots
    angle = angledotdist*i;
    x = sizeim(1)/2 + round(ringradius*cos(angle)/pxs);
    y = sizeim(1)/2 + round(ringradius*sin(angle)/pxs);
    imgMPScomplete(round(x),round(y)) = 1;
end

% MPS model - Top/bottom missing ring
imgMPSmissing = zeros(round(imgsize/pxs),round(imgsize/pxs));
sizeim = size(imgMPSmissing);
for i=1:ndots
    angle = angledotdist*i;
    x = sizeim(1)/2 + round(ringradius*cos(angle)/pxs);
    y = sizeim(1)/2 + round(ringradius*sin(angle)/pxs);
    if angle < (pi/2 - angleamountmissingrad/2) || angle > (3*pi/2 + angleamountmissingrad/2) || (angle > (pi/2 + angleamountmissingrad/2) && angle < (3*pi/2 - angleamountmissingrad/2))
        imgMPSmissing(round(y),round(x)) = 1;
    end
end

if MPSmissing
    imgMPS = imgMPSmissing;
else
    imgMPS = imgMPScomplete;
end


% Lorentzian 3DSTED image
fluoimglor3D = zeros(round(imgsize/pxs),round(imgsize/pxs));
for i=1:sizeim(1)
    for j=1:sizeim(1)
        imgPSFshiftlor3D = circshift(PSFLor3D,[i-round(sizeim(1)/2),j-round(sizeim(1)/2)]);
        signalimglor3D = imgMPS.*imgPSFshiftlor3D;
        pxsignallor3D = sum(sum(signalimglor3D));
        fluoimglor3D(i,j)=pxsignallor3D;
    end
end
fluoimglor3D = fluoimglor3D./max(max(fluoimglor3D));

% Lorentzian 2DSTED image
fluoimglor2D = zeros(round(imgsize/pxs),round(imgsize/pxs));
for i=1:sizeim(1)
    for j=1:sizeim(1)
        imgPSFshiftlor2D = circshift(PSFLor2D,[i-round(sizeim(1)/2),j-round(sizeim(1)/2)]);
        signalimglor2D = imgMPS.*imgPSFshiftlor2D;
        pxsignallor2D = sum(sum(signalimglor2D));
        fluoimglor2D(i,j)=pxsignallor2D;
    end
end
fluoimglor2D = fluoimglor2D./max(max(fluoimglor2D));

% Confocal image
fluoimggau = zeros(round(imgsize/pxs),round(imgsize/pxs));
for i=1:sizeim(1)
    for j=1:sizeim(1)
       imgPSFshiftgau = circshift(PSFGau2D,[i-round(sizeim(1)/2),j-round(sizeim(1)/2)]);
       signalimggau = imgMPS.*imgPSFshiftgau;
       pxsignalgau = sum(sum(signalimggau));
       fluoimggau(i,j)=pxsignalgau;
    end
end
fluoimggau = fluoimggau./max(max(fluoimggau));

% Plotting - complete ring
figure('rend','painters','pos',[300 100 1800 1200])
subplot(2,4,1)
imshow(imgMPS)
subplot(2,4,2)
imshow(PSFLor3D,'colormap',hot)
colorbar
subplot(2,4,3)
imshow(PSFLor2D,'colormap',hot)
colorbar
subplot(2,4,4)
imshow(PSFGau2D,'colormap',hot)
colorbar
subplot(2,4,6)
imshow(fluoimglor3D,'colormap',hot)
colorbar
subplot(2,4,7)
imshow(fluoimglor2D,'colormap',hot)
colorbar
subplot(2,4,8)
imshow(fluoimggau,'colormap',hot)
colorbar



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % Binary Gaussian PSF
% imgPSF = zeros(round(imgsize/pxs),round(imgsize/pxs));
% sizeimp = size(imgPSF);
% [columnsInImage,rowsInImage] = meshgrid(1:imgsize/pxs, 1:imgsize/pxs);
% imgPSF = (rowsInImage-sizeimp(1)/2).^2 ./ (PSFz/2/pxs)^2 ...
%     + (columnsInImage-sizeimp(1)/2).^2 ./ (PSFxy/2/pxs)^2 <= 1;
% 
% imgPSFshift = circshift(imgPSF,[100,100]);
% 
% fluoimg = zeros(round(imgsize/pxs),round(imgsize/pxs));
% 
% for i=1:sizeim(1)
%     for j=1:sizeim(1)
%         imgPSFshift = circshift(imgPSF,[i-round(sizeim(1)/2),j-round(sizeim(1)/2)]);
%         signalimg = imgMPS.*imgPSFshift;
%         pxsignal = sum(sum(signalimg));
%         fluoimg(i,j)=pxsignal;
%     end
% end
% 
% fluoimg = fluoimg./max(max(fluoimg));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
