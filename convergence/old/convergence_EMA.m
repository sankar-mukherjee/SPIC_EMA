clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3.txt','all_scores_comp-32_regularizationFactor-3_ema.txt'};
convergence_threshold = {'_convThresholdStd-1','_convThresholdStd-1.5','_convThresholdStd-2'};




ema_feat = 'ema_lip';
name = 'all_scores_comp-256_regularizationFactor-3.txt_convThresholdStd-1';

DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
DATA.EMA = load(['..\data\processed_data_EMA.mat']);
IDX = load(['..\convergence\data\convergence_' name '.mat'],'data','seq','seq_idx');



conv_idx = IDX.seq_idx(find(IDX.seq(:)==300));      
noch_idx = IDX.seq_idx(find(IDX.seq(:)==0));

conv_idx_O = get_original_index(IDX.data,DATA,conv_idx);
noch_idx_O = get_original_index(IDX.data,DATA,noch_idx);

conv_word = DATA.D.WORD(conv_idx_O);      
noch_word = DATA.D.WORD(noch_idx_O);      

conv_ema = get_emaData(IDX.data,DATA,conv_idx,ema_feat);
noch_ema = get_emaData(IDX.data,DATA,noch_idx,ema_feat);

coeff=[];explained=[];score=[];
for s=1:10
    a = conv_ema{s};
    for i=1:size(a,2)
        a(:,i) = (a(:,i)-nanmean(a(:,i)))/(nanstd(a(:,i)));
    end
    [coeff{s,1}, score{s,1}, latent, tsquared, explained{s,1}, mu] = pca(a);
    a = noch_ema{s};
    for i=1:size(a,2)
        a(:,i) = (a(:,i)-nanmean(a(:,i)))/(nanstd(a(:,i)));
    end
    [coeff{s,2}, score{s,2}, latent, tsquared, explained{s,2}, mu] = pca(a);
end

explained = cell2mat(explained');
PC = 1;
A=[];
for s=1:10
    if not(isempty(coeff{s,1}))
        figure;
        SS = score{s,1}(:,1:2);
        scatter(SS(:,1),SS(:,2),'.b');hold on;
        SS = score{s,2}(:,1:2);
        scatter(SS(:,1),SS(:,2),'.r');
        
        A = [A;coeff{s,1}(PC,:) coeff{s,2}(PC,:)];
    end
end

[H,P,CI,STATS] = ttest2(A(:,5),A(:,10))

R =A;

H=bar(mean(R));
hold on;
errorbar(1:size(R,2),mean(R),std(R),'color','k','linestyle','none');
set(H,'FaceColor',[0.5,0.5,0.5])
% H=sigstar(groups,p);
% title('Session avg reactiontime');
% Labels = project.session.list;
% set(gca, 'XTick', 1:8, 'XTickLabel', Labels);
% ylabel('Reaction Time [sec]')



















