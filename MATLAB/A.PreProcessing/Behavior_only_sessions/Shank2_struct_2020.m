close all; clc; clearvars;

%Code written by Eunkyu Hwang
%Last edited: July 6th, 2022
%make sure the order of channels are correct (color of tether, yellow can
%be 1-32 in some cases

main = cd;
files = dir('2020-*');
foldernames = char(files.name);


Fs = 2000; %sampling frequency 2020 LFP


%Get subject information and trial information
for ii = 1%:length(foldernames)
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

    K.ID {1,4} = length(Timestamps);

    %time stamp for each behavior test

    DirectInteraction_ts =[Timestamps(7),Timestamps(8)];
    TubeTest_ts = [Timestamps(5),Timestamps(6)];
    %         OpenField1_ts = [Timestamps(3),Timestamps(4)];
    %         OpenField2_ts = [Timestamps(5),Timestamps(6)];


    K.Event {:,3} = DirectInteraction_ts';
    K.Event {:,4} = TubeTest_ts';
    %         K.Event {:,5} = OpenField1_ts';
    %         K.Event {:,6} = OpenField2_ts';


    %     if length(Timestamps) == 6
    %         DirectInteraction_ts =[Timestamps(3),Timestamps(4)];
    %         TubeTest_ts = [Timestamps(end-1),Timestamps(end)];
    %
    %         K.Event {:,3} = DirectInteraction_ts';
    %         K.Event {:,4} = TubeTest_ts';
    %
    %     else
    %         OpenField1_ts = [Timestamps(end-7),Timestamps(end-6)];
    %         OpenField2_ts = [Timestamps(3),Timestamps(4)];
    %         DirectInteraction_ts =[Timestamps(7),Timestamps(8)];
    %         TubeTest_ts = [Timestamps(end-1),Timestamps(end)];
    %
    %         K.Event {:,1} = OpenField1_ts';
    %         K.Event {:,2} = OpenField2_ts';
    %         K.Event {:,3} = DirectInteraction_ts';
    %         K.Event {:,4} = TubeTest_ts';
    %     end

    %% LFP data
    % make sure to check the color of the tether 
    % (behavior에서는 solid mouse1, stripe mouse 2
    % but sometimes mouse2 가 channel 1-8, mouse1 이 9-16 (October 20th 부터)
    %1,1 = Animal 1(LFP channels 1 - 8)
    %1,2 = Animal 2(LFP channels 9 - 16)

    %1,3 = LFP timestamps

    %2,1 = Animal 1(Direct Interaction LFP channels 1 - 8)
    %2,2 = Animal 2(Direct Interaction LFP channels 9 - 16)

    %3,1 = Animal 1(TubeTest LFP channels 1 - 8)
    %3,2 = Animal 2(TubeTest LFP channels 9 - 16)

    %4,1 = Animal 1(Open Field LFP channels 1 - 8)
    %4,2 = Animal 2(Open Field LFP channels 9 - 16)

    A=dir('CSC*.ncs');
    LFP=[];

    for i=1:length(A)
        LFP_Timestamps=[];%usec
        LFP_Samples=[];
        LFP_Header=[];
        [LFP_Timestamps, LFP_Samples, LFP_Header] = Nlx2MatCSC(A(i).name,[1 0 0 0 1],1, 1,[]);
        for k=1:size(LFP_Samples,2)
            LFP((512*(k-1)+1):(512*(k-1)+512),i)=LFP_Samples(:,k)* 0.000000152592548374741450;
        end
        for k=1:size(LFP_Samples,2)
            LFP((512*(k-1)+1):(512*(k-1)+512),17)=LFP_Timestamps(k):500:(LFP_Timestamps(k)+500*511); % 500 = 1/2000(Fs)*10^6
        end
    end

    K.LFP {1,2} = LFP(:,1:1:8); %1,1 1-32 black tether, 1,2 1-32 yellow tether
    K.LFP {1,1} = LFP(:,9:1:16);
    K.LFP {1,3} = LFP(:,17);

    LFP_Timestamps= LFP(:,17);



    directinteraction_ts_indices = find(DirectInteraction_ts(1) <LFP_Timestamps & LFP_Timestamps<DirectInteraction_ts(2));

    tubetest_ts_indices = find(TubeTest_ts(1) <LFP_Timestamps & LFP_Timestamps<TubeTest_ts(2));

    %     openfield_ts_indices_m1 = find(OpenField1_ts(1) <LFP_Timestamps & LFP_Timestamps<OpenField1_ts(2));
    %     openfield_ts_indices_m2 = find(OpenField2_ts(1) <LFP_Timestamps & LFP_Timestamps<OpenField2_ts(2));

    LFP_directinteraction_mouse1 = LFP((directinteraction_ts_indices(1):directinteraction_ts_indices(end)),[1:1:8]);
    LFP_directinteraction_mouse2 = LFP((directinteraction_ts_indices(1):directinteraction_ts_indices(end)),[9:1:16]);

    LFP_tubetest_mouse2 = LFP((tubetest_ts_indices(1):tubetest_ts_indices(end)),[1:1:8]);
    LFP_tubetest_mouse1 = LFP((tubetest_ts_indices(1):tubetest_ts_indices(end)),[9:1:16]);


    %     LFP_openfield_mouse1 = LFP((openfield_ts_indices_m1(1):openfield_ts_indices_m1(end)),[1:1:8]);
    %     LFP_openfield_mouse2 = LFP((openfield_ts_indices_m2(1):openfield_ts_indices_m2(end)),[9:1:16]);

    DirectInteraction_ts_all = LFP_Timestamps(directinteraction_ts_indices(1):directinteraction_ts_indices(end));
    Tubetest_ts_all = LFP_Timestamps(tubetest_ts_indices(1):tubetest_ts_indices(end));

    K.LFP {2,2} = LFP_directinteraction_mouse2;
    K.LFP {2,1} = LFP_directinteraction_mouse1;
    K.LFP {2,3} = DirectInteraction_ts_all';

    
    K.LFP {3,2} = LFP_tubetest_mouse1;
    K.LFP {3,1} = LFP_tubetest_mouse2;
    K.LFP {3,3} = Tubetest_ts_all';

    %     K.LFP{4,1} =LFP_openfield_mouse1;
    %     K.LFP{4,2} =LFP_openfield_mouse2;


    clear K.SPK
    %% K.SPK = spike timing
    fn=FindFiles('*.t64');
    if length(fn)>=1 % if there is isolated neuron

        for x=1:length(fn)
            filename = fn(x);
            tt_filename = filename{1,1};

            if length(tt_filename) == 69
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


    %% K.Social Behavior
    di_start = (K.Event{1,3}(1))/1000000; %microsecond to second
    di_finish = (K.Event{1,3}(2))/1000000; %microsecond to second

    current_data_folder = cd;

    cd C:\Users\USER\Desktop\Social\2020_backup

    xml_filename = strcat(K.date, '_',K.ID{1,1},'.xml');
    l = 1;



    Shank2_socialbehavior_boutcreation_mouse1
    K.SocialBehavior{:,1} = {'unisniffing','bisniffing','chasing','approach','escape'};
    K.SocialBehavior{:,2} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};
    
    cd (current_data_folder);



    cd C:\Users\USER\Desktop\Social\2020_backup

    xml_filename = strcat(K.date, '_',K.ID{1,2},'.xml');

    l = 1;

    Shank2_socialbehavior_boutcreation_mouse1

    K.SocialBehavior{:,3} = {unisniffing_data,bisniffing_data,chasing_data,approach_data,escape_data};
    
    cd (current_data_folder);


    %% K.Non Social Behavior


   

    cd C:\Users\USER\Desktop\NonSocial\2020

    xml_filename = strcat(K.date, '_',K.ID{1,1},'.xml');
    l = 1;

    Shank2_nonsocialbehavior_boutcreation_2020

    K.NonSocialBehavior{:,1} = {'grooming','rearing','jumping'};
    K.NonSocialBehavior{:,2} = {grooming_data,rearing_data,jumping_data};
   
    

    cd C:\Users\USER\Desktop\NonSocial\2020

    xml_filename = strcat(K.date, '_',K.ID{1,2},'.xml');
    l = 1;

    Shank2_nonsocialbehavior_boutcreation_2020


    K.NonSocialBehavior{:,3} = {grooming_data,rearing_data,jumping_data};
    cd (current_data_folder);

    %% K.Exploring

    

    cd C:\Users\USER\Desktop\NonSocial\2020\circling

    xml_filename = strcat(K.date, '_',K.ID{1,1},'_circling','.xml');
    l = 1;

    Shank2_auROC_immobile_2020

    K.Exploring{:,1} = {'movement','circling_counter','circling_clock'};
    K.Exploring{:,2} = {movement_data, counterclockwise_data, clockwise_data};

    cd (current_data_folder);

    

    cd C:\Users\USER\Desktop\NonSocial\2020\circling

    xml_filename = strcat(K.date, '_',K.ID{1,2},'_circling','.xml');
    l = 1;

    Shank2_auROC_immobile_2020


    K.Exploring{:,3} = {movement_data, counterclockwise_data, clockwise_data};

    cd (current_data_folder);



    %% K.Immobile(rest)

    

    cd C:\Users\USER\Desktop\NonSocial\2020\circling

    xml_filename = strcat(K.date, '_',K.ID{1,1},'_circling','.xml');
    l = 1;

    Shank2_auROC_immobile_2020

    K.Immobile{:,2} = {immobile_data};

    cd (current_data_folder);

    

    cd C:\Users\USER\Desktop\NonSocial\2020\circling

    xml_filename = strcat(K.date, '_',K.ID{1,2},'_circling','.xml');
    l = 1;

    Shank2_auROC_immobile_2020

    K.Immobile{:,3} = {immobile_data};

    cd (current_data_folder);





    save(K.date, 'K');
    cd(main);

end

