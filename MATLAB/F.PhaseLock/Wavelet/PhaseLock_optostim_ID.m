close all
clear all

main = cd;
files = dir('2024-*');
foldernames = char(files.name);

compiled_data = []; % Initialize matrix to store compiled data

for ii = 1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);

    load(struct_name, '-mat');

    if isfile(strcat(struct_name,'_LFP.mat'))
        load(strcat(struct_name,'_LFP.mat'));

        di_start = (K.Event{1,4}(1))/1000000; % Microseconds to seconds
        di_end = (K.Event{1,4}(2))/1000000; % Microseconds to seconds

        mouse1ID = K.ID{1,1};
        mouse2ID = K.ID{1,2};
        date = K.date;

        if size(K.SPK,1) ~= 0

            mouse1SPK = K.SPK(:,1);
            mouse1SPK(all(cellfun(@isempty,mouse1SPK),2),:) = [];

            if size(K.SPK,2) > 1
                mouse2SPK = K.SPK(:,2);
                mouse2SPK(all(cellfun(@isempty,mouse2SPK),2),:) = [];
            else
                mouse2SPK = [];
            end

            Fs = SamplingFreq; % Replace with your actual sampling rate

            % Define frequency bands
            thetaBand = [4, 12]; % Theta band in Hz
            betaBand = [13, 30]; % Beta band in Hz
            lowGammaBand = [30, 80]; % Low Gamma band in Hz

            % Number of windows
            numWindows = 3;
            segment_length = floor((di_end - di_start) * Fs / numWindows);

            for winIdx = 1:numWindows
                % Define start and end indices for the current window
                start_idx = (winIdx - 1) * segment_length + 1;
                if winIdx < numWindows
                    end_idx = winIdx * segment_length;
                else
                    end_idx = min((di_end - di_start) * Fs, length(mean(raw_signal_final{1,1},2))); % Ensure the last segment captures all data
                end

                for jj = 1:2 % Loop through Mouse 1 and Mouse 2
                    if jj == 1
                        spikeData = mouse1SPK;
                        mouseID = mouse1ID;
                    else
                        spikeData = mouse2SPK;
                        mouseID = mouse2ID;
                    end

                    if ~isempty(spikeData)
                        % Initialize row for the current mouse, date, and window
                        current_row = {date, mouseID, [], [], [], [], [], [], [], [], []};

                        for bandIdx = 1:3
                            % Load saved results
                            bandName = {'Theta', 'Beta', 'LowGamma'};
                            significantFile = fullfile(cd, sprintf('%s_Window%d_Mouse%d.mat', struct_name, winIdx, jj));
                            
                            if isfile(significantFile)
                                load(significantFile, 'result');
                                
                                % Check if sigCellspvalue field exists in result
                                if isfield(result, 'sigCellspvalue')
                                    rayleighPs = result.sigCellspvalue;
                                    % Extract significant cells for this window, mouse, and band
                                    sigCells = find(rayleighPs(:, bandIdx) < 0.05);
                                    % Store data in the appropriate position in the row
                                    current_row{3 + (winIdx - 1) * 3 + bandIdx - 1} = sigCells;
                                end
                            end
                        end

                        % Append the current row to the compiled data
                        compiled_data = [compiled_data; current_row];
                    end
                end
            end
        end
    end
    cd(main);
end

% Convert compiled data to table and save as .mat and .csv
compiled_table = cell2table(compiled_data, 'VariableNames', { ...
    'Date', 'MouseID', ...
    'Window1_Theta', 'Window1_Beta', 'Window1_Gamma', ...
    'Window2_Theta', 'Window2_Beta', 'Window2_Gamma', ...
    'Window3_Theta', 'Window3_Beta', 'Window3_Gamma'});

save('compiled_significant_cells.mat', 'compiled_table');
writecell(compiled_data, 'compiled_significant_cells.csv'); 