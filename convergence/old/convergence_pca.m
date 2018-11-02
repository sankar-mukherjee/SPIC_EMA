%% PCA analysis
clear;clc;close all;
%%
DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
DATA.EMA = load(['..\data\processed_data_EMA.mat']);


%%
config = {'all_scores_comp-256_regularizationFactor-3.txt'};
convergence_threshold = {'_convThresholdStd-1','_convThresholdStd-1.5','_convThresholdStd-2'};

pca_threshold = 99;
ema_feat = 'ema_velocity';%'ema_velocity' 'ema_lip' 'ema_accelaration'
feat = [5:8 13 14];
zero_pad = 10; %10 samples points || 0 for no padding





%%
[p,q] = meshgrid(1:length(config), 1:length(convergence_threshold));
pairs = [p(:) q(:)];

P = nan(size(pairs,1),2);
for con=1:size(pairs,1)
    
    name = [config{pairs(con,1)} convergence_threshold{pairs(con,2)}];
    
    
    
    %%
    IDX = load(['..\convergence\data\convergence_' name '.mat'],'data','seq','seq_idx');
    conv_idx = IDX.seq_idx(find(IDX.seq(:)==300));
    noch_idx = IDX.seq_idx(find(IDX.seq(:)==0));
    
    
    
    %% seperate subject couple wise (to see if convergence word principal component differece is different than nochange difference) (within couple diff)
    PC=[];k=1;pc_comp=1;
    for i=1:2:10
        sub = conv_idx(find(IDX.data(conv_idx,1)==i));
        partner = conv_idx(find(IDX.data(conv_idx,1)==i+1));
        
        PC{k,1} = get_pca_subject(IDX,DATA,sub,ema_feat,feat,pc_comp,zero_pad);
        PC{k,2} = get_pca_subject(IDX,DATA,partner,ema_feat,feat,pc_comp,zero_pad);
        
        sub = noch_idx(find(IDX.data(noch_idx,1)==i));
        partner = noch_idx(find(IDX.data(noch_idx,1)==i+1));
        
        PC{k,3} = get_pca_subject(IDX,DATA,sub,ema_feat,feat,pc_comp,zero_pad);
        PC{k,4} = get_pca_subject(IDX,DATA,partner,ema_feat,feat,pc_comp,zero_pad);
        
        k=k+1;
    end
    
    pca_difference = [];
    for i=1:5
        pca_difference{i,1} = [mean(abs(PC{i,1} - PC{i,2})) mean(abs(PC{i,3} - PC{i,4}))];
        %         pca_difference{i,1} = [mean(abs(PC{i,1} ./ PC{i,2})) mean(abs(PC{i,3} ./ PC{i,4}))];
        
        %         pca_difference{i,1} = [(PC{i,1} ./ PC{i,2}) (PC{i,3} ./ PC{i,4})];
        %     pca_difference{i,1} = [(PC{i,1} - PC{i,2}) (PC{i,3} - PC{i,4})];
    end
    pca_difference = cell2mat(pca_difference);
    [H,P(con,1),CI,STATS] = ttest(pca_difference(:,1),pca_difference(:,2));
    
    
    
    
    %% check how many pc component needed with different configuration (within condition diff)
    conv_ema = get_emaData(IDX.data,DATA,conv_idx,ema_feat,zero_pad);
    noch_ema = get_emaData(IDX.data,DATA,noch_idx,ema_feat,zero_pad);
    
    % again select features
    for s=1:10
        conv_ema{s} = conv_ema{s}(:,feat);
        a = sum(conv_ema{s},2);
        a = find(isnan(a));
        conv_ema{s}(a,:)=[];
        
        noch_ema{s} = noch_ema{s}(:,feat);
        a = sum(noch_ema{s},2);
        a = find(isnan(a));
        noch_ema{s}(a,:)=[];
    end
    
    % PCA
    conv_pca = do_pca_subject_cond_wise(conv_ema);
    noch_pca = do_pca_subject_cond_wise(noch_ema);
    
    % PCA thresholding to get no of components that cross the thresholding
    % value and the do ttest
    
    P(con,2) = pca_noCompNeed_stat_plot(conv_pca,noch_pca,pca_threshold);
    
    % pca_threshold = [50:5:100];
    % P = nan(length(pca_threshold),1);
    % for i=1:length(pca_threshold)
    %     P(i) = pca_noCompNeed_stat_plot(conv_pca,noch_pca,pca_threshold(i));
    % end
    % plot(pca_threshold,P)
    
end





















