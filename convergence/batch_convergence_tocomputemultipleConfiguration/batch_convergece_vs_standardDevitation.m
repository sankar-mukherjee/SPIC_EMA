%% distance form the mean baseline and convergence points
COMP = [128 256];

for component =1:2
    compon = COMP(component)
    config = {['all_scores_comp-' num2str(compon) '_regularizationFactor-3_audio.txt']};
    flag='mean';
    Cconvergence_threshold = [1:0.2:3];
    
    AAA=[];
    for JJ=1:length(Cconvergence_threshold)
        project.convergence_threshold = Cconvergence_threshold(JJ);
        create_formated_dataStructure
        
        name = [config{1} '_convThresholdStd-' num2str(project.convergence_threshold) '_' flag];
        get_con_div_noch_indexes_from_audio
        
        
        name = ['convergence_' name];
        plot_whole_exp
        
        AAA{JJ} = convergence_subject;
    end
    
    save([num2str(compon) '_comp.mat'],'AAA','Cconvergence_threshold');
end
%%
clear;clc;close all;
conv_VS_std = load('128_comp.mat');

CONV=[];NOCH=[];DIV=[];
for i=1:length(conv_VS_std.Cconvergence_threshold)
    CONV = [CONV;conv_VS_std.AAA{i}(1,:)];
    NOCH = [NOCH;conv_VS_std.AAA{i}(2,:)];
    DIV = [DIV;conv_VS_std.AAA{i}(3,:)];

end

figure;hold on;
% plot(conv_VS_std.Cconvergence_threshold,CONV,'.-')
plot(conv_VS_std.Cconvergence_threshold,NOCH,'o-')
plot(conv_VS_std.Cconvergence_threshold,DIV,'*-')