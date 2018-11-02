function ema_data = get_emaData(D,DATA,idx,ema_feat,zero_pad)

sub = D(idx,1);
session = D(idx,3);
word = D(idx,4);
ID = [sub session word];
ID = sortrows(ID,1);

ID_original = DATA.D.D;

ema_data = [];
for sub=1:10
    a = find(ID(:,1)==sub);
    index_A = ID(a,:);
    [~,a,~] = intersect(ID_original,index_A,'rows');
    
    idx = cell2mat(DATA.EMA.EMA.onset(a));
    
    if(strcmp(ema_feat,'ema_lip'))
        
        pad_data = zeros(zero_pad,5);
        
        A = DATA.EMA.EMA.lip(a);
        B = [];
        for ii=1:length(a)
            if(zero_pad)
                B{ii,1} = [pad_data; A{ii}(idx(ii,1):idx(ii,2),:); pad_data];
            else
                B{ii,1} = A{ii}(idx(ii,1):idx(ii,2),:);
            end
        end
        
    elseif(strcmp(ema_feat,'ema_velocity'))
        pad_data = zeros(zero_pad,14);
        
        A = DATA.EMA.EMA.raw(a);
        B = [];
        for ii=1:length(a)
            aa = diff(A{ii});
            
            if(idx(ii,2)>=length(aa))
                y = length(aa);
            else
                y=idx(ii,2);
            end
            
            if(zero_pad)
                B{ii,1} = [pad_data; aa(idx(ii,1):y,:); pad_data];
            else
                B{ii,1} = aa(idx(ii,1):y,:);
            end
        end
    elseif(strcmp(ema_feat,'ema_accelaration'))
        pad_data = zeros(zero_pad,14);
        
        A = DATA.EMA.EMA.raw(a);
        B = [];
        for ii=1:length(a)
            aa = diff(diff(A{ii}));
            
            if(idx(ii,2)>=length(aa))
                y = length(aa);
            else
                y=idx(ii,2);
            end
            
            if(zero_pad)
                B{ii,1} = [pad_data; aa(idx(ii,1):y,:); pad_data];
            else
                B{ii,1} = aa(idx(ii,1):y,:);
            end
        end
    end
    ema_data{sub,1} = cell2mat(B);
end



end









