function [sleepstages] = txt_to_stages(name)
% Turn the txt files into the sleepstages file with epochs of 30s
% sleepstages is a column vector
% W=5
% S1=4
% S2=3
% S3=2
% S4=1
% REM=0
T = readtable(name);
if width(T)==8
    eventcolumn=6;
elseif width(T)==6
    eventcolumn=5;
else
    eventcolumn=4;
end

j=1;
    for i=1:height(T)
        if T{i,eventcolumn}==30
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

sleepstages=sleepstages'; %make a column vector

end

