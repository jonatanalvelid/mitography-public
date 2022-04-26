%%% Test the convergence of a data set - plot random data points from the
%%% original data set; from 10% to 50% of the points.

function [] = dataConvergence(data)
lengthOfData = length(data);
sizes = zeros(10);    
for i=1:10
    sizes(i) = floor(lengthOfData*i/10);
end
data10 = data(randperm(lengthOfData,sizes(1)));
data20 = data(randperm(lengthOfData,sizes(2)));
data30 = data(randperm(lengthOfData,sizes(3)));
data40 = data(randperm(lengthOfData,sizes(4)));
data50 = data(randperm(lengthOfData,sizes(5)));
figure
histogram(data,'BinWidth',0.015,'Normalization','probability');
hold on
% histogram(data50,'BinWidth',0.015,'Normalization','probability');
% histogram(data40,'BinWidth',0.015,'Normalization','probability');
% histogram(data30,'BinWidth',0.015,'Normalization','probability');
% histogram(data20,'BinWidth',0.015,'Normalization','probability');
histogram(data10,'BinWidth',0.015,'Normalization','probability');
legend('All','50%','40%','30%','20%','10%');
legend('All','50%','10%');
legend('All','10%');
end
