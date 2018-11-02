function z = manage_sequence(session)


%% construct sequence
x = 1:50;
j=1;
z = zeros(99,2);
for i=1:2:99
    z(i,1) = x(j);
    z(i,2) = x(j);
    
    if(i ~=99)
        z(i+1,1) = x(j);
        z(i+1,2) = x(j+1);
    end
    j=j+1;
end

%% arrange word pair combination per session
if(session <= 3)
    z = [z(:,2) z(:,1)];
else
    z = z;
end

end