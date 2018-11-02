
clear;clc;close all;
config = {'all_scores_comp-256_regularizationFactor-3_audio.txt'};
% config = {'all_scores_comp-8_regularizationFactor-3_ematract.txt'};
% config = {'all_scores_comp-256_regularizationFactor-3_audio_features_18.txt'};

other_model_freq = 80;

convergence_threshold = {'_convThresholdStd-2'};
flag='mean';
name = ['convergence_' config{1} convergence_threshold{1} '_' flag '_otherModelFrequency_' num2str(other_model_freq)];

load(['data\' name '.mat']);
% conv_idx_O = conv_idx_O_only;         % remove the average space related convergence points

%% after convergence_audio
project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.session.list = {'pretest','duet1', 'duet2', 'duet3' ,'duet4','duet5','duet6','posttest'};
project.subjects.group_name = {'Group 1-2 (FF)';'Group 3-4 (MM)';'Group 5-6 (MM)';'Group 7-8 (MM)';'Group 9-10 (FF)'};

name_legend=[];
for sub=1:10
   name_legend{sub}=[num2str(sub) '-' project.subjects.gender{sub}]; 
end

project.subjects.plot_colors = [0 0.45 0.74; 1 0 0;  0.47 0.67 0.19;];
% subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.05], [0.05 0.05], [0.1 0.01]);

% plot whole exp subject by couple
FigHandle1 = figure('Position', [100, 100, 1680, 1050]);
AA=[];
for sub=1:10    
    A=[];    
    for session=2:7
        conv = length(find(data(conv_idx,1)==sub & data(conv_idx,3)==session));
        noch = length(find(data(noch_idx,1)==sub & data(noch_idx,3)==session));
        div = length(find(data(div_idx,1)==sub & data(div_idx,3)==session));
        A = [A; conv noch div];        
    end
    AA = [AA A];
end

conv = AA(:,1:3:end);
noch = AA(:,2:3:end);
div = AA(:,3:3:end);
A=[];k=1;
for g=1:2:10
    group_mean = [sum(conv(:,g:g+1),2)  sum(noch(:,g:g+1),2) sum(div(:,g:g+1),2);];
    group_std = [std(conv(:,g:g+1)')'  std(noch(:,g:g+1)')' std(div(:,g:g+1)')' ];
    
    A = [A;[0 0 0]; group_mean];
    % h = barwitherr(group_std,group_mean);% Plot with errorbars
        b = bar(group_mean,'EdgeColor','flat');
        colormap(project.subjects.plot_colors)
        grid on
        box on
        ylabel('[%]')
        xlabel('Sessions')
        xlim([0 7])
        ylim([0 100])
        title(project.subjects.group_name(k));k=k+1;
end
subplot(2,1,1);
b = bar(A,'EdgeColor','flat');
set(gca, 'XTick', 1:36); 

line([8 8], [0 100],'Color','k','LineWidth',2);
line([15 15], [0 100],'Color','k','LineWidth',2);
line([22 22], [0 100],'Color','k','LineWidth',2);
line([29 29], [0 100],'Color','k','LineWidth',2);

aa = {'','1','2','3','4','5','6'};
% aa = {'','Session-1','Session-2','Session-3','Session-4','Session-5','Session-6'};
set(gca, 'XTickLabel', aa); 
colormap(project.subjects.plot_colors)
grid on
box on
ylabel('[%]')
xlabel('Sessions')
xlim([1 36])
ylim([0 100])
a = [4 12 18 26 33];
text(a, repmat(105,1,5), project.subjects.group_name,'HorizontalAlignment','Center','FontSize',10)


subject_mean = [sum(conv);  sum(noch);sum(div);];
% subject_std = [std(conv); std(noch); std(div);];

subplot(2,1,2);
% h = barwitherr(subject_std',subject_mean');% Plot with errorbars
b = bar(subject_mean'/3,'EdgeColor','flat');
colormap(project.subjects.plot_colors)
grid on
box on
ylabel('[%]')
xlabel('Subjects')
xlim([0 11])
ylim([0 100])
title(name)
set(gca, 'XTickLabel', name_legend); 
legend('Convergence','Nochange','Divergence','Orientation','horizontal','Location','east')

a=round(subject_mean'/3)
saveas(gca,['figs\subject_convergence' name '.tif'])
close all;


male = find(ismember(project.subjects.gender,'m'));female = find(ismember(project.subjects.gender,'f'));

sum(subject_mean(1,male))/18
sum(subject_mean(1,female))/12

% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 






















