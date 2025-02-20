clear all;
close all;
clc;

main = cd;
files = dir('2024-*');
foldernames = char(files.name);

% This MATLAB script is used to filter out noise in LFP.ncs files.
% You need custom function 'CommonElemTol.m' in order to run this code.

PCC_all= {};

for ii =35:40 %1:size(foldernames,1)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);
    cd(files(ii).name);

    struct_name = foldern(1:19)
    mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);

    if isfile(strcat(struct_name,'_LFP.mat'))
        load(strcat(struct_name,'_LFP.mat'))

        %% Set Parameters
        Fs = SamplingFreq;
        params.Fs = SamplingFreq;
        params.tapers   = [3 5];
        params.fpass    = [4 100];
        params.trialave = 0;
        params.pad      = 1;
        params.err      = [2 0.05];

        stepwin = [2 0.5];

        % Define notch filter centered at 60 Hz
        notch_freq = 60;
        notch_width = 2;
        [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');

        % Divide raw data into three segments for each mouse
        num_points = size(raw_signal_final{1,1}, 1);
        segment_length = floor(num_points / 3);
        
        PCC_values = zeros(1, 3);  % To store PCC values for each segment

        for k = 1:3
            % Determine start and end indices for each segment
            start_idx = (k-1) * segment_length + 1;
            if k < 3
                end_idx = k * segment_length;
            else
                end_idx = num_points; % Ensure last segment captures remaining points
            end
            
            % Initialize variables for storing segment sliding window power
            mouse1_LFP_segment = [];
            mouse2_LFP_segment = [];

            % Process mouse 1 data for this segment
            for jj = 1:8
                data = raw_signal_final{1,1}(start_idx:end_idx, jj);
                data_filtered = filtfilt(b, a, data);
                [S, ~, ~, ~] = mtspecgramc(data_filtered, stepwin, params);
                mouse1_LFP_segment(:, jj) = sum(S, 2); % Power for each window
            end

            % Process mouse 2 data for this segment
            for jj = 1:8
                data = raw_signal_final{1,2}(start_idx:end_idx, jj);
                data_filtered = filtfilt(b, a, data);
                [S, ~, ~, ~] = mtspecgramc(data_filtered, stepwin, params);
                mouse2_LFP_segment(:, jj) = sum(S, 2); % Power for each window
            end

            % Calculate mean power across all channels for this segment
            mouse1_power = (mean(mouse1_LFP_segment, 2));
            mouse2_power = (mean(mouse2_LFP_segment, 2));

            % Calculate PCC for this segment
            PCC_values(k) = (min(min(corr(mouse1_power, mouse2_power, 'type', 'Pearson')))); 
        end

        % Store results
        PCC_all{ii,1} = struct_name;
        PCC_all{ii,2} = mouse1ID;
        PCC_all{ii,3} = mouse2ID;
        PCC_all{ii,4} = PCC_values(1); % PCC for first segment
        PCC_all{ii,5} = PCC_values(2); % PCC for second segment
        PCC_all{ii,6} = PCC_values(3); % PCC for third segment

    end

    cd(main)
end

% Remove empty rows
PCC_all(all(cellfun(@isempty, PCC_all),2), :) = [];
