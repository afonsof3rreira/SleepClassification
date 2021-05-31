function [sleepstages] = txt_to_stages(name)
% Turn the txt files into the sleepstages file with epochs of 30s
% W=5
% S1=4
% S2=3
% S3=2
% S4=1
% R=0
T = readtable(name,'Format','%s%s%s%u%s');
j=1;
for i=1:height(T)
    if T{i,4}==30
        if T{i,1}=="W"
            sleepstages(j)=5;j=j+1;
        elseif  T{i,1}=="S1"
            sleepstages(j)=4;j=j+1;
        elseif T{i,1}=="S2"
            sleepstages(j)=3; j=j+1;
        elseif T{i,1}=="S3"
            sleepstages(j)=2;j=j+1;
        elseif T{i,1}=="S4"
            sleepstages(j)=1; j=j+1;
        elseif T{i,1}=="R"
            sleepstages(j)=6;j=j+1;
        end
    end
end
end

