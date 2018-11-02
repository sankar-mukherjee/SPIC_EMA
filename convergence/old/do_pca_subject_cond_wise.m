function conv_pca = do_pca_subject_cond_wise(conv_ema)


conv_pca=[];conv_pca.coeff=[];conv_pca.score=[];conv_pca.latent=[];conv_pca.tsquared=[];conv_pca.explained=[];conv_pca.mu=[];
for s=1:length(conv_ema)
    a = conv_ema{s};
    for i=1:size(a,2)
        a(:,i) = (a(:,i)-nanmean(a(:,i)))/(nanstd(a(:,i)));
    end
    [conv_pca.coeff{s,1}, conv_pca.score{s,1}, conv_pca.latent{s,1}, conv_pca.tsquared{s,1}, conv_pca.explained{s,1}, conv_pca.mu{s,1}] = pca(a);
    
end


end