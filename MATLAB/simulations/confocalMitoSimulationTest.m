% Simulating the difference between confocal and STED images of
% mitochondria line profiles through convolution

fontsize = 12;

xBeam = -2:0.0001:2;
xScan = -4:0.0001:4;
mitosize = 0.14;
confwid = 0.3;
STEDwid = 0.05;
intermitodist = 0.03;

yBeamConf = gaussmf(xBeam,[confwid/2.355 0]);
yBeamSTED = gaussmf(xBeam,[STEDwid/2.355 0]);
yBeamConfShow = gaussmf(xBeam,[confwid/2.355 -1]);
yBeamSTEDShow = gaussmf(xBeam,[STEDwid/2.355 -1]);
yMitoMemb = gaussmf(xBeam,[0.01/2.355 -mitosize/2])+gaussmf(xBeam,[0.01/2.355 mitosize/2]);
yMitoBack = 0.3*(gaussmf(xBeam,[0.1/2.355 -mitosize/4])+gaussmf(xBeam,[0.1/2.355 mitosize/4]));
yMito = yMitoMemb;
yMito2 = gaussmf(xBeam,[0.01/2.355 -mitosize/2])+gaussmf(xBeam,[0.01/2.355 mitosize/2])+gaussmf(xBeam,[0.01/2.355 mitosize/2+intermitodist])+gaussmf(xBeam,[0.01/2.355 3*mitosize/2+intermitodist]);
mitoSignal = yMito/max(yMito);
yConf = conv(yBeamConf,mitoSignal);
yConf = yConf/max(yConf);
ySTED= conv(yBeamSTED,mitoSignal);
ySTED = ySTED/max(ySTED);

confFWHM = fwhm(xScan,yConf);

f = figure('rend','painters','pos',[100 100 700 400]);
plot(xBeam,yBeamConfShow,'LineWidth',2)
hold on
plot(xBeam,yBeamSTEDShow,'LineWidth',2)
plot(xBeam,mitoSignal,'LineWidth',2)
plot(xScan,yConf,'LineWidth',2)
plot(xScan,ySTED,'LineWidth',2)
xlim([-1.5 1.2])
xlabel('x [µm]')
ylabel('Norm. frequency')
legend('Confocal PSF','STED PSF',strcat('Mitochondria, W=',int2str(floor(mitosize*1000)),'nm'),strcat('Confocal, W=',int2str(floor(confFWHM*1000)),'nm'),strcat('STED, W=',int2str(floor(mitosize*1000)),'nm'),'Location','northeast')
set(gca,'FontSize',fontsize)