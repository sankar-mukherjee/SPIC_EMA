function P = pca_noCompNeed_stat_plot(conv_pca,noch_pca,pca_threshold)

PC_count = nan(10,2);
for s=1:10
    a = conv_pca.explained{s};
    C=0;
    for c=1:length(a)
        C = C+a(c);
        if(C>=pca_threshold)
            PC_count(s,1) = c;
            break;
        end
    end
    a = noch_pca.explained{s};
    C=0;
    for c=1:length(a)
        C = C+a(c);
        if(C>=pca_threshold)
            PC_count(s,2) = c;
            break;
        end
    end
end
[H,P,CI,STATS] = ttest2(PC_count(:,1),PC_count(:,2));


end