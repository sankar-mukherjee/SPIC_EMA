function data=get_convScore(Score_data,conv_idx_O,cond,modify)

A = Score_data(conv_idx_O,8);


data=[];
for sub=1:10
    a = find(Score_data(conv_idx_O,1)==sub);
    a = A(a);
    a(isnan(a))=[];
    
    if(cond)            %change convergence score for the average space negative to positive 
        a=abs(a);
    end
    if(modify)          %format convergence score by substracting 1 
        for i=1:length(a)
            if(a(i)>0)
                a(i) = a(i)-1;
            elseif(a(i)<0)
                a(i) =  a(i)+1;
            end
        end
    end
    data{sub,1} = a;
    
end

end