clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
% config = {'all_scores_comp-8_regularizationFactor-3_ematract.txt'};
% config = {'all_scores_comp-256_regularizationFactor-3_audio_features_18.txt'};

project.convergence_threshold = 1;





project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pre','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','post'};

flag = 'mean';
%%
for con=1:length(config)
    
    gmm_score = importfile_python_gmm_output(['..\gmm_ubm\data\' config{con}]);
    
    % arrange
    % label = {'subject','partner','session','word','ownScore','partnerScore','scoreRatio','sub_to_partner'};
    label = {'subject','partner','session','word','convergence','divergence','nochange','noch->div','noch->convergence','effort_score','other_model_idx'};
    
    data = zeros(length(gmm_score.seg),4);
    for i=1:length(gmm_score.seg)
        a = strsplit(gmm_score.seg{i},'_');
        b = strsplit(a{1},'-');
        sub = b{1};session=b{2};word=a{2};
        
        [a,b] = find(ismember(project.subjects.group,sub));
        if(b==1)
            b=2;
        else
            b=1;
        end
        partner = project.subjects.group{a,b};
        
        sub = find(ismember(project.subjects.name,sub));
        partner = find(ismember(project.subjects.name,partner));
        session = find(ismember(project.session.list,session));
        data(i,:) = [sub partner session str2num(word)];
    end
    
    pre_model_score = [];
    for i=1:10
        a = find(data(:,1)==i & data(:,3)==1);
        c = project.subjects.name{i};
        b = find(ismember(gmm_score.model,c));
        pre_model_score{b} = gmm_score.score(a,b);  %sorted by python gmm score structure
    end
    
    feature = nan(length(gmm_score.seg),7);
    for i=1:length(data)
        sub = project.subjects.name{data(i,1)};
        partner = project.subjects.name{data(i,2)};
        session=project.session.list{data(i,3)};
        
        model = find(ismember(gmm_score.model,sub));
        partner_model = find(ismember(gmm_score.model,partner));
     
        
        score_model = gmm_score.score(i,model);    % own
        score_partner_model = gmm_score.score(i,partner_model);    % partner
%         score_ratio = score_partner_model / score_model;    % ratio
%         sub_to_partner = (pre_sub_score_partner_model - score_partner_model) / (pre_sub_score_partner_model - pre_partner_score_partner_model);
        
        other_model = setdiff(1:10,[model partner_model]);
        [other_model_value,other_model_idx] = max(gmm_score.score(i,other_model));
        other_model_idx = other_model(other_model_idx);
        other_model_name = gmm_score.model(other_model_idx);
        other_model_name = find(ismember(project.subjects.name,other_model_name));

        %     other_model = gmm_score.score(i,end);               %UBM
        
           
        pre_sub_score_model_dist = pre_model_score{model};        
        pre_partner_score_model_dist =  pre_model_score{partner_model};
        pre_other_score_model_dist = pre_model_score{other_model_idx};
        
        %%
        score_value = [score_model score_partner_model other_model_value];
        [a,score_order] = sort(score_value,'descend');
        effort_score = effort_score_compute(score_order,score_value,pre_sub_score_model_dist,pre_partner_score_model_dist,pre_other_score_model_dist,project.convergence_threshold,flag);
        
        %     feature(i,:) = [score_model score_partner_model score_ratio sub_to_partner];
        feature(i,:) = [effort_score other_model_name];

        disp(i)
    end
    data = [data feature];
    
    
    
    save(['data\' config{con} '_convThresholdStd-' num2str(project.convergence_threshold) '_' flag '.mat'],'data','label');
    
end









