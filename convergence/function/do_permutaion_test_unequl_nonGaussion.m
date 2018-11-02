function pvalue = do_permutaion_test_unequl_nonGaussion(A,B,number_of_permutations)


% %
% % # Combine the two datasets into a single dataset
% % # i.e., under the null hypothesis, there is no difference between the two groups
% combined = [A;B];diff=[];
% % # Observed difference
% diff.observed = mean(A) - mean(B);
% diff.random = [];
% for j=1:number_of_permutations
%     %     # Sample from the combined dataset without replacement
%     shuffled = datasample(combined, length(combined));
%     a.random = shuffled(1 : length(A));
%     b.random = shuffled((length(A) + 1) : length(combined));
%     %     # Null (permuated) difference
%     diff.random = [diff.random;mean(b.random) - mean(a.random)];
%     disp(j);
% end
% % % # P-value is the fraction of how many times the permuted difference is equal or more extreme than the observed difference
% pvalue = sum(abs(diff.random) >= abs(diff.observed)) / number_of_permutations;
%
%
%

%alice
tperm=0;
n1=size(A,1);
permdata=[A;B];
diffobs=mean(A)-mean(B);

for j=1:number_of_permutations
    
    perm_vect1=randperm(size(permdata,1),n1);
    perm_vect2=setdiff(1:size(permdata,1),perm_vect1);
    
    permdata1=permdata(perm_vect1);
    permdata2=permdata(perm_vect2);
    % calculate difference
    diffperm=mean(permdata1)-mean(permdata2);
    
    tperm=tperm+double(abs(diffperm)>abs(diffobs));
end

pvalue=(tperm/number_of_permutations);





end