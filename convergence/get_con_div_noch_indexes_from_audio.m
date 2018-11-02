%% get indexes of convergence
clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
% config = {'all_scores_comp-8_regularizationFactor-3_ematract.txt'};
% config = {'all_scores_comp-256_regularizationFactor-3_audio_features_18.txt'};

convergence_threshold = {'_convThresholdStd-2'};
flag='mean';
DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
name = [config{1} convergence_threshold{1} '_' flag];
IDX = load(['data\' name '.mat']);


other_model_freq = 0;
name = [name '_otherModelFrequency_' num2str(other_model_freq)];

%% further check for convergence
CONV = [];DIV=[];NOCH=[];
for sub=1:10
    conv_idx_by_model_freq = [];
    conv_idx_by_nochange2convergence = [];
    conv_idx_only = [];
    noch_idx_by_noch2divergence = [];
    
    %
    idx = find(IDX.data(:,1)==sub & IDX.data(:,3)~=1 & IDX.data(:,3)~=8);
    A = IDX.data(idx,:);
    
    %% convergence
    conv_idx_only = idx(find(A(:,5)));
    % noch->div make it convergence by how many times same model best fit the test speech
    ND_idx  = find(A(:,8));
    ND = A(ND_idx,11);
    model_freq = (hist(ND) / length(ND))*100;
    a = model_freq;
    a(a<other_model_freq)=0;
    a = find(a);
    if(other_model_freq)            % check if         other_model_freq ==0 means dont do this step
        if not(isempty(a))
            b = find(A(:,11)==a & A(:,8)==1);
            conv_idx_by_model_freq = idx(b);
            
            aa = find(A(:,8)==1);aa=setdiff(aa,b);
            noch_idx_by_noch2divergence = idx(aa);
        else
            noch_idx_by_noch2divergence = idx(find(A(:,8)));
        end
    else
        noch_idx_by_noch2divergence = idx(find(A(:,8)));
    end
    % noch->conv make it convergence (for now)
    conv_idx_by_nochange2convergence = idx(find(A(:,9)));
    % join all idx
    conv_idx = sort([conv_idx_only;conv_idx_by_model_freq;conv_idx_by_nochange2convergence]);
    
    CONV{sub,1} = conv_idx;   CONV{sub,2} = conv_idx_only; CONV{sub,3} = model_freq;
    
    %% divergence
    DIV{sub,1} = [idx(find(A(:,6)))];
    
    %% noch
    NOCH{sub,1} = [idx(find(A(:,7)));noch_idx_by_noch2divergence ];
    sum([length(CONV{sub,1}) length(DIV{sub,1}) length(NOCH{sub,1})])==size(A,1)
end

model_freq = cell2mat(CONV(:,3));
conv_idx = cell2mat(CONV(:,1));             conv_idx_O = get_original_index(IDX.data,DATA.D.D,conv_idx); 
conv_idx_only = cell2mat(CONV(:,2));        conv_idx_O_only = get_original_index(IDX.data,DATA.D.D,conv_idx_only); 
div_idx = cell2mat(DIV(:,1));               div_idx_O = get_original_index(IDX.data,DATA.D.D,div_idx); 
noch_idx = cell2mat(NOCH(:,1));             noch_idx_O = get_original_index(IDX.data,DATA.D.D,noch_idx); 


data=IDX.data;
save(['data\convergence_' name '.mat'],'data','conv_idx','conv_idx_only','div_idx','noch_idx','conv_idx_O','conv_idx_O_only','div_idx_O','noch_idx_O');


%%























