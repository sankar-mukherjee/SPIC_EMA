function conv_ema=get_ema2(DATA,EMA,conv_idx_O,feat,flag_nan)

load('../linguistic/wordlist.mat');
A = wordlist{:,2};a=[];k=1;
for i=1:length(A)
    b = strsplit(A{i},'-');
    a{k,1} =b{1};
    a{k,2} = b{2};
    k=k+1;
end
syllable_list = unique(a);
original_wordList = [wordlist{:,1} a];

vowel_list = {'a','e','i','o','u','y','O','E','@','§','2'};
A=[];
for i=1:length(syllable_list)
    a = syllable_list{i};
    b = regexp(a,vowel_list,'once');
    b = find(~cellfun(@isempty,b));
    syllable_list{i,2} = b;
end
%%









rrrr= [1 3 4];
IDX=[];
cx1=5;cx2=5;


idx = cell2mat(DATA.EMA.EMA.onset(conv_idx_O));
conv_ema = EMA(conv_idx_O);
A = [];
for i=1:length(idx)
    if not(idx(i,1)-idx(i,2)==0)
        %% ema jaw features
        b = DATA.D.WORD{idx(i,1)};        
        b = find(ismember(original_wordList(:,1),b));
        b = original_wordList(b,2:end);
        b = [find(ismember(syllable_list(:,1),b(1))) find(ismember(syllable_list(:,1),b(2)))];
        b = [syllable_list{b(1),2} syllable_list{b(2),2}];
        
        
        if(sum(ismember(rrrr,b)))
        IDX = [IDX;conv_idx_O(i,1)];
        if(feat==7 || feat==8 || feat==9)
            
            if(idx(i,2)+cx2>=length(conv_ema{i}))
                y = length(conv_ema{i});
            else
                y=idx(i,2)+cx2;
            end
            X=conv_ema{i}(idx(i,1)-cx1:y,:);
            aa = X(:,7);
            aa = aa-aa(1);
            %             aa = [0 0 0 aa' 0 0 0];
            %             plot(aa)
            [a,b]= findpeaks(aa,'NPeaks',2,'MinPeakDistance',5);
            b = (b-cx1)*0.01;
            
            if(~isempty(a) && min(aa)>=-3)
                if(feat==7)
                    A{i,1} = [mean(abs(a))];    %mean jaw max opening
                elseif(feat==8)
                    A{i,1} = [abs(a(1))];    %mean jaw max opening
                elseif(feat==9 && length(a)==2)
                    A{i,1} = [abs(a(2))];    %mean jaw max opening
                else
                    A{i,1} = NaN;
                end
            else
                A{i,1} = NaN;
            end
        else
            
            if(idx(i,2)>=length(conv_ema{i}))
                y = length(conv_ema{i});
            else
                y=idx(i,2);
            end
            X=conv_ema{i}(idx(i,1):y,:);
            A{i,1} = nanmean(X(:,feat));
        end
        end
    end
end
% conv_idx_O=IDX;
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
                    x=nan(1,6);
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