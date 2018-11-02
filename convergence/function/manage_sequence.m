function [seq,seq_idx,seq_only] = manage_sequence(A,B,session,speak_first,feature_value)

%% arrange word pair combination per session
if((session < 5 && speak_first ==1) || (session > 4 && speak_first ==2))
    z = 1;
elseif((session > 4 && speak_first ==1) || (session < 5 && speak_first ==2))
    z = 2;
end


%% construct sequence
AA = nan(50,size(A,2)-1);
BB = AA;

AA(A(:,1),:) = A(:,[2:end]);
BB(B(:,1),:) = B(:,[2:end]);


a = AA(:,end);b=BB(:,end);
AA=AA(:,1:end-1);BB=BB(:,1:end-1);

%%
for feature=1:size(AA,2)
    AA(:,feature) = AA(:,feature) .*feature_value(feature);
    BB(:,feature) = BB(:,feature) .*feature_value(feature);
end
AA = sum(AA,2);BB=sum(BB,2);

X = nan(1,100);
XX=X;
seq_idx = nan(100,2);

if(z==1)
    X(1:2:end) = AA;
    X(2:2:end) = BB;
    
    XX(1:2:end) = a;
    XX(2:2:end) = b;
    
    seq_idx(1:2:end,1) = 1;seq_idx(2:2:end,1) = 2;    seq_idx(1:2:end,2) = 1:50;seq_idx(2:2:end,2) = 1:50;
    
else
    X(1:2:end) = BB;
    X(2:2:end) = AA;
    
    XX(1:2:end) = b;
    XX(2:2:end) = a;
    
    seq_idx(1:2:end) = 2;seq_idx(2:2:end) = 1;seq_idx(1:2:end,2) = 1:50;seq_idx(2:2:end,2) = 1:50;
end

conv=ones(1,length(XX));
for i=2:length(XX)-1
    if(XX(i)==XX(i+1))
        conv(i) = feature_value(1);
        conv(i+1) = feature_value(1);
    elseif(XX(i)==XX(i-1))
        conv(i) = feature_value(1);
        conv(i-1) = feature_value(1);
    end
end

seq_only = X;

%% if two in subsequent turn the speech has a closer value towards a same model which means they are approching to same accoustic space the both of them are convergent
seq = X .* conv;
a = find(seq>feature_value(1));
seq(a) = feature_value(1);


end

















