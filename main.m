warning('off','all')
% save edf files and txt files in separate directories as below
Files_edf=dir('./Files_edf');
Files_txt=dir('./Files_txt');

i=1;
for k=1:length(Files_edf)
    if Files_edf(k).bytes>0
        FileNames_edf{i}=(Files_edf(k).name);i=i+1;
    end
end

i=1;
for k=1:length(Files_txt)
    if Files_txt(k).bytes>0
        FileNames_txt{i}=(Files_txt(k).name);i=i+1;
    end
end

%% DO NOT RUN IF YOU DONT HAVE MEMORY 
% MAYBE JUST RUN 1 AT A TIME

signal=cell(5,1);
signal_header=cell(5,1);
for i=1:length(FileNames_edf)
    [header,channels]=edfread(FileNames_edf{i});
    disp("file "+i+" of 5 done")
    signal{i}=channels;
    signal_header{i}=header;
end

%% 
n1 = signal_header{1};
save('n1.mat','n1')
n2 = signal_header{2};
save('n2.mat','n2')
n3 = signal_header{3};
save('n3.mat','n3')
n5 = signal_header{4};
save('n5.mat','n5')
n11 = signal_header{5};
save('n11.mat','n11')

%% Read txt
% turn txts into column vector
sleepstages=[];
for i=1:length(FileNames_txt)
    ss = txt_to_stages(FileNames_txt{i});
    sleepstages=[sleepstages;ss];
    disp(i+"/"+length(FileNames_txt)+" done")
end










