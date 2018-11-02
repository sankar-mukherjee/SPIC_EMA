%% investigate EMA features in different condition


clear;clc;close all;

config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
convergence_threshold = {'_convThresholdStd-2'};
flag='mean';

name = [config{1} convergence_threshold{1} '_' flag];

load(['..\convergence\data\convergence_' name '.mat'],'data','conv_idx','conv_idx_only','div_idx','noch_idx','conv_idx_O','conv_idx_O_only','div_idx_O','noch_idx_O');

% conv_idx = conv_idx_only;        % remove the average space related convergence points
% conv_idx_O = conv_idx_O_only;

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
% XX=DATA.EMA.EMA.tract_velocity;  name = 'Velocity(zscore)[mm/s]'; BB=0.4; YLIMIT=[-0.4 0.5];fname = 'Velocity';
XX=DATA.EMA.EMA.tract;  name = 'Displacement(zscore)[mm]'; BB=2; YLIMIT=[-2 2.5];fname = 'Displacement';
% X=DATA.EMA.EMA.tract_accelaration;  name = 'Accelaration(zscore)[mm/s^2]'; BB=0.1; YLIMIT=[-0.25 0.15];fname = 'accelaration';
% X=DATA.EMA.EMA.tract;  name = 'Displacement SD(zscore)[mm]'; BB=0.85; YLIMIT=[0 1];fname = 'Displacement_SD';


male = find(ismember(project.subjects.gender,'m'));female = find(ismember(project.subjects.gender,'f'));
genderIDX = [female male];

%% zscore normalization
% a = cell2mat(XX);
% for i=1:6
%     b=find(~isnan(a(:,i)));
%     if not(isempty(b))
%         A = a(b,i);
%         A = zscore(A);
%         a(b,i)=A;
%     end
% end
% A=[];
% x=1;y=0;
% for i=1:length(XX)
%     y=y+length(XX{i});
%     A{i,1} = a(x:y,:);
%     x=y+1;
% end
% XX=A;


%% see if there is any sig diff in the ema features in convergence vs others
features= { 'jawaopening'    'lipaparature'    'lipProtrusion'    'TTCD'    'TDCD'    'TBCD'};

conv_Score =get_convScore(data,conv_idx,1,1);   %look at the function for more
noch_Score =get_convScore(data,noch_idx,0,1);
div_Score =get_convScore(data,div_idx,0,1);

R = zeros(6,2);
for ff=1:length(features)
    conv_ema =get_ema2(DATA,XX,conv_idx_O,ff,0);
    noch_ema =get_ema2(DATA,XX,noch_idx_O,ff,0);
    div_ema =get_ema2(DATA,XX,div_idx_O,ff,0);
    
    X=[];idx=[];Y=[];idy=[];Z=[];idz=[];
    for sub =1:10
        A=conv_ema{sub};B=noch_ema{sub};C=div_ema{sub};
        D=conv_Score{sub};
        E=noch_Score{sub};
        F=div_Score{sub};
        
        
        a = find(isnan(A));A(a)=[];D(a)=[];
        a = find(isnan(B));B(a)=[];E(a)=[];
        a = find(isnan(C));C(a)=[];F(a)=[];
        
        X=[X;D A];idx=[idx;zeros(length(A),1)+sub];
        Y=[Y;E B];idy=[idy;zeros(length(B),1)+sub];
        Z=[Z;F C];idz=[idz;zeros(length(C),1)+sub];
        
        disp(sub)
    end
    A = [X;Y;Z];
    [r,p] = corrcoef(A(:,1),A(:,2));

    R(ff,1) = r(1,2);
    R(ff,2) = p(1,2);
    
    
    figure;
    scatter(A(:,1),A(:,2),'x');
    
    
%     
%     
%     
%     
%     
%     figure;hold on;
%     gscatter(X(:,1),X(:,2),idx,[],'x');
%     gscatter(Y(:,1),Y(:,2),idy,[],'o');
% %     gscatter(Z(:,1),Z(:,2),idz,[],'v');
% 
%     
%     figure;hold on;
%     scatter(X(:,1),X(:,2),'x');
%     scatter(Y(:,1),Y(:,2),'o');
% %     scatter(Z(:,1),Z(:,2),'v');
    title(ff)
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


for i=1:length(P(:))
    if(P(i)<=0.05)
        a=P_idx(i,:);
        plot(xt(a), [1 1]*BB*1.1, '-k','linewidth',3)
        if(P(i)<=0.001)
            aa ='***';
        elseif(P(i)<=0.01)
            aa='**';
        else
            aa='*';
        end
        text(mean(xt(a)), BB*1.12, aa,'HorizontalAlignment','Center','FontSize',15)
    end
end
hold off
set(gca, 'XTick',1:6); 
set(gca, 'XTickLabel', features); 
ylim(YLIMIT)
saveas(gca,['figs\group_avg_articulatory_features_' fname '.tif'])



























