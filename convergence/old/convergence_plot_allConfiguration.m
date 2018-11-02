%% convergence
clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3.txt','all_scores_comp-32_regularizationFactor-3_ema.txt'};
convergence_threshold = {'_convThresholdStd-1','_convThresholdStd-1.5','_convThresholdStd-2'};
feat = [5 6 7 9];







%%
project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};


%%
[p,q] = meshgrid(1:length(config), 1:length(convergence_threshold));
pairs = [p(:) q(:)];
% pairs = sortrows(pairs,2);

convergene_percent = [];config_name=[];
for con=1:size(pairs,1)
    name = [config{pairs(con,1)} convergence_threshold{pairs(con,2)}];    

    load(['data\' name '.mat']);

    [seq,seq_idx] = plot_whole(data,project,feat);
    seq = cell2mat(seq);
    seq_idx = cell2mat(seq_idx);
    
    conv_score = nan(size(seq_idx));
    for s=1:length(seq_idx(:))
        if not(isnan(seq_idx(s)))
            if(seq(s)==300)
                conv_score(s) = abs(data(seq_idx(s),8));
            else
                conv_score(s) = data(seq_idx(s),8);
            end
        end
    end
    
%     figure;
%     subplot(2,1,1)
%     imagesc(seq);
%     
%     subplot(2,1,2)
%     imagesc(conv_score);
%     suptitle(name)
    
    A = [];
    for i=1:5
        c = find(seq(i,:)==300);    d = find(seq(i,:)==1);
        n = find(seq(i,:)==0);
        
        A = [A; length(c) length(d) length(n)];
    end
%     A/6
    convergene_percent = [convergene_percent A(:,1)/6];
    
    
    
    
    save(['data\convergence_' name '.mat'],'data','seq','seq_idx');
    
    
    name = strrep(name,'all_scores_','');
    name = strrep(name,'regularizationFactor','R');
    name = strrep(name,'.txt','');
    name = strrep(name,'convThresholdStd','Cstd');
    name = strrep(name,'_','-');
    config_name{con} = name;
end


bar(convergene_percent','DisplayName','convergene_percent')
title('different configuration convergence groupwise');
ylabel('Convergence [%]')
project.subjects.group_name = {'1FF';'2MM';'3MM';'4MM';'5FF'};
legend(project.subjects.group_name)

set(gca, 'XTick', 1:length(config_name), 'XTickLabel', config_name);
xtickangle(0)

% saveas(gca,['figs\configuration_convergencePercetage.tif'])

















