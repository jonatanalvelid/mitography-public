function deconimg = rldeconv(imguint8_255, fwhmpsfnm, px_sizenm)
sigmanm = fwhmpsfnm/2.355;
sigma_psf_px = sigmanm/px_sizenm;

% % MitoSOX data
% niter = 10;
% dampar = 1;
% % TMRE data
% niter = 10;
% dampar = 0.01;
% % OXPHOS data
% niter = 15;
% dampar = 1;
% TMRE data new
niter = 10;
dampar = 1;

img = im2double(imguint8_255)*255;
psf = gauss2d(img, sigma_psf_px);

% imsize = size(img);
% psfsmall = gauss2d(zeros(round(imsize(1)/4)),sigma_psf_px*100);
% img = edgetaper(img, psfsmall);

deconimg = deconvlucy(img, psf, niter, dampar);
end

function retpsf = gauss2d(mat, sigma)
retpsf = fspecial('gaussian', size(mat), sigma);
end