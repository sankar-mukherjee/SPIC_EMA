function f=plot_session_convergence_example(sub_score_session,partner_score_session,pre_sub,pre_partner,project,convergence_score,divergence,convergence_A,convergence_B,rare_event)

%% compute the upper and lower of the pretest distribution
UP_A = nanmean(pre_sub)+project.convergence.fakestd*nanstd(pre_sub);
LW_A = nanmean(pre_sub)-project.convergence.fakestd*nanstd(pre_sub);
UP_B = nanmean(pre_partner)+project.convergence.fakestd*nanstd(pre_partner);
LW_B = nanmean(pre_partner)-project.convergence.fakestd*nanstd(pre_partner);

project.convergence.subA_conv_threshold = LW_A;
project.convergence.subB_conv_threshold = UP_B;
project.convergence.subA_div_threshold = UP_A;
project.convergence.subB_div_threshold = LW_B;



%%
plot(sub_score_session,'.-b','MarkerSize',10);hold on;
plot(partner_score_session,'.-r','MarkerSize',10);

set(get(gca,'YLabel'),'String','LLR Score');
plot(get(gca,'xlim'), [project.convergence.subA_conv_threshold project.convergence.subA_conv_threshold],':b');
plot(get(gca,'xlim'), [project.convergence.subB_conv_threshold project.convergence.subB_conv_threshold],':r');
plot(get(gca,'xlim'), [project.convergence.subA_div_threshold project.convergence.subA_div_threshold],':b');
plot(get(gca,'xlim'), [project.convergence.subB_div_threshold project.convergence.subB_div_threshold],':r');
plot(get(gca,'xlim'), [0 0],'k');
set(gca,'ylim',[-6 6]);
set(gca,'xlim',[0 99]);
set(get(gca,'XLabel'),'String','Word Pairs')



%% shade areas

convergence_score = convergence_score;
divergence = divergence;
convergence_A = convergence_A;
convergence_B = convergence_B;

% convergence_score = convergence_score .* rare_event;
% divergence = divergence .* rare_event;
% convergence_A = convergence_A .* rare_event;
% convergence_B = convergence_B .* rare_event;

yLimits = get(gca,'YLim');
mar = 0.5;
for s=1:length(convergence_score)
    if(convergence_score(s))
        h1 = area([s-mar s+mar],[yLimits(1) yLimits(1)]);
        h2 = area([s-mar s+mar],[yLimits(2) yLimits(2)]);
        set(h1,'Facecolor','b')
        set(h2,'Facecolor','b')
        alpha(0.15);
    end
    if(divergence(s))
        h1 = area([s-mar s+mar],[yLimits(1) yLimits(1)]);
        h2 = area([s-mar s+mar],[yLimits(2) yLimits(2)]);
        set(h1,'Facecolor','r')
        set(h2,'Facecolor','r')
        alpha(0.15);
    end
    if(convergence_A(s))
        h1 = area([s-mar s+mar],[yLimits(1) yLimits(1)]);
        h2 = area([s-mar s+mar],[yLimits(2) yLimits(2)]);
        set(h1,'Facecolor','r')
        set(h2,'Facecolor','r')
        alpha(0.15);
    end
    if(convergence_B(s))
        h1 = area([s-mar s+mar],[yLimits(1) yLimits(1)]);
        h2 = area([s-mar s+mar],[yLimits(2) yLimits(2)]);
        set(h1,'Facecolor','g')
        set(h2,'Facecolor','g')
        alpha(0.15);
    end
end





end