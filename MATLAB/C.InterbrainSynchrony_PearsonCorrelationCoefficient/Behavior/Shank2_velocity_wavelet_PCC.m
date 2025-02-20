clear all;
close all;
clc;


main = cd;
files = dir('2021-*');
foldernames = char(files.name);

% freqBands = [4 12]; % Example frequency bands
% smoothingWindow = 2; % Example smoothing window

VelocityPCC = {};

for ii = 1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    struct_name = foldern(1:19);

    load(struct_name,'-mat')

    mouse1ID = K.ID {1,1};
    mouse2ID = K.ID{1,2};
    SessionDate = K.date;

    similarVelocityIndices = [];
    velocityThreshold = 0.05;

    

    %if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        load(strcat(struct_name,'_LFP.mat'))

        di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
        di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second

        current_data_folder = cd;

        cd C:\Users\USER\Desktop\Current_Velocity

       csv_filename = strcat(K.date, '_','Current_Velocity','.csv');
      %csv_filename = strcat(K.date, '_',mouse1ID,'_',mouse2ID,'_','Current_Velocity','.csv');

        if ~isfile (csv_filename)
            cd(main)
            continue
        else

            data = readtable(csv_filename);

            if size(data,1)>601

                data = data{1:601,:};
            else
                data = data{:,:};
            end

            % Initialize variables to store start and end positions
            start_positions = [];
            end_positions = [];

            velocityData = data;
            % Loop through each second (assuming your velocity data is in 1-second averages)
            for i = 1:size(velocityData, 1)
                velocityDifference = abs(velocityData(i, 1) - velocityData(i, 2));
                maxVelocity = max(velocityData(i, :));

                if (velocityDifference / maxVelocity) <= velocityThreshold
                    % If velocities are within the threshold, mark this interval as similar
                    similarVelocityIndices = [similarVelocityIndices; i];
                end
            end

            if ~isempty(similarVelocityIndices)

                % (Your existing code for setting up analysis parameters)
                Fs = SamplingFreq;

                % Theta band frequency range
                low = 30;  % Low cutoff frequency of the theta band in Hz
                high = 50;  % High cutoff frequency of the theta band in Hz

               
                % Define band-pass filter for theta band (4-12 Hz)
                [b_theta, a_theta] = butter(2, [low high] / (Fs / 2), 'bandpass');
                

                % Define notch filter centered at 60 Hz
                notch_freq = 60;
                notch_width = 2; % Bandwidth of the notch filter
                [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');

                % Initialize variables for storing filtered data for each mouse
                mouse1_data = [];
                mouse2_data = [];

                % Inside your main loop after loading the LFP.mat file
                for jj = 1:8
                    % Actual data processing for each channel
                    data1 = raw_signal_final{1,1}(:,jj);
                    data2 = raw_signal_final{1,2}(:,jj);

                    % Apply notch filter to remove 60 Hz power line noise
                    data1_filtered = filtfilt(b, a, data1);
                    data2_filtered = filtfilt(b, a, data2);

                    data1_theta = filtfilt(b_theta, a_theta, data1);
                    data2_theta = filtfilt(b_theta, a_theta, data2);




                    % Accumulate filtered data for each mouse
                    %mouse1_data = [mouse1_data, data1_filtered];
                    %mouse2_data = [mouse2_data, data2_filtered];

                    mouse1_data = [mouse1_data, data1_theta];
                    mouse2_data = [mouse2_data, data2_theta];
                end

                % Average across channels for each mouse
                mouse1_avg = mean(mouse1_data, 2);
                mouse2_avg = mean(mouse2_data, 2);

                lfpSocial1 = []; % Initialize empty arrays to hold LFP data for similar velocity windows
                lfpSocial2 = [];

                for i = 1:length(similarVelocityIndices)
                    % Find the timestamp range corresponding to the current similar velocity window
                    windowIndex = similarVelocityIndices(i);
                    LFPtime = find(Timestamp>=windowIndex & Timestamp<=windowIndex+1);
                    if ~isempty(LFPtime)


                        % Find indices in your LFP data that correspond to this time window
                        lfpIndices = LFPtime;

                        if ~isempty(lfpIndices)
                            % Extract LFP data for this window and append it to your arrays
                            lfpSocial1 = [lfpSocial1; mouse1_avg(lfpIndices)];
                            lfpSocial2 = [lfpSocial2; mouse2_avg(lfpIndices)];
                        end
                    else
                    end

                end

                % Calculate cross-correlation for actual averaged data
                velPCC = min(min(corr(lfpSocial1, lfpSocial2, 'Type', 'Pearson')));

                VelocityPCC{ii,1} = SessionDate;
                VelocityPCC{ii,2} = mouse1ID;
                VelocityPCC{ii,3} = mouse2ID;
                VelocityPCC{ii,4} = velPCC; 
                %WaveletSocial{ii,5} = correlationCoeffs(2,1);
                %WaveletSocial{ii,6} = correlationCoeffs(3,1);


            else
            end

        end
 % end


    cd(main);
end

VelocityPCC(all(cellfun(@isempty, VelocityPCC),2),:) = [];


