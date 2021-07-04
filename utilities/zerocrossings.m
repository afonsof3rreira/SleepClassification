function [n] = zerocrossings(epoch)
%zerocrossings counts how many times the data in epoch crosses 0
n=0;
for i=1:length(epoch)-1
    if epoch(i)*epoch(i+1)<=0
        n=n+1;
    end
end
end

