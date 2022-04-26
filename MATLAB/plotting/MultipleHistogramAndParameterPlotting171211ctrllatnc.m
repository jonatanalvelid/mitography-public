%%% MULTIPLE HISTOGRAM PLOTTING
colors = lines(3);
x=0:0.001:1;

h1var = mitolengthcontrol./mitowidthcontrol;
h2var = mitolengthlat./mitowidthlat;
h3var = mitolengthnc./mitowidthnc;
s1var = mitolengthcontrol;
s2var = mitowidthcontrol;
s3var = mitolengthlat;
s4var = mitowidthlat;
s5var = mitolengthnc;
s6var = mitowidthnc;

boundlow1 = 0.5;
stepwidth1 = 0.5;
boundup1 = 19.5;
xlimlow1 = 0;
xlimlowlog1 = 0.1;
xlimup1 = 15;
ylimup1 = 0.3;

boundlow2 = 0;
boundlowlog2 = 0.05;
boundup2 = 0.5;
xlimlow2 = boundlow2;
xlimlowlog2 = boundlowlog2;
xlimup2 = boundup2;
ylimup2 = 4;

fontsize = 16;

legendtext1 = 'Control';
legendtext2 = 'Nocodazole';
legendtext3 = 'Latrunculin';

titletext1 = 'Mitochondria width';
titletext2 = 'Mitochondria length/width';
titletext3 = 'Mitochondria length';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria length/width [arb.u.]';
xlabeltext3 = 'Mitochondria length [µm]';

fits2 = s2var\s1var;
fits4 = s4var\s3var;
fits6 = s6var\s5var;
yfits2 = fits2*x;
yfits4 = fits4*x;
yfits6 = fits6*x;

figure('rend','painters','pos',[100 100 1200 1200]);
%subplot(1,2,2)
s1 = scatter(s2var,s1var,20,'filled');
hold on
s2 = scatter(s6var,s5var,20,'filled');
s3 = scatter(s4var,s3var,20,'filled');
fit1 = plot(x,yfits2,'Color',colors(1,:),'LineStyle','--','LineWidth',1);
fit2 = plot(x,yfits6,'Color',colors(2,:),'LineStyle','--','LineWidth',1);
fit3 = plot(x,yfits4,'Color',colors(3,:),'LineStyle','--','LineWidth',1);
set(gca,'XScale','log','YScale','log')
xlim([xlimlowlog2 xlimup2])
ylim([0.2 ylimup2])
%title(strcat('N=',num2str(length(s1var))));
legend(legendtext1,legendtext2,legendtext3,'Control, linear fit','Nocodazole, linear fit','Latrunculin, linear fit');
xlabel(xlabeltext1)
ylabel(xlabeltext3)
set(gca,'FontSize',fontsize)

% subplot(1,2,1)
% h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceAlpha',0.3,'Normalization','probability');
% hold on
% h2 = histogram(h3var,boundlow1:stepwidth1:boundup1,'FaceAlpha',0.3,'Normalization','probability');
% h3 = histogram(h2var,boundlow1:stepwidth1:boundup1,'FaceAlpha',0.3,'Normalization','probability');
% xlim([xlimlow1 xlimup1])
% xlabel(xlabeltext2)
% ylim([0 ylimup1])
% ylabel('Norm. frequency')
% title(strcat('N=',num2str(length(h1var))));
% legend(legendtext1,legendtext2,legendtext3);
% set(gca,'FontSize',fontsize)

%ScatterHist
widthdata = [s2var;s6var;s4var];
lengthdata = [s1var;s5var;s3var];
widthlabels = cell(length(s2var)+length(s6var)+length(s4var),1);
widthlabels(1:length(s2var)) = {'Control'};
widthlabels(length(s2var):length(s2var)+length(s6var)) = {'Nocodazole'};
widthlabels(length(s2var)+length(s6var):end) = {'Latrunculin'};
figure('rend','painters','pos',[100 100 1200 1200]);
sh1 = scatterhist(widthdata,lengthdata,'Group',widthlabels,'Kernel','on','Marker','...','MarkerSize',12,'LineStyle',{'-','-','-'},'LineWidth',[2,2,2]);
%fit1 = plot(x,yfits2,'Color',colors(1,:),'LineStyle','--');
%fit2 = plot(x,yfits6,'Color',colors(2,:),'LineStyle','--');
%fit3 = plot(x,yfits4,'Color',colors(3,:),'LineStyle','--');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext1)
ylim([0 ylimup2])
ylabel(xlabeltext3)
set(gca,'FontSize',fontsize)