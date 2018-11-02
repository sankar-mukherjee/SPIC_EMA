%% convergence
clear;clc;close all;
gmm_settings = 'GMM_scores_256_10_mwv_mfc_raw';
%%

project.subjects.name = {'stella','juliet','shai','ayoub','lucas','simone','henry', 'julien','marion','elvira'}; %gmmscores order based on this order
project.subjects.group = {'stella','juliet';'shai','ayoub';'lucas','simone';'henry', 'julien';'marion','elvira'};
project.subjects.gender = {'f','f','m','m','m','m','m','m','f','f'};
project.subjects.speak = [1 2 1 2 1 2 1 2 1 2];
project.subjects.groupspeak = [1 2; 1 2; 1 2; 1 2; 1 2];

project.convergence.fakestd   = 2;

load(['../gmm_ubm/data/' gmm_settings '.mat'],'gmmScores');

%%
converge = [];
converge.convergence_score = [];
converge.divergence = [];
converge.convergence_A = [];
converge.convergence_B = [];
converge.rare_event = [];
converge.idx = [];

fake_dist = get_fake_dist(gmmScores,project);

for g=1:length(project.subjects.group)
    
    sub = find(ismember(project.subjects.name,project.subjects.group(g,1)));
    partner = find(ismember(project.subjects.name,project.subjects.group(g,2)));
    
    sub_score = gmmScores.speakerDependent_Scores{sub};
    partner_score = gmmScores.speakerDependent_Scores{partner};
    
%    % zscore transform 
%     A = zscore(cell2mat(sub_score));    A = [A;zscore(cell2mat(partner_score))];
%     j=1;k=420;
%     for z=1:8
%         if(z==1||z==8)
%             sub_score{z} = A(j:j+59);          partner_score{z} = A(k:k+59);j=j+50;k=k+50;
%         else
%             sub_score{z} = A(j:j+49);           partner_score{z} = A(k:k+49);j=j+50;k=k+50;
%         end
%     end
    
    pre_sub = sub_score{1};    pre_partner = partner_score{1};
    
    FigHandle1 = figure('Position', [100, 100, 1366, 1300]);
    
    for session=2:7
        A = manage_sequence(session-1);
        if(session<5)
            B = project.subjects.groupspeak(g,:);
        else
            B = [project.subjects.groupspeak(g,2) project.subjects.groupspeak(g,1)];
        end
        
        sub_score_session = sub_score{session};        partner_score_session = partner_score{session};
        sub_score_session = sub_score_session(A(:,B(1)));        partner_score_session = partner_score_session(A(:,B(2)));
        
        session_fake_dist = fake_dist(:,session-1);
        
        [convergence_score,divergence,convergence_A,convergence_B,rare_event] = convergence_condition(sub_score_session,partner_score_session,pre_sub,pre_partner,session_fake_dist,project);
        
        converge.convergence_score{g,session-1} = convergence_score;
        converge.divergence{g,session-1} = divergence;
        converge.convergence_A{g,session-1} = convergence_A;
        converge.convergence_B{g,session-1} = convergence_B;
        converge.rare_event{g,session-1} = rare_event;
        converge.idx{g,session-1} = B;

        %%
        subplot(6,1,session-1)
        plot_session_convergence_example(sub_score_session,partner_score_session,pre_sub,pre_partner,project,convergence_score,divergence,convergence_A,convergence_B,rare_event);
        title(num2str(session-1))        
    end
    
    h1 = area(NaN,NaN,'Facecolor','b');
    h2 = area(NaN,NaN,'Facecolor','r');
    h3 = area(NaN,NaN,'Facecolor','g');
    h4 = area(NaN,NaN,'Facecolor','w');
    alpha(0.15);
    
    h5 = plot(NaN,NaN,'.-b','MarkerSize',10);
    h6 = plot(NaN,NaN,'.-r','MarkerSize',10);
    
    hL = legend([h1 h2 h3 h4 h5 h6],{'Convergence','Convergence A', 'Convergence B','NoChange','Speaker A','Speaker B'},'Orientation','horizontal','FontSize',10);
    set(hL,'Position', [0.5 0.025 0.005 0.0009]);
    
    suptitle(cell2mat(project.subjects.group(g,:)));
    saveas(FigHandle1,['figs\' cell2mat(project.subjects.group(g,:)) '_convergence_' gmm_settings '.tif']);
    close all;
    disp(g)
end




save(['mat\convergence_' gmm_settings '.mat'],'converge');










