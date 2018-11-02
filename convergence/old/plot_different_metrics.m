%% plot different metrics
clear;clc;close all;

config = 'all_scores_comp-256_regularizationFactor-3.txt';
% config = 'all_scores_comp-32_regularizationFactor-3_ema.txt';


project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};

load(['data\' config '.mat']);


%%
score_ratio=nan(10,6,50);

for sub = 1:10
    for session =2:7
        a = find(ismember(data(:,1),sub));
        b = find(ismember(data(:,3),session));
        a = intersect(a,b);
        b = data(a,4);
        
        score_ratio(sub,session-1,b) = data(a,7);
    end
end
score_ratio = 1-score_ratio;

for s = 1:2:10
    sub = squeeze(score_ratio(s,:,:));
    partner = squeeze(score_ratio(s+1,:,:));
    
    for session=1:6
        A = sub(session,:);
        B = -partner(session,:);
        T = 1:length(A);
        T2 = T+0.5;
        
        subplot(6,1,session);
        plot(T,A,'-ks','LineWidth',1,'MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor','b');hold on
        plot(T2,B,'-ks','LineWidth',1,'MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor','r');
        plot(T,0*ones(size(T)));
        set(gca,'xlim',[0 51])
    end
end





%% own model score performance
own_score=zeros(10,8);
parner_score = own_score;
for sub = 1:10
    for session =1:8
        a = find(ismember(data(:,1),sub));
        b = find(ismember(data(:,3),session));
        a = intersect(a,b);
        own_score(sub,session) = mean(data(a,5));
        parner_score(sub,session) = mean(data(a,6));
    end
end

R = abs(own_score);
% R = abs(parner_score);

%
C = combnk([1:8],2);
p = zeros(length(C),1);
groups = [];
for i=1:length(C)
    [h,p(i),ci,stats] = ttest2(R(:,C(i,1)),R(:,C(i,2)));
    groups{i} = C(i,:);
end

H=bar(mean(R));
hold on;
errorbar(1:8,mean(R),std(R),'color','k','linestyle','none');
set(H,'FaceColor',[0.5,0.5,0.5])
H=sigstar(groups(1:7),p(1:7),1);
title({'Session avg LLR score (computed on its own model)' , 't-test with significance (p<0.05)',config});
Labels = project.session.list;
set(gca, 'XTick', 1:8, 'XTickLabel', Labels);
ylabel('LLR score [positive]')
saveas(gca,['figs\session_avg_LLR_ownModel' config '.tif'])









