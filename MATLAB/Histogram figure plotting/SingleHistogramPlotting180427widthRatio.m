%%% MULTIPLE HISTOGRAM PLOTTING
colormap(lines);
colors = lines(5);
color = colors(5,:);

locs = find(mitowidthsted>1);
mitowidthsted(locs)=[];
mitolengthsted(locs)=[];
mitoareasted(locs)=[];

h1var = mitowidthratio;

boundlow1 = 0;
stepwidth1 = 0.05;
boundup1 = 3;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.15;

fontsize = 12;
opacity = 0.5;

xlabeltext1 = 'Width ratio, W_o/W_m [µm]';

%%%,'FaceAlpha',opacity %%% If you want different opacity

mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceColor',color,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
%legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
