function fake_dist = get_fake_dist(gmmScores,project)

a = gmmScores.fake_group_combination_gender;
combos = gmmScores.fake;
groups = gmmScores.fake_group_combination;

% if(gender == 1)    
%     gender = project.subjects.gender{find(ismember(project.subjects.name,current_comb(1)))};
%     if(strcmp(gender,'m'))
%         id = find(all(ismember(a,{'m' 'm'}),2)==0);
%         combos(id,:) = [];        groups(id,:) = [];
% 
%     else
%         id = find(all(ismember(a,{'f' 'f'}),2)==0);
%         combos(id,:) = [];        groups(id,:) = [];
% 
%     end    
% end

[a,b] =ismember(groups,project.subjects.name);
speaker = project.subjects.speak(b);

a = speaker(:,1)-speaker(:,2);
a = find(a==0);
combos(a,:) = [];  
groups(a,:) = [];
speaker(a,:) = [];

fake_dist=[];
for g=1:length(groups)
    
    for session =2:7
        fake_dist{g,session-1} = manage_sequence_fake(speaker(g,:),combos(g,:),session);        
    end
    
end


end