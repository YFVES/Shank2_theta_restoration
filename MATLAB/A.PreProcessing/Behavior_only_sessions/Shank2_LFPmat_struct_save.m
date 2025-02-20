clear all;
close all;
clc;

main = cd;
files = dir('2021-*');
foldernames = char(files.name);

% 
% main = cd;
% files = dir; 
% foldernames = char(files.name);


% This matlab script is used to filter out noise in LFP.ncs files.
%  You need custom function 'CommonElemTol.m' in order to run this code.


for ii =  38%11:length(foldernames)
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);
    cd(files(ii).name);

    struct_name = foldern(1:19)

    load(struct_name,'-mat')

    if length(K.Event)>3
    %% Extraction of raw.ncs files
    A=dir('CSC*.ncs'); % get file directory of all RAW.ncs files (2 mice, 64 files, 32 files/mouse)

    mouse1 = [1 9 10 11 12 13 14 15];
    mouse2 = [16 2 3 4 5 6 7 8];


    %% I will store RAW1-64 ncs files into raw_signal, noise filtered signal into raw_signal_noise_filtered, timestamps into Timestamp
    %% ADMaxValue into ADMaxValue, InputRange into InputRange, SamplingFreq into SamplingFreq

    raw_signal=[];
    Timestamp=[];
    ADMaxValue=[];
    InputRange=[];
    SamplingFreq=[];

    %% A. Extract Timestamp

    % 1) Get event start and stop time of direct interaction 
    
    ts=[K.Event{1,4}(1,1),K.Event{1,4}(1,1)+600000000]; % 5 minutes * 60 seconds * 1000000 (in microseconds) = 300000000

    % 1) Get timestamp location (using Raw1.ncs file)

    Timestamps=[];%usec
    Samples=[];
    Header=[];

   
    if A(1).bytes ~=0
        [Timestamps, Samples, Header] = Nlx2MatCSC(A(1).name,[1 0 0 0 1],1, 1,[]);
    else
        [Timestamps, Samples, Header] = Nlx2MatCSC(A(2).name,[1 0 0 0 1],1, 1,[]);
    end


    % 3) Restrict Timestamp data to start and stop time
    tsloc=find(Timestamps>=ts(1,1) & Timestamps<=ts(1,2));
    Timestamps=Timestamps(tsloc(1,1):tsloc(1,end));

    % 4) organize timestamp data
    Timestamps=(Timestamps-Timestamps(1,1))/1000000; % convert to seconds


    for k=1:size(Timestamps,2)-1 
        temp=linspace(Timestamps(k),Timestamps(k+1),513);
        Timestamp(512*(k-1)+1:(512*(k-1)+512),1)=temp(1:512);
    end

    %% B. Organize neural data & plot raw trace for each tetrode

    for elec=1:16 % for 4 electrode in tet

        Timestamps=[];%usec
        Samples=[];
        Header=[];
        if A(elec).bytes == 0
            raw_signal(:,elec) = 0;
            continue
        else
        end

        [Timestamps, Samples, Header] = Nlx2MatCSC(A(elec).name,[1 0 0 0 1],1, 1,[]);

        Samples=Samples(:,tsloc(1,1):tsloc(1,end-1)); % restrict data to start and stop time

        for k=1:size(Samples,2)
            raw_signal((512*(k-1)+1):(512*(k-1)+512),elec)=Samples(:,k);
        end
%2020

%         ADMaxValue=str2num(cell2mat(regexp(Header{15,1},'[0-9]','match')));
%         InputRange=str2num(cell2mat(regexp(Header{21,1},'[0-9]','match')));
%         SamplingFreq=str2num(cell2mat(regexp(Header{14,1},'[0-9]','match')));

%2021 2023 
        ADMaxValue=str2num(cell2mat(regexp(Header{16,1},'[0-9]','match')));
        InputRange=str2num(cell2mat(regexp(Header{21,1},'[0-9]','match')));
        SamplingFreq=str2num(cell2mat(regexp(Header{15,1},'[0-9]','match')));

        raw_signal(:,elec)=raw_signal(:,elec)*InputRange/ADMaxValue; % convert to microvolts


    end


    raw_signal_final{1,1} = raw_signal(:,mouse1);
    raw_signal_final{1,2} = raw_signal(:,mouse2);

    save(strcat(K.date,'_LFP.mat'),"raw_signal_final","Timestamp","ADMaxValue","InputRange","SamplingFreq",'-v7.3')


    else
        
    end



    cd('F:\Dual interaction - sorted')
    % cd('H:\')
end




