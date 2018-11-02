%% investigate jawopenoings EMA features in different condition


clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
% config = {'all_scores_comp-8_regularizationFactor-3_ematract.txt'};
% config = {'all_scores_comp-256_regularizationFactor-3_audio_features_18.txt'};

convergence_threshold = {'_convThresholdStd-2'};
flag='mean';
other_model_freq = 60;
ffname = ['convergence_' config{1} convergence_threshold{1} '_' flag '_otherModelFrequency_' num2str(other_model_freq)];

load(['..\convergence\data\' ffname '.mat']);
% conv_idx_O = conv_idx_O_only;         % remove the average space related convergence points

%%
project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};

name_legend=[];
for sub=1:10
   name_legend{sub}=['S' num2str(sub) '-' project.subjects.gender{sub}]; 
end

DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
DATA.EMA = load(['..\data\processed_data_EMA.mat']);

% velocity parameters
X=DATA.EMA.EMA.tract;  name = 'Average max jawopening(zscore)[mm]'; BB=0.8; YLIMIT=[-2 2.5];fname = 'avg_max_jawopening';ffname=[ fname '_' ffname ];


male = find(ismember(project.subjects.gender,'m'));female = find(ismember(project.subjects.gender,'f'));
genderIDX = [female male];

%% zscore normalization
a = cell2mat(X);
for i=1:6
    b=find(~isnan(a(:,i)));
    if not(isempty(b))
        A = a(b,i);
        A = zscore(A);
        a(b,i)=A;
    end
end
A=[];
x=1;y=0;
for i=1:length(X)
    y=y+length(X{i});
    A{i,1} = a(x:y,:);
    x=y+1;
end
X=A;

%% see if there is any sig diff in the ema features in convergence vs others
features= { 'avg-max-jawaopening','1stSyllable-max-Jawopening','2ndSyllable-max-Jawopening' };

pvalue = nan(10,length(features),2); P=zeros(length(features),2);
value = nan(10,6,length(features));
for ff=1:length(features)
    conv_ema =get_ema_other_feat(DATA,X,conv_idx_O,ff,1);
    noch_ema =get_ema_other_feat(DATA,X,noch_idx_O,ff,1);
    div_ema =get_ema_other_feat(DATA,X,div_idx_O,ff,1);
    
    % stat permutation test
    for sub =1:10
        A=conv_ema{sub};
        B=noch_ema{sub};
        C=div_ema{sub};
        if not(isempty(A) && isempty(B) && isempty(C))
%             pvalue(sub,ff,1) = do_permutaion_test_unequl_nonGaussion(A,B,1000);
%             pvalue(sub,ff,2) = do_permutaion_test_unequl_nonGaussion(A,C,1000);
            
            value(sub,:,ff) = [nanmean(A) nanmean(B) nanmean(C) nanstd(A) nanstd(B) nanstd(C)];
        end
        disp(sub)
    end
    
    A = squeeze(value(genderIDX,:,ff));
    A = A(:,1:3);             %std 4:end insted on mean 1:3
    [a,b] = ttest(A(:,1),A(:,2));
    P(ff,1) = b;
    [a,b] = ttest(A(:,1),A(:,3));
    P(ff,2) = b;
end

A=[];
for ff=1:length(features)
    a = squeeze(value(:,:,ff));
    mean_a = a(:,1:3);        %std insted on mean
    
    A{ff}=mean_a;
end
A = cat(3,A{:}); 
A = permute(A,[2 1 3]);

%%
h = figure('Position',[1950 160 1200 900]);
project.subjects.plot_colors = [0 0.45 0.74; 1 0 0;  0.47 0.67 0.19;];
aboxplot(A,'labels',features,'colormap',project.subjects.plot_colors); % Advanced box plot
% title('Group average articulatory features')
legend({'Convergence' 'NoChange' 'Divergence'},'Location','SouthEast')
grid on;
xlabel('Articulatory features')
ylabel([name])
set(gca,'fontsize',14)
set(gca, 'XTick', 0.5:0.25:25); 
set(gca, 'XTickLabel', 1:25); 
yt = get(gca, 'YTick');
xt = get(gca, 'XTick');

P_idx = [2 3;6 7; 10 11;14 15; 18 19; 22 23;3 4;7 8;11 12;15 16;19 20;23 24];
hold on

BB=max(A(:));
for i=1:length(P(:))
    if(P(i)<=0.05)
        a=P_idx(i,:);
        plot(xt(a), [1 1]*BB*1.1, '-k','linewidth',3)
%         if(P(i)<=0.001)
%             aa ='***';
%         elseif(P(i)<=0.01)
%             aa='**';
%         else
            aa=['p=' num2str(round(P(i),3))];
%         end
        text(mean(xt(a)), BB*1.15, aa,'HorizontalAlignment','Center','FontSize',7)
    end
end
hold off
set(gca, 'XTick',1:6); 
set(gca, 'XTickLabel', features); 
% ylim(YLIMIT)
% saveas(gca,['figs\group_avg_articulatory_features_' ffname '.tif'])



%% subjectwise plot for each faetures
% p_conVsnoch = squeeze(pvalue(:,:,1));
% p_conVsdiv = squeeze(pvalue(:,:,2));
% 
% project.subjects.plot_markers = {'-b','-.b','-r','-.r','-k','-.k','-c','-.c','-m','-.m'};
% % project.subjects.plot_colors = [0 0 1; 0 0 1; 1 0 0; 1 0 0; 0 0 0; 0 0 0; 0.47 0.67 0.19; 0.47 0.67 0.19; 0.93 0.69 0.13; 0.93 0.69 0.13];
% 
% for ff=1:length(features)
%     a = squeeze(value(:,:,ff));
%     mean_a = a(:,1:3);
%     std_a = a(:,4:6);
%     A = squeeze(pvalue(:,ff,1));
%     B = squeeze(pvalue(:,ff,2));
%     
%     mean_a = mean_a ./ mean_a(:,1);    std_a = std_a - std_a(:,1);   %for plotiing purpose
%     
%     
%     figure
%     hold on
%     for sub=1:10
%         plot(1:2,mean_a(sub,[1 3]),project.subjects.plot_markers{sub});
% %         errorbar(1:2,mean_a(sub,[1 2]),std_a(sub,[1 2]),project.subjects.plot_markers{sub});
%         %                 errorbar(1:2,mean_a(sub,[1 2]),std_a(sub,[1 2]),project.subjects.plot_markers{sub},'Color',project.subjects.plot_colors(sub,:))
%     end
%     xlim([0.7 2.3])
%     title('Convergence VS Divergence')
%     legend(name_legend,'Location','SouthWest')
%     
%     
%     figure
%     hold on
%     for sub=1:10
%         plot(1:2,mean_a(sub,[1 2]),project.subjects.plot_markers{sub});
% %         errorbar(1:2,mean_a(sub,[1 3]),std_a(sub,[1 3]),project.subjects.plot_markers{sub})
%     end
%     xlim([0.7 2.3])
%     title('Convergence VS NoChange')
%     legend(name_legend,'Location','SouthWest')
%     
% end
% % 
% 
% project.subjects.group_name = {'1FF';'2MM';'3MM';'4MM';'5FF'};































