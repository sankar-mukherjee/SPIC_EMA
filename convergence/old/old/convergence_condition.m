function [convergence_score,divergence,convergence_A,convergence_B,rare_event] = convergence_condition(sub_score_session,partner_score_session,pre_sub,pre_partner,session_fake_dist,project)
%% convergence condition
convergence_score = zeros(size(sub_score_session));
divergence = zeros(size(convergence_score));
convergence_A = zeros(size(convergence_score));
convergence_B = zeros(size(convergence_score));
rare_event = zeros(size(convergence_score));

%% compute the upper and lower of the pretest distribution
UP_A = nanmean(pre_sub)+project.convergence.fakestd*nanstd(pre_sub);
LW_A = nanmean(pre_sub)-project.convergence.fakestd*nanstd(pre_sub);
UP_B = nanmean(pre_partner)+project.convergence.fakestd*nanstd(pre_partner);
LW_B = nanmean(pre_partner)-project.convergence.fakestd*nanstd(pre_partner);

project.convergence.subA_conv_threshold = LW_A;
project.convergence.subB_conv_threshold = UP_B;
project.convergence.subA_div_threshold = UP_A;
project.convergence.subB_div_threshold = LW_B;

%% condition 1 (if they are in definde boundary)
for i=1:length(sub_score_session)
    mean_win_A = sub_score_session(i);
    mean_win_B = partner_score_session(i);
    
    if(mean_win_A <= project.convergence.subA_conv_threshold && mean_win_B >= project.convergence.subB_conv_threshold)
        convergence_score(i) = 1;
    elseif(mean_win_A >= project.convergence.subA_div_threshold && mean_win_B <= project.convergence.subB_div_threshold)
        divergence(i) = 1;
    elseif(mean_win_A <= project.convergence.subA_conv_threshold && mean_win_B > project.convergence.subB_div_threshold && mean_win_B < project.convergence.subB_conv_threshold)
        convergence_A(i) = 1;
        %     elseif(mean_win_A <= project.convergence.subB_conv_threshold && mean_win_B <= project.convergence.subB_conv_threshold)
        %         convergence_A(i) = 1;
    elseif(mean_win_A > project.convergence.subA_conv_threshold && mean_win_A < project.convergence.subA_div_threshold && mean_win_B >= project.convergence.subB_conv_threshold)
        convergence_B(i) = 1;
        %     elseif(mean_win_A >= project.convergence.subA_conv_threshold && mean_win_B >= project.convergence.subA_conv_threshold)
        %         convergence_B(i) = 1;
    end
end

%% condition 2 (if they are not noise but actual phenomenon)
session_fake_dist = cell2mat(session_fake_dist);
% 
% A = [];B=[];
% for i=1:length(sub_score_session)
%     mean_win_A = sub_score_session(i);
%     mean_win_B = partner_score_session(i);
%     diff_score = abs(mean_win_A - mean_win_B);
%     
%     event_fake_dist = session_fake_dist(:,i);
%     
%     %     % z transform
%     %     event_fake_dist = [event_fake_dist;diff_score];
%     %     event_fake_dist = zscore(event_fake_dist(~isnan(event_fake_dist)));
%     
%     UP = nanmean(event_fake_dist)+project.convergence.fakestd*nanstd(event_fake_dist);
%     LW = nanmean(event_fake_dist)-project.convergence.fakestd*nanstd(event_fake_dist);
%     
% %     if(diff_score <= LW || diff_score >= UP)
% %         %     if(diff_score <= LW)
% %         rare_event(i) = 1;
% %     end
%     
%     % # Combine the two datasets into a single dataset
%     % # i.e., under the null hypothesis, there is no difference between the two groups
%     combined = [diff_score;event_fake_dist];
%     % # Observed difference
%     diff.observed = mean(event_fake_dist) - mean(diff_score);
%     number_of_permutations = 1000;
%     diff.random = [];
%     for j=1:number_of_permutations
%         %     # Sample from the combined dataset without replacement
%         shuffled = datasample(combined, length(combined));
%         a.random = shuffled(1 : length(diff_score));
%         b.random = shuffled((length(diff_score) + 1) : length(combined));
%         %     # Null (permuated) difference
%         diff.random = [diff.random;mean(b.random) - mean(a.random)];
%         disp(j);
%     end
%     pvalue = sum(abs(diff.random) >= abs(diff.observed)) / number_of_permutations;
%     
%     if(pvalue <= 0.05)
%         %     if(diff_score <= LW)
%         rare_event(i) = 1;
%     end
%     
% %     A=[A;diff_score];B=[B;event_fake_dist];
% end

%%
%    
%  
% % # Combine the two datasets into a single dataset
% % # i.e., under the null hypothesis, there is no difference between the two groups
% combined = [A;B];
%  
% % # Observed difference
% diff.observed = mean(B) - mean(A);
%  
% number_of_permutations = 1000;
% 
% diff.random = [];
% for i=1 : number_of_permutations
%     
%     %     # Sample from the combined dataset without replacement
%     shuffled = datasample(combined, length(combined));
%     
%     a.random = shuffled(1 : length(A));
%     b.random = shuffled((length(A) + 1) : length(combined));
%     
%     %     # Null (permuated) difference
%     diff.random = [diff.random;mean(b.random) - mean(a.random)];
%     disp(i);
% end
% 
% % # P-value is the fraction of how many times the permuted difference is equal or more extreme than the observed difference
%  
% pvalue = sum(abs(diff.random) >= abs(diff.observed)) / number_of_permutations;
%     
%     
% 
% 





end