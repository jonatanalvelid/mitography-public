%%%
% Boxplot number density from experiments with MDMs split up in
% tinymdv/bigmdv/stick + glucos/antimycin
%
% @jonatanalvelid
%%%

clear

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(fileparts(filename)))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);
datafolder = fullfile(doubleparentfolder{1},'example-data');

%%%
% Parameters
% deconvolution
save = 0;  % boolean for saving figs or not
% data folder
dirread = fullfile(datafolder,'numberdensity','oxphos-axde\');
%%%

datalist = dir(fullfile(dirread,'*.mat'));

for i=1:numel(datalist)
    filename = datalist(i).name;

    disp(' ')
    disp(filename)
    
    data = load(strcat(datalist(i).folder,'\',filename)).data_exp;
    data_allexp(i) = data;
end
% get all fieldnames of the datastruct
fields = fieldnames(data_allexp);


%%% All MDMs
% Box plots with jittered scatter of number densities for all MDMs
fields1 = fields(contains(fields,'aa'));  % all fields for aa
fields2 = fields(contains(fields,'ct'));  % all fields for ct

% Number densities for all MDMs - all exp
testname = 'All MDMs';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-all.tif')
end


%%% Tiny + big MDVs
% Box plots with jittered scatter of number densities for tiny+big ves
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') | contains(fields,'t_n') & contains(fields,'aa') | contains(fields,'b_p') & contains(fields,'aa') | contains(fields,'b_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') | contains(fields,'t_n') & contains(fields,'ct') | contains(fields,'b_p') & contains(fields,'ct') | contains(fields,'b_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% Number densities for tiny+big MDVs - all exp
testname = 'All MDVs';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-allves.tif')
end


%%% Sticks
% Box plots with jittered scatter of number densities for sticks
fields1 = fields(contains(fields,'s_p') & contains(fields,'aa') | contains(fields,'s_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'s_p') & contains(fields,'ct') | contains(fields,'s_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% Number densities for sticks - all exp
testname = 'Sticks';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-sticks.tif')
end


%%% Tiny MDVs
% Box plots with jittered scatter of number densities for tiny MDVs
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') | contains(fields,'t_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') | contains(fields,'t_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% Number densities for tiny MDVs - all exp
testname = 'Tiny MDVs';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-tiny.tif')
end


%%% Big MDVs
% Box plots with jittered scatter of number densities for big MDVs
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') | contains(fields,'b_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') | contains(fields,'b_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% Number densities for big MDVs - all exp
testname = 'Big MDVs';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-big.tif')
end


%%%%%

function [] = numberdensity_boxplot(data1, data2, labels, infoname)
    grouping = [ones(size(data1));2*ones(size(data2))];
    
    disp(' ')
    [~,p] = ttest2(data1,data2);
    disp(infoname)
    fprintf('T-test : %f \n', p)
    
    figure('Position', [600 200 200 300])
    hold on
    allplotdata = [data1;data2];
    s1 = scatter(1*ones(size(data1)),data1,40,'rx','jitter','on','jitterAmount',0.09);
    s2 = scatter(2*ones(size(data2)),data2,40,'kx','jitter','on','jitterAmount',0.09);
    boxplot(allplotdata,grouping,'Labels',labels,'Symbol','')
    ylabel('Number density (/100 ??m)')
    ylim([0 20])
    title(sprintf('%s \n t-test : %.2g', infoname, p))
end
