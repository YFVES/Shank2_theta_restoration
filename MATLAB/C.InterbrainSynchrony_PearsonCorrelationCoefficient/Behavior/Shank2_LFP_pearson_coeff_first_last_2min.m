main = cd;
files = dir('2023-*');
foldernames = char(files.name);

PCC_all = {};

for ii = 1:length(foldernames)
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    load(struct_name, '-mat');

    mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);

    if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        if isfile(strcat(struct_name,'_LFP.mat'))
            load(strcat(struct_name,'_LFP.mat'));

            current_data_folder = cd;

            % Define the total session time and the start/end times for the first and last 2-minute windows
            total_session_time = 600; % Assuming a 10-minute session
            first_window_start = 0; % Start of the session
            first_window_end = 120; % End of the first 2 minutes
            last_window_start = total_session_time - 120; % Start of the last 2 minutes
            last_window_end = total_session_time; % End of the session

            % Initialize array for PCC calculations for the first and last 2-minute windows
            PCC_windows = [];

            % Define the two windows for PCC calculation
            windows = [first_window_start, first_window_end; last_window_start, last_window_end];

            % LFP data processing parameters remain the same
            Fs = SamplingFreq;
            params.Fs = Fs;
            params.tapers = [3 5];
            params.fpass = [4 100];
            params.trialave = 0;
            params.pad = 1;
            params.err = [2 0.05];
            
            % Define notch filter for 60Hz line noise removal
            notch_freq = 60; % 60 Hz line noise
            notch_width = 2; % 2 Hz bandwidth around notch frequency
            [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');

            % Loop through the first and last windows to calculate PCC
            for w = 1:size(windows, 1)
                window_start_time = windows(w, 1);
                window_end_time = windows(w, 2);

                % Calculate start and end indices for the LFP data
                start_idx = round(window_start_time * Fs) + 1;
                end_idx = min(round((window_end_time * Fs)), length(raw_signal_final{1,1}(:,1)));

                % Calculate PCC for the current window
                PCC_segment = calculatePCC(raw_signal_final, start_idx, end_idx, b, a, params);
                
                % Store the PCC value for the current window
                PCC_windows = [PCC_windows, PCC_segment];
            end

            % Store the PCC values for the first and last 2-minute windows separately
            PCC_all{ii,1} = struct_name;
            PCC_all{ii,2} = PCC_windows(1); % PCC for the first 2 minutes
            PCC_all{ii,3} = PCC_windows(2); % PCC for the last 2 minutes
            PCC_all{ii,4} = mouse1ID;
            PCC_all{ii,5} = mouse2ID;
        end
    end
    cd(main); % Return to the main directory after processing each folder
end
