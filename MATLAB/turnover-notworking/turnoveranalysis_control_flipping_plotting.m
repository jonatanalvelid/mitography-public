%%%
% Mitography - Turnover analysis - control - flipping - data plotting
% Plotting the data from the turnover analysis control experiments.
%----------------------------
% Version: 201110
% Last updated features: Move means/std groupings calculations to do it on
% a cell-to-cell basis, can always get the total mean and std from that
% anyway
%
% @jonatanalvelid
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));
masterFolderPath = strcat(uigetdir('E:\PhD\Data analysis\temp_analysis_turnover\controls\flipping\Dye1 SiR Dye2 (24hlater) TMR\combined\analysis'),'\');
fileList = dir(fullfile(masterFolderPath, '*turnoveranalysis.txt'));
filenumbers = [];
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(1:3));
end

mitodatatemp = [];
somadist = [];
tmrsign = [];
sirsign = [];
signratio = [];
area = [];
circ = [];
colors = [];
colors_lines = lines(max(filenumbers));
filenameallMito = '_turnoveranalysis.txt';

%%% mean ratios for different distances
maxdist = 100;   % CHANGE DEPENDING ON DATASET
groupingdist = 10;
means = [];
stds = [];
bin_n = [];

%{
areathlo = 0.03;
areathhi = 0.2;
circth = 0.8;
%}
%%{
areathlo = 0.01;
areathhi = 100;
circth = 0;
somadistth = 300;
%}

%%% GATHER DATA

for fileNum = filenumbers
    filepathmito = strFilepath2(fileNum,filenameallMito,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',0,0);
        [num,params] = size(datamito);
        
        % Get somadist and number of nucleotides for all mito in image
        somabooltemp = datamito(:,params-4);
        somadisttemp = datamito(:,params-3);
        tmrsignaltemp = datamito(:,params-2);
        sirsignaltemp = datamito(:,params-1);
        %signratiotemp = sirsignaltemp./tmrsignaltemp;
        areatemp = datamito(:,4);
        circtemp = datamito(:,params);
        
        %% Add somadist = 0 if somabool = 1
        %somadisttemp(somabooltemp==1) = 0;
        
        % Remove all somadist=0 and somabool=0 mitos
        idxrem = (somadisttemp==0 & somabooltemp==0);
        somadisttemp(idxrem) = [];
        %signratiotemp(idxrem) = [];
        tmrsignaltemp(idxrem) = [];
        sirsignaltemp(idxrem) = [];
        areatemp(idxrem) = [];
        circtemp(idxrem) = [];

    catch err
        %fprintf(1,'Line of error:\n%i\n',err.stack(end).line);
        %fprintf(1,'The identifier was:\n%s\n',err.identifier);
        %fprintf(1,'There was an error! The message was:\n%s\n',err.message);
    end 
        
    % create a randomized color
    %colortemp = repelem(colors_lines(fileNum,:),length(areatemp),1);
    randcol = rand(1,3);
    randcol(round(rand*2+1)) = 0;
    colortemp = repelem(randcol,length(areatemp),1);
    
    % parameter conditions
    idx_keep = areatemp<areathhi & areatemp>areathlo & circtemp>circth & somadisttemp<somadistth & ~isnan(sirsignaltemp) & ~isnan(tmrsignaltemp);
    sirsignaltemp = sirsignaltemp(idx_keep);
    tmrsignaltemp = tmrsignaltemp(idx_keep);
    somadisttemp = somadisttemp(idx_keep);
    circtemp = circtemp(idx_keep);
    areatemp = areatemp(idx_keep);
    colortemp = colortemp(idx_keep);
            

    % Get the ratio
    %signratiotemp = sirsignaltemp./(tmrsignaltemp+sirsignaltemp);  % for SiR second dye
    signratiotemp = tmrsignaltemp./(tmrsignaltemp+sirsignaltemp);  % for TMR second dye
    
    % Add to list of all mitochondria in all images
    somadist = vertcat(somadist,somadisttemp);
    tmrsign = vertcat(tmrsign,tmrsignaltemp);
    sirsign = vertcat(sirsign,sirsignaltemp);
    signratio = vertcat(signratio,signratiotemp);
    area = vertcat(area,areatemp);
    circ = vertcat(circ,circtemp);
    colors = vertcat(colors,colortemp);

        
    % get mean and std grouping curves
    fprintf('Cell #%d\n',fileNum);
    meanstemp = [];
    stdstemp = [];
    bin_ntemp = [];
    meanstemp = [meanstemp mean(signratiotemp(somadisttemp==0))];
    stdstemp = [stdstemp std(signratiotemp(somadisttemp==0))];
    bin_ntemp = [bin_ntemp length(signratiotemp(somadisttemp==0))];
    fstr = sprintf('Mean+std in group 0: %.3f + %.3f',...
        meanstemp(end),stdstemp(end));
    disp(fstr)
    for n=0:groupingdist:maxdist
        meanstemp = [meanstemp mean(signratiotemp(somadisttemp<n+groupingdist & somadisttemp>n))];
        stdstemp = [stdstemp std(signratiotemp(somadisttemp<n+groupingdist & somadisttemp>n))];
        bin_ntemp = [bin_ntemp length(signratiotemp(somadisttemp<n+groupingdist & somadisttemp>n))];
        fstr = sprintf('Mean+std in group %d-%d: %.3f + %.3f',n,n+groupingdist,...
            meanstemp(end),stdstemp(end));
        disp(fstr)
    end
    means = [means;meanstemp]; 
    stds = [stds;stdstemp];
    bin_n = [bin_n;bin_ntemp];
end

%xdata(xdata>300) = 300;

%cellnumstr = strsplit(masterFolderPath,'\');
%cellnumstr = cellnumstr{7};
%writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_all.csv'));
%writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_mdvs.csv'));

%%% PLOTTING CODE

%colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

xlimlow1 = 0;
xlimup1 = maxdist;
ylimlow1 = 0.1;
ylimup1 = 10;

ylimlow2 = 0;
ylimup2 = 1;

fontsize = 14;
opacity = 0.5;

%ylabeltext1 = 'Ratio, 580/sum (a.u.)';
ylabeltext1 = 'Ratio, SiR/sum (a.u.)';
%ylabeltext1 = 'Ratio, TMR/sum (a.u.)';
%ylabeltext1 = 'Signal ratio, SiR/TMR (a.u.)';
xlabeltext1 = 'Distance to soma (um)';

%ratiopermitofiglog = figure('rend','painters','pos',[100 100 800 400]);
%%figure(1)
%%hold on
%h1 = scatter(xdata,ydata);
%xlim([xlimlow1 xlimup1])
%ylim([ylimlow1 ylimup1])
%xlabel(xlabeltext1)
%ylabel(ylabeltext1)
%set(gca,'FontSize',fontsize)
%set(gca,'TickDir','out');
%xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
%xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
%set(gca, 'YScale', 'log')
%yticks([0.01 0.1 1 10 100])
%yticklabels({'0.01','0.1','1','10','100'})

ratiopermitofiglin = figure('rend','painters','pos',[100 100 1200 800]);
%figure(1)
%hold on
%h2 = scatter(xdata,ydata,area*25,colors,'.');
h2 = scatter(somadist,signratio,100,colors,'.');
xlim([xlimlow1 xlimup1])
ylim([ylimlow2 ylimup2])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0 0.25 0.5 0.75 1])

groupingratiosfig = figure('rend','painters','pos',[100 100 1200 800]);
x = [0 groupingdist/2:groupingdist:maxdist+groupingdist/2];
meanofmeans = [];
stdofmeans = [];
for i = 1:length(x)
    meancol = means(:,i);
    meancol = meancol(~isnan(meancol));
    meanofmeans = [meanofmeans mean(meancol)];
    stdofmeans = [stdofmeans std(meancol)];
end

hold on
for i = 1:length(means)
    %errorbar(x,means(i,:),stds(i,:));
    plot(x,means(i,:));
end
errorbar(x,meanofmeans,stdofmeans,'k','LineWidth',2);
xlim([xlimlow1 xlimup1+groupingdist])
ylim([0 1])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0 0.25 0.5 0.75 1])

%[~,edges] = histcounts(log10(ydata));

%ratiopermitofig_histo = figure('rend','painters','pos',[100 100 800 400]);
%histogram(ydata(xdata==0),10.^edges,'Normalization','probability')
%hold on
%for n=0:groupingdist:maxdist
%    histogram(ydata(xdata>n & xdata<n+groupingdist),10.^edges,'Normalization','probability')
%end
%set(gca, 'xscale','log')
%xlim([ylimlow1 ylimup1])
%legend()