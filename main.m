%isto é um teste para ver se consigo alterar cenas no projeto
clear all

Files=dir('./');
i=1;
for k=1:length(Files)
    if Files(k).bytes>160000000
        FileNames{i}=(Files(k).name);
        i=i+1;
    end
end
%% DO NOT RUN IF YOU DONT HAVE MEMORY

signal=cell(28,1);
signal_header=cell(28,1);

for i=1:length(FileNames)
    [header,channels]=edfread(FileNames{i});
    disp("file "+i+" of 28 done")
    signal{i}=channels;
    signal_header{i}=header;
end
%% Read txt
% turn txt into table
T = readtable('narco1.txt','Format','%s%s%s%u%s');
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
