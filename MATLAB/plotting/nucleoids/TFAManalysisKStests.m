%%%
% Mitography - TFAM analysis - KS tests
%----------------------------
% Version: 200306
%
% @jonatanalvelid
%%%


groups = [2.5 7.5 15 30 50 70 90];
AxonDistGroup = [];

AxonDistance = mitodata(:,1);
NumNucleotides = mitodata(:,2);
for i = 1:length(AxonDistance)
    [~,closestIdx] = min(abs(AxonDistance(i)-groups));
    AxonDistGroup(i) = groups(closestIdx);
end
AxonDistGroup = AxonDistGroup';
mitodatatable = table(AxonDistance,AxonDistGroup,NumNucleotides);

mitodatatablesort = sortrows(mitodatatable,1);
axdistgroupsort = mitodatatablesort.AxonDistGroup;
numnucleoidsort = mitodatatablesort.NumNucleotides;

iall = groups;

allpval = [];
for i = 1:length(iall)
    group1 = numnucleoidsort(axdistgroupsort==iall(i));
    for n = 1:length(iall)
        group2 = numnucleoidsort(axdistgroupsort==iall(n));
        [p,h] = ranksum(group1,group2);
        allpval(i,n) = p;
        disp(iall(i))
        disp(iall(n))
        disp(p)
    end
end
disp(allpval)
