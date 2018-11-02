%% investigate EMA features in different condition


clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
% config = {'all_scores_comp-8_regularizationFactor-3_ematract.txt'};
% config = {'all_scores_comp-256_regularizationFactor-3_audio_features_18.txt'};

convergence_threshold = {'_convThresholdStd-2'};
flag='mean';
other_model_freq = 80;
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
X=DATA.EMA.EMA.tract_velocity;  name = 'Zscore-normalized value'; BB=0.4; YLIMIT=[-0.4 0.75];fname = 'Velocity';ffname=[ fname '_' ffname ];
% X=DATA.EMA.EMA.tract;  name = 'Displacement(zscore)[mm]'; BB=2; YLIMIT=[-2 2.5];fname = 'Displacement';
% X=DATA.EMA.EMA.tract_accelaration;  name = 'Accelaration(zscore)[mm/s^2]'; BB=0.1; YLIMIT=[-0.25 0.15];fname = 'accelaration';
% X=DATA.EMA.EMA.tract;  name = 'Displacement SD(zscore)[mm]'; BB=0.85; YLIMIT=[0 1.2];fname = 'Displacement_SD';ffname=[ fname '_' ffname ];
% X=DATA.EMA.EMA.raw;  name = 'Velocity(zscore)[mm/s]'; BB=0.4; YLIMIT=[-0.4 0.5];fname = 'Velocity';ffname=[ fname '_' ffname ];

a=[];
for i=1:length(DATA.EMA.EMA.tract_velocity)
    a{i,1} = [X{i} DATA.EMA.EMA.tract{i}(:,1)];    
end
X=a;

male = find(ismember(project.subjects.gender,'m'));female = find(ismember(project.subjects.gender,'f'));
NDI = [2 3 5 7 9];
genderIDX = [male female];
features= { 'JO\newline(Velocity)','LA\newline(Velocity)','PRO\newline(Velocity)','TTCD\newline(Velocity)','TDCD\newline(Velocity)','TBCD\newline(Velocity)',...
    'JO\newline(maxavg both Syl)','JO\newline(max-1stSyl)','JO\newline(max-2ndSyl)'};
features= { 'JO','LA','PRO','TTCD','TDCD','TBCD',...
    'JO\_syll\_1&2','JO\_syll\_1','JO\_syll\_2'};
%% zscore normalization
a = cell2mat(X);
for i=1:size(a,2)
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

pvalue = nan(10,length(features),2); P=zeros(length(features),2);
value = nan(10,6,length(features));stat=[];
for ff=1:length(features)
    conv_ema =get_ema2(DATA,X,conv_idx_O,ff,1);
    noch_ema =get_ema2(DATA,X,noch_idx_O,ff,1);
    div_ema =get_ema2(DATA,X,div_idx_O,ff,1);
    
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
    [a,b,ci,stats1] = ttest(A(:,1),A(:,2));
    P(ff,1) = b;    
    [a,b,ci,stats2] = ttest(A(:,2),A(:,3));
    P(ff,2) = b;
    
    stat{ff,1} = [stats1.tstat stats1.df stats2.tstat stats2.df];
end

stat = cell2mat(stat);

A=[];
for ff=1:length(features)
    a = squeeze(value(:,:,ff));
    mean_a = a(:,1:3);        %std insted on mean
    
    A{ff}=mean_a;
end
A = cat(3,A{:}); 
A = permute(A,[2 1 3]);


AAAA=[];
for sub=1:10
    a = find(DATA.D.D(conv_idx_O,1)==sub);
    b = find(DATA.D.D(noch_idx_O,1)==sub);
    c = find(DATA.D.D(div_idx_O,1)==sub);

    conv = (length(a)-size(conv_ema{sub},1))/length(a);
    noch = (length(b)-size(noch_ema{sub},1))/length(b);
    div = (length(c)-size(div_ema{sub},1))/length(c);
    
%     AAAA = [AAAA;length(a) size(conv_ema{sub},1) length(b) size(noch_ema{sub},1) length(c) size(div_ema{sub},1)];
    AAAA = [AAAA; conv noch div];

end
  AAAA = AAAA*100
mean(AAAA)
std(AAAA)


B = A(:,:,1:6);
FFF = features;
features = FFF(1:6);
PP = P;
P = PP(1:6,:);

%%
h = figure('Position',[1950 160 1600 900]);
project.subjects.plot_colors = [0 0.45 0.74; 0.47 0.67 0.19; 1 0 0;  ];
aboxplot(B,'labels',features,'colormap',project.subjects.plot_colors); % Advanced box plot
% title('Group average articulatory features')
legend({'Convergence' 'NoChange' 'Divergence'},'Location','SouthEast')
grid on;
xlabel('Articulatory features')
ylabel(['Velocity(zscore) [mm/s]'])
set(gca,'fontsize',14)
set(gca, 'XTick', 0.5:0.25:25); 
set(gca, 'XTickLabel', 1:25); 
yt = get(gca, 'YTick');
xt = get(gca, 'XTick');

P_idx =[];a=[2 3];b=[3 4];
for i=1:length(features)
   P_idx = [P_idx;a b]; 
      a = a+4;b=b+4;
end
P_idx = reshape(P_idx,length(features)*2,2);
hold on

BB=max(A(:));
BB=0.55;

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
        text(mean(xt(a)), BB*1.2, aa,'HorizontalAlignment','Center','FontSize',20)
    end
end
hold off
set(gca, 'XTick',1:length(features)); 
set(gca, 'XTickLabel', features); 
set(gca, 'FontSize', 20); 
ylim(YLIMIT)
saveas(gca,['figs\1_' ffname '.tif'])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = A(:,:,7:9);
features = FFF(7:9);
P = PP(7:9,:);

%%
h = figure('Position',[1950 160 1600 900]);
project.subjects.plot_colors = [0 0.45 0.74; 0.47 0.67 0.19; 1 0 0;  ];
aboxplot(B,'labels',features,'colormap',project.subjects.plot_colors); % Advanced box plot
% title('Group average articulatory features')
legend({'Convergence' 'NoChange' 'Divergence'},'Location','SouthEast')
grid on;
xlabel('Articulatory features')
ylabel(['(zscore) [mm]'])
set(gca,'fontsize',14)
set(gca, 'XTick', 0.5:0.25:25); 
set(gca, 'XTickLabel', 1:25); 
yt = get(gca, 'YTick');
xt = get(gca, 'XTick');

P_idx =[];a=[2 3];b=[3 4];
for i=1:length(features)
   P_idx = [P_idx;a b]; 
      a = a+4;b=b+4;
end
P_idx = reshape(P_idx,length(features)*2,2);
hold on

BB=max(A(:));
BB=0.55;

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
        text(mean(xt(a)), BB*1.2, aa,'HorizontalAlignment','Center','FontSize',20)
    end
end
hold off
set(gca, 'XTick',1:length(features)); 
set(gca, 'XTickLabel', features); 
set(gca, 'FontSize', 20); 
ylim([0 0.7])
saveas(gca,['figs\2_' ffname '.tif'])

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































