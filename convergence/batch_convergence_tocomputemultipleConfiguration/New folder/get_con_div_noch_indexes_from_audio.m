%% get indexes of convergence
clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
convergence_threshold = {'_convThresholdStd-2'};
feat = [5 6 7 9]; % see lables 5=convergence 6=divergence 7 = nochange 9=other model idx if susequent are same convergence in some average space
feature_value = [2 1 0];      %2 convergence 1=divergence 0=nochange

flag='mean';
%%
project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};


DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);

%%
name = [config{1} convergence_threshold{1} '_' flag];

IDX = load(['data\' name '.mat']);

[seq,seq_idx,seq_only] = get_whole_exp_idx_convergence_divergence(IDX.data,project,feat,feature_value);
seq = cell2mat(seq);
seq_idx = cell2mat(seq_idx);
seq_only = cell2mat(seq_only);

% get the convergence score(analog)
conv_score = nan(size(seq_idx));
for s=1:length(seq_idx(:))
    if not(isnan(seq_idx(s)))
        if(seq(s)==2)
            conv_score(s) = abs(IDX.data(seq_idx(s),8));
        else
            conv_score(s) = IDX.data(seq_idx(s),8);
        end
    end
end

conv_idx = seq_idx(find(seq(:)==2));    conv_idx_only = seq_idx(find(seq_only(:)==2));
div_idx = seq_idx(find(seq(:)==1));
noch_idx = seq_idx(find(seq(:)==0));

conv_idx_O = get_original_index(IDX.data,DATA.D.D,conv_idx);    conv_idx_O_only = get_original_index(IDX.data,DATA.D.D,conv_idx_only);
div_idx_O = get_original_index(IDX.data,DATA.D.D,div_idx);
noch_idx_O = get_original_index(IDX.data,DATA.D.D,noch_idx);

data=IDX.data;

save(['data\convergence_' name '.mat'],'data','seq','seq_only','seq_idx','conv_score','conv_idx','conv_idx_only',...
    'div_idx','noch_idx','conv_idx_O','conv_idx_O_only','div_idx_O','noch_idx_O');


%%























