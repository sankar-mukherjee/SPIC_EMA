%% get data from excel file
% B = [];
% for i=1:3:21
%     A = [];
%     b=a(:,i:i+2);
%     for j=1:10
%         c = b(j,:);
%         c = [c 100-sum(c)];
%        A = [A;c];
%     end
%     B=[B A];
% end



project.subjects.group_name = {'Group 1-2 (FF)';'Group 3-4 (MM)';'Group 5-6 (MM)';'Group 7-8 (MM)';'Group 9-10 (FF)'};

project.subjects.plot_colors = [0 0.45 0.74; 1 0 0;  0.47 0.67 0.19;0.8 0.8 0.8];
k=1;
for i=1:2:10
    b=a(i:i+1,:);
    
    figure
    donut(b,[],project.subjects.plot_colors);
    set(gca,'Visible','off')
    alpha(0.8)
    set(gca,'LooseInset',get(gca,'TightInset'))
    saveas(gca,['figs\Couple_' project.subjects.group_name{k} '_audio_modelFreq-80_2std.tif']);    k=k+1;

    close all;
end













project.subjects.plot_colors = [0 0.45 0.74; 1 0 0;  0.47 0.67 0.19;0.8 0.8 0.8];

X=[0 50 60 70 80 90 100];k=1;
for i=1:4:28
    b=a(:,i:i+3);
    FigHandle1 = figure('Position', [100, 100, 1680, 1050]);
    donut(b,[],project.subjects.plot_colors);
    set(gca,'Visible','off')
    alpha(0.8)
    set(gca,'LooseInset',get(gca,'TightInset'))
%     saveas(gca,['figs\model_frequency_' num2str(X(k)) '_ema.tif']);
    k=k+1;
%     close all;
end

% 
% c = repmat(50,1,10)';
% c = [c c];
% c(1:2:end,1) =  c(1:2:end,1)+20;c(1:2:end,2) =  c(1:2:end,2)-20;
% project.subjects.plot_colors = [1 1 1; 0.8 0.8 0.8];
% FigHandle1 = figure('Position', [100, 100, 1680, 1050]);
% donut2(c,project.subjects.plot_colors,project.subjects.gender);
% set(gca,'Visible','off')
% set(gca,'LooseInset',get(gca,'TightInset'))
% saveas(gca,['figs\subject_label.tif']);
% close all;