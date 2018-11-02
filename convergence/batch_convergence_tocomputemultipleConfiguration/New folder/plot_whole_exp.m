
clear;clc;close all;
config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
convergence_threshold = {'_convThresholdStd-2'};
flag='mean';
name = ['convergence_' config{1} convergence_threshold{1} '_' flag];
load(['data\' name '.mat']);

%% after convergence_audio
project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};
project.subjects.group_name = {'1-2 FF';'3-4 MM';'5-6 MM';'7-8 MM';'9-10 FF'};

name_legend=[];
for sub=1:10
   name_legend{sub}=[num2str(sub) '-' project.subjects.gender{sub}]; 
end

project.subjects.plot_colors = [0 0.45 0.74; 1 0 0;  0.47 0.67 0.19;];
% subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.05], [0.05 0.05], [0.1 0.01]);

% plot whole exp subject by couple
FigHandle1 = figure('Position', [100, 100, 1600, 1200]);
for j=1:5
    A=[];
    for i=1:100:600
        a = seq(j,i:i+99);
        conv = length(find(a==2));
        div = length(find(a==1));
        noch = length(find(a==0));
        
        A = [A; conv noch div];
    end
    
    subplot(2,3,j);
    b = bar(A,1);
    colormap(project.subjects.plot_colors)
    set(gca,'Color',[0.8 0.8 0.8])
    grid on
    box on
    ylabel('[%]')
    xlabel('Sessions')
%     legend('Convergence','Nochange','Divergence','Orientation','horizontal','Location','north')
    ylim([0 80])
    xlim([0 7])
    title(project.subjects.group_name(j))
%     saveas(gca,['figs\whole_exp_' num2str(j) '.tiff'])
%     close all;
end

%% plot whole exp subject by subject
conv_idx = seq_idx(find(seq(:)==2));
div_idx = seq_idx(find(seq(:)==1));
noch_idx = seq_idx(find(seq(:)==0));

convergence_subject=zeros(3,10);
for i=1:10
    sub = conv_idx(find(data(conv_idx,1)==i));
    convergence_subject(1,i)=length(sub)/3;
    
    sub = div_idx(find(data(div_idx,1)==i));
    convergence_subject(3,i)=length(sub)/3;
    
    sub = noch_idx(find(data(noch_idx,1)==i));
    convergence_subject(2,i)=length(sub)/3;
end
subplot(2,3,6);

b = bar(convergence_subject');
colormap(project.subjects.plot_colors)
set(gca,'Color',[0.8 0.8 0.8])
grid on
box on
ylabel('[%]')
xlabel('Subjects')
xlim([0 11])
ylim([0 80])
% title('convergene')
set(gca, 'XTickLabel', name_legend); 

legend('Convergence','Nochange','Divergence','Orientation','horizontal','Location','Best')

saveas(gca,['figs\subject_convergence' name '.tiff'])
close all;

%%



% 
% 
% imagesc(seq(:,1:100));
% % % noch=white
% % % divergenc=balck
% % % con=red
% 
% 
% 
% 
% subplot(2,1,2)
% imagesc(conv_score);
% suptitle(name)
% 




































