clear all;
close all;
clc;

main = cd;
files = dir('2024-*');
foldernames = char(files.name);



% This matlab script is used to filter out noise in LFP.ncs files.
%  You need custom function 'CommonElemTol.m' in order to run this code.


for ii =  35:size(foldernames,1)
    foldern = foldernames(ii,:)
    struct_name = foldern(1:19);
    cd(files(ii).name);

  

    [Timestamps,TTL, EventStrings] = Nlx2MatEV('Events.nev', [1 0 1 0 1], 0, 1, [] );

   
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
    
    ts=[Timestamps(1,3),Timestamps(1,4)]; % 15 minutes * 60 seconds * 1000000 (in microseconds) = 900000000

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


        ADMaxValue=str2num(cell2mat(regexp(Header{16,1},'[0-9]','match')));
        InputRange=str2num(cell2mat(regexp(Header{21,1},'[0-9]','match')));
        SamplingFreq=str2num(cell2mat(regexp(Header{15,1},'[0-9]','match')));

        raw_signal(:,elec)=raw_signal(:,elec)*InputRange/ADMaxValue; % convert to microvolts


    end


    raw_signal_final{1,1} = raw_signal(:,mouse1);
    raw_signal_final{1,2} = raw_signal(:,mouse2);

    save(strcat(struct_name,'_LFP.mat'),"raw_signal_final","Timestamp","ADMaxValue","InputRange","SamplingFreq",'-v7.3')






    cd(main)
end




