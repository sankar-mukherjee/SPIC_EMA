function conv_ema=get_ema_other_feat(DATA,EMA,conv_idx_O,feat,flag_nan)

idx = cell2mat(DATA.EMA.EMA.onset(conv_idx_O));
conv_ema = EMA(conv_idx_O);
A = [];
for i=1:length(idx)
    if not(idx(i,1)-idx(i,2)==0)
        if(idx(i,2)>=length(conv_ema{i}))
            y = length(conv_ema{i});
        else
            y=idx(i,2);
        end
        
        
        a = conv_ema{i}(idx(i,1)-4:y,1);
        
        
        %% ema jaw features
        aa = a-a(1);
        aa = [0 0 0 aa' 0 0 0];
        %         plot(a)
        [a,b]= findpeaks(aa,'NPeaks',2);
        b = (b-6)*0.01;
        
        if(~isempty(a) && min(aa)>=0)
            if(feat==1)
                A{i,1} = [mean(abs(a))];    %mean jaw max opening
            elseif(feat==2)
                A{i,1} = [abs(a(1))];    %mean jaw max opening
            elseif(feat==3 && length(a)==2)
                A{i,1} = [abs(a(2))];    %mean jaw max opening
            else
                 A{i,1} = NaN;
            end
        else
            A{i,1} = NaN;
        end
    end
end

conv_ema=[];
for sub=1:10
    a = find(DATA.D.D(conv_idx_O,1)==sub);
%     b = find(cellfun(@isempty,A(a)));
    
    if not(isempty(a))
        if(flag_nan)
            a = cell2mat(A(a));
            a(isnan(a))=[];
        else
            aa=[];
            for i=1:size(a,1)
                x = A{a(i)};
                if(isempty(x))
                    x=NaN;
                end
                aa = [aa;x];
            end
            if not(isempty(aa))
                a=aa;
            else
                a=[];
            end
        end
    end
    conv_ema{sub,1} = a;
    
end


end