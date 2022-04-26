clear all

save = 1;  % 1 == save, 0 == do not save

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_numberdensity-noaxde-1oxppex','\');
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


%%% All MDVs
% Box plots with jittered scatter of MDV number densities for all MDVs
fields1 = fields(contains(fields,'aa'));  % all fields for aa
fields2 = fields(contains(fields,'ct'));  % all fields for ct

% MDV number densities for all MDVs - all exp
testname = 'All MDVs - all exp';
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
    saveas(gcf, 'mdvdensity-aavgl-exp145-all.tif')
end

% MDV number densities for all MDVs - exp 1
testname = 'All MDVs - exp 1';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-aavgl-exp1-all.tif')
end

% MDV number densities for all MDVs - exp 4
testname = 'All MDVs - exp 4';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-aavgl-exp4-all.tif')
end

% MDV number densities for all MDVs - exp 5
testname = 'All MDVs - exp 5';
plotdata1 = [];
for i=3
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
for i=3
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
    saveas(gcf, 'mdvdensity-aavgl-exp5-all.tif')
end


%%% Tiny + big MDVs
% Box plots with jittered scatter of MDV number densities for tiny+big ves
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') | contains(fields,'t_n') & contains(fields,'aa') | contains(fields,'b_p') & contains(fields,'aa') | contains(fields,'b_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') | contains(fields,'t_n') & contains(fields,'ct') | contains(fields,'b_p') & contains(fields,'ct') | contains(fields,'b_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny+big ves - all exp
testname = 'All vesicles - all exp';
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
    saveas(gcf, 'mdvdensity-aavgl-exp145-allves.tif')
end

% MDV number densities for tiny+big ves - exp 1
testname = 'All vesicles - exp 1';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-aavgl-exp1-allves.tif')
end

% MDV number densities for tiny+big ves - exp 4
testname = 'All vesicles - exp 4';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-aavgl-exp4-allves.tif')
end

% MDV number densities for tiny+big ves - exp 5
testname = 'All vesicles - exp 5';
plotdata1 = [];
for i=3
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
for i=3
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
    saveas(gcf, 'mdvdensity-aavgl-exp5-allves.tif')
end



%%% Sticks
% Box plots with jittered scatter of MDV number densities for sticks
fields1 = fields(contains(fields,'s_p') & contains(fields,'aa') | contains(fields,'s_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'s_p') & contains(fields,'ct') | contains(fields,'s_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% MDV number densities for sticks - all exp
testname = 'All sticks - all exp';
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
    saveas(gcf, 'mdvdensity-aavgl-exp145-sticks.tif')
end

% MDV number densities for sticks - exp 1
testname = 'All sticks - exp 1';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-aavgl-exp1-sticks.tif')
end

% MDV number densities for sticks - exp 4
testname = 'All sticks - exp 4';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-aavgl-exp4-sticks.tif')
end

% MDV number densities for sticks - exp 5
testname = 'All sticks - exp 5';
plotdata1 = [];
for i=3
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
for i=3
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
    saveas(gcf, 'mdvdensity-aavgl-exp5-sticks.tif')
end


%%% Tiny vesicles
% Box plots with jittered scatter of MDV number densities for tiny vesicles
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') | contains(fields,'t_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') | contains(fields,'t_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny vesicles - all exp
testname = 'All tiny ves - all exp';
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
    saveas(gcf, 'mdvdensity-aavgl-exp145-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 1
testname = 'All tiny ves - exp 1';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-aavgl-exp1-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 4
testname = 'All tiny ves - exp 4';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-aavgl-exp4-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 5
testname = 'All tiny ves - exp 5';
plotdata1 = [];
for i=3
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
for i=3
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
    saveas(gcf, 'mdvdensity-aavgl-exp5-tiny.tif')
end



%%% Tiny vesicles
% Box plots with jittered scatter of MDV number densities for big vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') | contains(fields,'b_n') & contains(fields,'aa'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') | contains(fields,'b_n') & contains(fields,'ct'));  % all fields for t_p, b_p and ct

% MDV number densities for big vesicles - all exp
testname = 'All big ves - all exp';
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
    saveas(gcf, 'mdvdensity-aavgl-exp145-big.tif')
end

% MDV number densities for big vesicles - exp 1
testname = 'All big ves - exp 1';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-aavgl-exp1-big.tif')
end

% MDV number densities for big vesicles - exp 4
testname = 'All big ves - exp 4';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-aavgl-exp4-big.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All big ves - exp 5';
plotdata1 = [];
for i=3
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
for i=3
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
    saveas(gcf, 'mdvdensity-aavgl-exp5-big.tif')
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
    ylabel('Number density (/100 µm)')
    ylim([0 20])
    title(sprintf('%s \n t-test : %.2g', infoname, p))

end
