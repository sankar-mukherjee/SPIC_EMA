function IDX = get_original_index(D,DATA,idx)

sub = D(idx,1);
session = D(idx,3);
word = D(idx,4);
ID = [sub session word];
% ID = sortrows(ID,1);
ID_original = DATA;
ID_original = ID_original(:,1:3);
% %% keeping the exact order of ID
IDX = nan(size(ID,1),1);
for i=1:size(ID,1)
    index_A = ID(i,:);
    [~,a,~] = intersect(ID_original,index_A,'rows');
    if not(isempty(a))
        IDX(i) = a;
    end
end




%% no missing
% [a,IDX,c] = intersect(ID_original,ID,'rows');

end