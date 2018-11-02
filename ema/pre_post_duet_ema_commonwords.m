%% pre post ema change
clear;clc;

DATA = [];
DATA.D = load(['..\data\processed_data_idx.mat']);
DATA.EMA = load(['..\data\processed_data_EMA.mat']);

features= { 'jawaopening'    'lipaparature'    'lipProtrusion'    'TTCD'    'TDCD'    'TBCD'};

%%
value = nan(10,6,length(features));sub_P=nan(10,3,length(features));
for sub=1:10
    pre =  find(DATA.D.D(:,1)==sub & DATA.D.D(:,2)==1);
    pre_word = DATA.D.WORD(pre);
    post = find(DATA.D.D(:,1)==sub & DATA.D.D(:,2)==8);
    duet = find(DATA.D.D(:,1)==sub & DATA.D.D(:,2)~=1 & DATA.D.D(:,2)~=8);
    duet_word = DATA.D.WORD(duet);
    a = find(ismember(duet_word,pre_word));
    duet = duet(a);
    
    for ff=1:length(features)
        pre_ema =get_ema_pre_post_duet(DATA,pre,ff);
        post_ema =get_ema_pre_post_duet(DATA,post,ff);
        duet_ema =get_ema_pre_post_duet(DATA,duet,ff);
        value(sub,:,ff) = [nanmean(pre_ema) nanmean(post_ema) nanmean(duet_ema) nanstd(pre_ema) nanstd(post_ema) nanstd(duet_ema)];
        
        [a,b] = ttest2(pre_ema,post_ema);
        sub_P(sub,1,ff) = b;
        [a,b] = ttest2(pre_ema,duet_ema);
        sub_P(sub,2,ff) = b;
        [a,b] = ttest2(duet_ema,post_ema);
        sub_P(sub,3,ff) = b;
    end
end
project.subjects.plot_markers = {'-b','-.b','-r','-.r','-k','-.k','-c','-.c','-m','-.m'};

P=zeros(length(features),3);
for ff=1:length(features)
    A = squeeze(value(:,:,ff));
    A = A(:,1:3);
    [x,b] = find(isnan(A));
    A(x,:)=[];
    
    [a,b] = ttest(A(:,1),A(:,2));
    P(ff,1) = b;
    [a,b] = ttest(A(:,1),A(:,3));
    P(ff,2) = b;
    [a,b] = ttest(A(:,2),A(:,3));
    P(ff,3) = b;
    
    A = zscore(A);
    p = squeeze(sub_P(:,:,ff));
    p(x,:)=[];
    
        
    A = A ./ A(:,1);       %for plotiing purpose
    
    
    figure
    hold on
    for sub=1:10
        plot(1:2,A(sub,[1 2]),project.subjects.plot_markers{sub});
    end
    xlim([0.7 2.3])
    title('Pre VS Post common words')
    legend(name_legend,'Location','SouthWest')
end



