function diff_score = manage_sequence_fake(speaker,combos,session)

z = manage_sequence(session);


if(speaker(1)==2)
    sub_score_session = combos{1,2}{session-1,1};
    partner_score_session = combos{1,1}{session-1,1};
else
    sub_score_session = combos{1,1}{session-1,1};
    partner_score_session = combos{1,2}{session-1,1};
end


sub_score_session = sub_score_session(z(:,1));
partner_score_session = partner_score_session(z(:,2));

diff_score = nan(1,length(sub_score_session));

for i=1:length(sub_score_session)
    mean_win_A = sub_score_session(i);
    mean_win_B = partner_score_session(i);
    
    diff_score(i) = abs(mean_win_A - mean_win_B);

end



end