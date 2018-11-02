
a = find(data(:,1)==1 & data(:,3)~=1 & data(:,3)~=8);
A = data(a,:);
A = sortrows(A,[3 4]);

A=[];
for i=1:10
    a = find(data(:,1)==i & data(:,3)~=1 & data(:,3)~=8 & data(:,7)==1);
    a = data(a,9);
    a = (hist(a) / length(a))*100;
%     a = hist(a);

%     [c,a] = max(a);
    A=[A;a];
end
A(A<25)=0;

A = sortrows(A,[3 4]);



uRows = unique(AAA,'rows');
a = mat2cell(uRows,ones(1,size(uRows,1)),3); % convert to cell for cellfun
% function handle that takes a 1x2 row vector as input 
% and returns the number of matching rows in A.
g = @(row)nnz(ismember(AAA,row,'rows')); 
% the probability
puRows = cellfun(g,a)/size(AAA,1);

find(data(:,9));




%     
%     data=IDX.data;
%     
% conv_idx = cell2mat(CONV(:,1));            
% div_idx = cell2mat(DIV(:,1));              
% noch_idx = cell2mat(NOCH(:,1));            

    
    