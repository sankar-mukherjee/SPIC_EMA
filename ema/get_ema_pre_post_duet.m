function conv_ema=get_ema_pre_post_duet(DATA,conv_idx_O,feat)


idx = cell2mat(DATA.EMA.EMA.onset(conv_idx_O));
conv_ema = DATA.EMA.EMA.lip(conv_idx_O);
A = [];
for i=1:length(idx)
    if not(idx(i,1)-idx(i,2)==0)
        if(idx(i,2)>=length(conv_ema{i}))
            y = length(conv_ema{i});
        else
            y=idx(i,2);
        end
        A{i,1} = nanmean(conv_ema{i}(idx(i,1):y,:));
    end
end

conv_ema=cell2mat(A);
conv_ema = conv_ema(:,feat);
a = find(isnan(conv_ema));
conv_ema(a)=[];
end