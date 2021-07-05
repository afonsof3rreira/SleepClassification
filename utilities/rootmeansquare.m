function [n] = rootmeansquare(epoch)
%rootmeansquare yields the root mean square of the epoch
n=0;
for i=1:length(epoch)
    n=n+(epoch(i))^2;
end
n=sqrt(n/length(epoch));
end
