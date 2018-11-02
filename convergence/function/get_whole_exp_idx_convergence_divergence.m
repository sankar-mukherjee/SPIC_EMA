function [seq,seq_idx,seq_only] = get_whole_exp_idx_convergence_divergence(data,project,feat,feature_value)

seq = [];seq_idx=[];seq_only=[];
for g=1:length(project.subjects.group)
    sub = find(ismember(project.subjects.name,project.subjects.group(g,1)));
    partner = find(ismember(project.subjects.name,project.subjects.group(g,2)));
    
    AA = [sub partner];
    
    sub_score = data(find(data(:,1)==sub),:);
    partner_score = data(find(data(:,1)==partner),:);
    
    
    for session=2:7
        a = find(sub_score(:,3) == session);
        A = sub_score(a,[4 feat]);
        a = find(partner_score(:,3) == session);
        B = partner_score(a,[4 feat]);
        
        [seq{g,session-1},idx,seq_only{g,session-1}] = manage_sequence(A,B,session,project.subjects.speak(sub),feature_value);
        
        T = nan(1,length(idx));
        for t=1:length(idx)
            a = find(data(:,1)==AA(idx(t,1)) & data(:,3)==session & data(:,4)==idx(t,2));
            if not(isempty(a))
                T(t) = a;
            end
        end
        seq_idx{g,session-1} = T;
    end
    
end

end