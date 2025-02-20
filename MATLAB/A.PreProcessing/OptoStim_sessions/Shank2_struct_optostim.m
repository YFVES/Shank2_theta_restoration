close all; clc; clearvars;

%Code written by Eunkyu Hwang
%Last edited: July 6th, 2022
%make sure the order of channels are correct (color of tether, yellow can
%be 1-32 in some cases

main = cd;
files = dir('2024-*');
foldernames = char(files.name);


%Fs = 2000; %sampling frequency 2020 LFP
Fs = 1875; %sampling frequency 2021 LFP

%Get subject information and trial information
for ii = 1:length(foldernames)
    K = struct;
    foldern = foldernames(ii,:)

    %Trial information
    %%K.date = trial time
    %%K.ID = trial subject/trial type
    %%WT-WT : 1 / KO-KO : 2 / WT-KO : 3
    K.date = foldern(1:19);
    K.ID {1,1} = foldern(21:24); %LFP channels 1-8
    K.ID {1,2} = foldern(26:29);   %LFP channels 9-16

    genotype1 = foldern(23:24);
    genotype2 = foldern(28:29);

    trialtype = strcmp (genotype1, genotype2);

    if trialtype == 1
        tf = strcmp(genotype1, 'WT');
        if tf == 1
            K.ID {1,3} = 1;
        else
            K.ID{1,3} = 2;
        end
    else
        K.ID{1,3} = 3;
    end

    cd(foldern);
    %Trial timestamp
    Timestamps=[];
    %TTL=[];
    EventStrings=[];

    [Timestamps,TTL, EventStrings] = Nlx2MatEV('Events.nev', [1 0 1 0 1], 0, 1, [] );

   

    if length(Timestamps) == 4
        DirectInteraction_ts =[Timestamps(3),Timestamps(4)];


        K.Event {:,4} = DirectInteraction_ts';


    else
        DirectInteraction_ts =[Timestamps(1),Timestamps(2)];


        K.Event {:,4} = DirectInteraction_ts';
    end







    clear K.SPK
    %% K.SPK = spike timing
    fn=FindFiles('*.t64');
    if length(fn)>=1 % if there is isolated neuron

        for x=1:length(fn)
            filename = fn(x);
            tt_filename = filename{1,1};

            if length(tt_filename) == 67
                tt_number = str2num(tt_filename(end-7));
                if tt_number <9
                    S=LoadSpikes(fn(x));
                    K.SPK{x,1}=S{1,1}.T;
                else
                    S=LoadSpikes(fn(x));
                    K.SPK{x,2}=S{1,1}.T;
                end
            else
                S=LoadSpikes(fn(x));

                K.SPK{x,2}=S{1,1}.T;
            end
        end


    else

        % if there is no isolated neuron
        K.SPK={};


    end

    K.SPK_Raw = K.SPK(~cellfun('isempty',K.SPK));



    save(K.date, 'K');
    cd(main);
end

