function data = effort_score_compute(score_order,score_value,pre_sub_score_model_dist,pre_partner_score_model_dist,pre_other_score_model_dist,threshold,flag)
%{
XBA    %divergence
XAB

AXB    %nochange but with thresholding can be divergent or convergent
ABX

BAX    %convergent
BXA

X = background model
A = own model
B = partner model
%}

%%
data = zeros(1,6);    %convergence,divergence,nochange, noch->div,noch->con, convergece_score/effortScore

%%
A = score_value(1); B = score_value(2); X = score_value(3); % assign values
Y = [A B X];
if(strcmp(flag,'mean'))
    Z = [A B X] ./ [mean(pre_sub_score_model_dist) mean(pre_partner_score_model_dist) mean(pre_other_score_model_dist)];
    LO = mean(pre_sub_score_model_dist)-threshold*std(pre_sub_score_model_dist);
    UP = mean(pre_sub_score_model_dist)+threshold*std(pre_sub_score_model_dist);
elseif(strcmp(flag,'median'))
    Z = [A B X] ./ [median(pre_sub_score_model_dist) median(pre_partner_score_model_dist) median(pre_other_score_model_dist)];
    LO = median(pre_sub_score_model_dist)-threshold*std(pre_sub_score_model_dist);
    UP = median(pre_sub_score_model_dist)+threshold*std(pre_sub_score_model_dist);
end
Z = Z(score_order);
Y = Y(score_order);

%%
if(score_order(1)==3) %divergence XBA XAB
    data(2) = 1;
    data(6) = -Z(1);  %make it negative
elseif(score_order(1)==2) %convergent BAX BXA
    data(1) = 1;
    data(6) = Z(1);   %make it positive
else                  %nochange
    A_z = Y(1);
    
    if(score_order(2)==3)               %AXB  divergence/nochange
        %         if(abs(Z)>threshold)
        if(A_z(1) <= LO)    %noch->div (bad fit so more inclined towards X)
            data(4) = 1;
        else
            data(3) = 1;
        end
        data(6) = -Z(1);
    else                                %ABX  convergent/nochange
        %         if(abs(Z)>threshold)
        if(A_z(1) <= LO)    %noch->con (bad fit so more inclined towards B)
            data(5) = 1;
        else
            data(3) = 1;
        end
        data(6) = Z(1);
    end
end




end