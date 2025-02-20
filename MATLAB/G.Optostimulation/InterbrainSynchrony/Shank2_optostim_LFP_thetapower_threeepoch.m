clear all;
close all;
clc;

main = cd;
files = dir('2024-*');
foldernames = char(files.name);


% Preallocate matrix for theta power results
% Assuming a maximum of `length(foldernames) * 2` entries (two mice per session)
theta_power_results = {}; 

% Initialize a counter for rows in the results matrix
result_idx = 1;

% This MATLAB script calculates PSD for each CSC channel using pwelch
% with a notch filter to remove power noise.

for ii = 1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    date = struct_name; % Convert date to numeric for matrix storage

    struct_name = foldern(1:19);
     mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);
    if isfile(strcat(struct_name, '_LFP.mat'))
        load(strcat(struct_name, '_LFP.mat'));

        %% Set Parameters
        Fs = SamplingFreq; % Sampling frequency
        segment_length = 2 * Fs; % 2-second segments for Welch's method
        overlap = segment_length / 2; % 50% overlap
        nfft = 4 * segment_length; % FFT points (higher resolution)

        % Notch Filter Design (to remove 60 Hz and harmonics)
        notch_freqs = [60, 120, 180]; % Fundamental and harmonics
        notch_width = 2; % Width of the notch in Hz
        for nf = notch_freqs
            [b, a] = butter(2, [(nf - notch_width/2)/(Fs/2), (nf + notch_width/2)/(Fs/2)], 'stop');
        end

        % Divide data into three epochs
        num_points = size(raw_signal_final{1,1}, 1);
        epoch_length = floor(num_points / 3);

        for mouse_idx = 1:2

            if mouse_idx == 1
                mouseID = mouse1ID;
            else
                mouseID = mouse2ID;
            end

            % Initialize theta power for this mouse
            theta_powers = zeros(1, 3);

            for epoch = 1:3
                % Define start and end indices for each epoch
                start_idx = (epoch - 1) * epoch_length + 1;
                if epoch < 3
                    end_idx = epoch * epoch_length;
                else
                    end_idx = num_points; % Last epoch includes remaining points
                end

                % Initialize average PSD for the epoch
                avg_psd = 0;
                channel_count = size(raw_signal_final{1,mouse_idx}, 2);

                % Process each channel
                for jj = 1:channel_count
                    data = raw_signal_final{1,mouse_idx}(start_idx:end_idx, jj);
                    for nf = notch_freqs
                        data = filtfilt(b, a, data); % Apply notch filter
                    end
                    [Pxx, f] = pwelch(data, segment_length, overlap, nfft, Fs);
                    if jj == 1
                        avg_psd = Pxx;
                    else
                        avg_psd = avg_psd + Pxx;
                    end
                end

                avg_psd = avg_psd / channel_count; % Compute average PSD for the epoch
                avg_psd_log = 10*log10(avg_psd); 

                % Calculate theta power (4-12 Hz)
                theta_idx = find(f >= 4 & f <= 12);
                theta_power = sum(avg_psd_log(theta_idx)) * (f(2) - f(1)); % Area under PSD curve in theta band
                theta_powers(epoch) = theta_power;
            end

            % Append results to the matrix
            theta_power_results{result_idx, 1} = date; 
            theta_power_results{result_idx,2} = mouseID;
            theta_power_results{result_idx,3} = theta_powers(1);
            theta_power_results{result_idx,4} = theta_powers(2);
            theta_power_results{result_idx,5} = theta_powers(3);
           
            result_idx = result_idx + 1;

        end

    end

    cd(main);
end

% Remove unused rows from the matrix
theta_power_results = theta_power_results(1:result_idx-1, :);


