


%%
effort_threshold = 1;
tolarence = 0.009;
feature = 7;

a = find(data(:,3)>1);
b = find(data(:,3)<8);
a = intersect(a,b);
duet_data = data(a,:);
duet_score = find(duet_data(:,feature)<=effort_threshold+tolarence & duet_data(:,feature)>=effort_threshold-tolarence);
A = duet_data(duet_score,1:2);


[A_unique,~,u_id] = unique(A, 'rows'); % // find unique rows and their unique id
occurrences = histc(u_id, unique(u_id)); % // count occurrences of unique ids

A = zeros(1,10);
for sub = 1:10
    a = find(ismember(A_unique(:,1),sub));    
    A(sub) = sum(occurrences(a));    
end

A = A/300;
figure;bar(A)


a = duet_data(:,[1 8]);


%% noel suggestion common word in 3 score
load('..\behaviour\behaviour.mat','words');

common_words_score = zeros(10,2,60,3);
ref_word = words{1,1};
for i=1:length(data)
    sub= data(i,1);
    session = data(i,3);
    w = data(i,4);
    
    A = words{sub,session}(w);
    
    a = find(ismember(ref_word,A));
    if not(isempty(a))
        if(session == 8)
            session = 3;
        elseif(session >1 && session <8)
            session=2;
        end
        common_words_score(sub,1,a,session) = data(i,5);
        common_words_score(sub,2,a,session) = data(i,6);
    end
end


%% within group 
a = squeeze(mean(common_words_score,3));
own_score = squeeze(a(:,1,:));
parner_score = squeeze(a(:,2,:));


R = abs(own_score);
% R = abs(parner_score);

C = combnk([1:3],2);
p = zeros(length(C),1);
groups = [];
for i=1:length(C)
    [h,p(i),ci,stats] = ttest2(R(:,C(i,1)),R(:,C(i,2)));
    groups{i} = C(i,:);
end
a = find(p<=0.05);
H=bar(mean(R));
hold on;
errorbar(1:3,mean(R),std(R),'color','k','linestyle','none');
set(H,'FaceColor',[0.5,0.5,0.5])
H=sigstar(groups(a),p(a),1);
title({'Session avg LLR score (computed on its own model, common words)' , 't-test with significance (p<0.05)',config});
set(gca, 'XTick', 1:3, 'XTickLabel', {'Pre','Duet','Post'});
ylabel('LLR score [positive]')
saveas(gca,['figs\session_avg_LLR_ownModel_commonWords' config '.tif'])


%% within subject own model
A = squeeze(common_words_score(:,1,:,:));
own_score=[];
for i=1:10
    a = squeeze(A(i,:,:));
    [maxNum, maxIndex] = max(a(:));
    [row, col] = ind2sub(size(a), maxIndex);
    a(row,:) =[];
%     b=find(a(:)==0);
%     a(b)=NaN;
    own_score{i,1} = a;
end



figure;
for sub=1:10
    R = abs(own_score{sub});
    
    
    C = combnk([1:3],2);
    p = zeros(length(C),1);
    groups = [];
    for i=1:length(C)
        [h,p(i),ci,stats] = ttest2(R(:,C(i,1)),R(:,C(i,2)));
        groups{i} = C(i,:);
    end
    a = find(p<=0.05);
    
    subplot(5,2,sub)
    H=bar(mean(R));
    hold on;
    errorbar(1:3,nanmean(R),nanstd(R),'color','k','linestyle','none');
    set(H,'FaceColor',[0.5,0.5,0.5])
    H=sigstar(groups(a),p(a),1);
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Pre','Duet','Post'});
    ylabel('LLR score [positive]')
    title(num2str(sub))
end
title({'Session avg LLR score (computed on its own model, common words)' , 't-test with significance (p<0.05)',config});


saveas(gca,['figs\subj_avg_LLR_ownModel_commonWords' config '.tif'])







