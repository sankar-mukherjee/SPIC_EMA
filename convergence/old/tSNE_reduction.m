%% tSNE
clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3.txt','all_scores_comp-32_regularizationFactor-3_ema.txt'};
convergence_threshold = {'_convThresholdStd-1','_convThresholdStd-1.5','_convThresholdStd-2'};




ema_feat = 'ema_lip';
name = 'all_scores_comp-256_regularizationFactor-3.txt_convThresholdStd-1';

DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
DATA.EMA = load(['..\data\processed_data_EMA.mat']);
IDX = load(['..\convergence\data\convergence_' name '.mat'],'data','seq','seq_idx');

zero_pad = 10; %10 samples points || 0 for no padding


conv_idx = IDX.seq_idx(find(IDX.seq(:)==300));
noch_idx = IDX.seq_idx(find(IDX.seq(:)==0));


conv_ema = get_emaData(IDX.data,DATA,conv_idx,ema_feat,zero_pad);
noch_ema = get_emaData(IDX.data,DATA,noch_idx,ema_feat,zero_pad);



% Set parameters
no_dims = 2;
initial_dims = 5;
perplexity = 30;

s=2;
train_X = [conv_ema{s};noch_ema{s}];
train_labels = [ones(size(conv_ema{s},1),1);ones(size(noch_ema{s},1),1)+1];

a = sum(train_X,2);
a = find(isnan(a));
train_X(a,:)=[];
train_labels(a)=[];

% Run t?SNE
mappedX = tsne(train_X, [], no_dims, initial_dims, perplexity);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2), train_labels);