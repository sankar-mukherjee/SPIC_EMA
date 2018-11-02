function A = get_pca_subject(IDX,DATA,sub,ema_feat,feat,pc_comp,zero_pad)

A = get_emaData(IDX.data,DATA,sub,ema_feat,zero_pad);
A = A(~cellfun(@isempty, A));
% again select features
A{1} = A{1}(:,feat);

a = sum(A{1},2);
a = find(isnan(a));
A{1}(a,:)=[];

A = do_pca_subject_cond_wise(A);
A = cell2mat(A.coeff);
A = A(pc_comp,:);


end