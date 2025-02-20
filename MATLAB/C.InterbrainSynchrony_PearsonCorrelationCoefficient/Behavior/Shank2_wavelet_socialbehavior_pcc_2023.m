clear all;
close all;
clc;


main = cd;
files = dir('2023-*');
foldernames = char(files.name);

freqBands = [4 12]; % Example frequency bands
smoothingWindow = 2; % Example smoothing window

WaveletSocial = {};

for ii = 1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    struct_name = foldern(1:19);

    load(struct_name,'-mat')

    mouse1ID = K.ID {1,1};
    mouse2ID = K.ID{1,2};
    SessionDate = K.date;

    if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        load(strcat(struct_name,'_LFP.mat'))

        di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
        di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second

        %mouse1 social behavior timestamp

        current_data_folder = cd;

        cd D:\Shank2_cohort3_video\Social

        xml_filename = strcat(K.date, '_',K.ID{1,1},'_social_1','.xml');
        l = 1;

        Shank2_socialbehavior_boutcreation_mouse1

        cd (current_data_folder);



        BehaviorOfInterest = totalBouts;


        behavior_ts_mouse1 = BehaviorOfInterest(:,1:2);

        %mouse2 social behavior timestamp

        current_data_folder = cd;

        cd D:\Shank2_cohort3_video\Social

        xml_filename = strcat(K.date, '_',K.ID{1,2},'_social_2','.xml');
        l = 1;

        Shank2_socialbehavior_boutcreation_mouse1

        cd (current_data_folder);

        BehaviorOfInterest = totalBouts;


        behavior_ts_mouse2 = BehaviorOfInterest(:,1:2);

        Behavior_ts_total = [behavior_ts_mouse1;behavior_ts_mouse2];
        Behavior_ts_total = sort(Behavior_ts_total);
        Behavior_ts_total = unique(Behavior_ts_total,'rows');



        


        % Design a notch filter to remove 60 Hz noise
        Fs = SamplingFreq; % Your sampling frequency
        notchFreq = 60;  % Frequency to notch out
        notchBandwidth = 2;  % Bandwidth around the notch freq to remove
        [b, a] = iirnotch(notchFreq/(Fs/2), notchBandwidth/(Fs/2));

        % Apply notch filter to the LFP data for both mice
        for mouseIdx = 1:2
            for channelIdx = 1:size(raw_signal_final{mouseIdx}, 2)
                raw_signal_final{mouseIdx}(:, channelIdx) = filtfilt(b, a, raw_signal_final{mouseIdx}(:, channelIdx));
            end
        end
        lfpSocial1 = [];
        lfpSocial2 = [];

        lfp_mouse1 = raw_signal_final{1,1};
        lfp_mouse2 = raw_signal_final{1,2};


        for window = 1:size(Behavior_ts_total, 1)
            startTime = Behavior_ts_total(window, 1);
            endTime = Behavior_ts_total(window, 2);
            behavior_index = find(Timestamp>startTime & Timestamp<endTime);
            temp_lfpData1 = lfp_mouse1(behavior_index(1):behavior_index(end));
            lfpSocial1 = [lfpSocial1, temp_lfpData1];
        end

        for window = 1:size(Behavior_ts_total, 1)
            startTime = Behavior_ts_total(window, 1);
            endTime = Behavior_ts_total(window, 2);
            behavior_index = find(Timestamp>startTime & Timestamp<endTime);
            temp_lfpData2 = lfp_mouse2(behavior_index(1):behavior_index(end));
            lfpSocial2 = [lfpSocial2, temp_lfpData2];
        end

if ~isempty(lfpSocial1) && ~isempty(lfpSocial2)
        [wt1, freqs] = cwt(lfpSocial1, 'amor', SamplingFreq);
        [wt2, ~] = cwt(lfpSocial2, 'amor', SamplingFreq);
        correlationCoeffs = calculateWaveletCorrelation(wt1, wt2, freqs, freqBands);
else

        correlationCoeffs = NaN; 
end

        WaveletSocial{ii,1} = SessionDate;
        WaveletSocial{ii,2} = mouse1ID;
        WaveletSocial{ii,3} = mouse2ID;
        WaveletSocial{ii,4} = correlationCoeffs(1,1);
        %WaveletSocial{ii,5} = correlationCoeffs(2,1);
        %WaveletSocial{ii,6} = correlationCoeffs(3,1);




    end


    cd(main);
end

WaveletSocial(all(cellfun(@isempty, WaveletSocial),2),:) = [];
