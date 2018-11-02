function [combos,gender] = generate_fakeduets_new(project)
%% fake group generation

combos = nchoosek(project.subjects.name,2);
% id = find(all(ismember(combos,current_comb),2));
% combos(id,:) = [];

[a,b] =ismember(combos,project.subjects.name);
gender = project.subjects.gender(b);



    
    %% remove real ones
    for i=1:length(project.subjects.group)
        id = find(all(ismember(combos,project.subjects.group(i,:)),2));
        combos(id,:) = [];        gender(id,:) = [];

    end
    
end