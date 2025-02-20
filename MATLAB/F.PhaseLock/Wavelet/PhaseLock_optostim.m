close all
clear all

main = cd;
files = dir('2024-*');
foldernames = char(files.name);

savelocation = 'G:\Shank2\Optostim_chronic\PhaseLock\Other';

spikePhases_m1m2 = {};
avgPhase_m1m2 = {};
significantCells_m1m2 = {};
meanAngles_m1m2 = {};
vectorLengths_m1m2 = {};



for ii = 1:length(foldernames)

    spikePhases_m1m2 = {};
    avgPhase_m1m2 = {};
    significantCells_m1m2 = {};

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19);

    cd(files(ii).name);

    load(struct_name, '-mat');

    if isfile(strcat(struct_name,'_LFP.mat'))
        load(strcat(struct_name,'_LFP.mat'));

        di_start = (K.Event{1,4}(1))/1000000; % Microseconds to seconds
        di_end = (K.Event{1,4}(2))/1000000; % Microseconds to seconds

        mouse1ID = K.ID{1,1};
        mouse2ID = K.ID{1,2};

        if size(K.SPK,1) ~= 0

            mouse1SPK = K.SPK(:,1);
            mouse1SPK(all(cellfun(@isempty,mouse1SPK),2),:) = [];

            if size(K.SPK,2) > 1
                mouse2SPK = K.SPK(:,2);
                mouse2SPK(all(cellfun(@isempty,mouse2SPK),2),:) = [];
            else
                mouse2SPK = [];
            end

            K.SPKm1 = mouse1SPK;
            K.SPKm2 = mouse2SPK;

            mouse1LFP = mean(raw_signal_final{1,2},2);
            mouse2LFP = mean(raw_signal_final{1,1},2);

            Fs = SamplingFreq; % Replace with your actual sampling rate

            % Define frequency bands
            thetaBand = [4, 12]; % Theta band in Hz
            betaBand = [13, 30]; % Beta band in Hz
            lowGammaBand = [30, 80]; % Low Gamma band in Hz

            % Notch filter for power line noise
            notchFreq = 50; % 50 Hz for most of Europe and Asia, 60 Hz for the Americas
            Q = 35; % Quality factor for notch filter
            dNotch = designfilt('bandstopiir', 'FilterOrder', 2, ...
                'HalfPowerFrequency1', notchFreq-2, 'HalfPowerFrequency2', notchFreq+2, ...
                'DesignMethod', 'butter', 'SampleRate', Fs);

            % Number of windows
            numWindows = 3;
            segment_length = floor((di_end - di_start) * Fs / numWindows);

            % Initialize output variables
            finalResults = cell(numWindows, 2); % 3 rows (windows) x 2 columns (Mouse 1, Mouse 2)

            for winIdx = 1:numWindows
                % Define start and end indices for the current window
                start_idx = (winIdx - 1) * segment_length + 1;
                if winIdx < numWindows
                    end_idx = winIdx * segment_length;
                else
                    end_idx = min((di_end - di_start) * Fs, length(mouse1LFP)); % Ensure the last segment captures all data
                end

                winStart = di_start + (start_idx - 1) / Fs; % Convert to time
                winEnd = di_start + end_idx / Fs; % Convert to time

                for jj = 1:2 % Loop through Mouse 1 and Mouse 2
                    if jj == 1
                        spikeData = mouse1SPK;
                        LFPdata = mouse1LFP; % Mouse 1 spikes to LFP
                        mouseID = mouse1ID;
                    else
                        spikeData = mouse2SPK;
                        LFPdata = mouse2LFP; % Mouse 2 spikes to LFP
                        mouseID = mouse2ID;
                    end

                    if ~isempty(spikeData)
                        % Segment LFP data for the current window
                        LFP_segment = LFPdata(start_idx:end_idx);

                        % Preprocess spikes for the current window
                        spikeData_window = cell(size(spikeData));
                        for i = 1:length(spikeData)
                            spikes_temp = spikeData{i};
                            spikes_temp = spikes_temp(spikes_temp >= winStart & spikes_temp < winEnd);
                            spikes_temp = spikes_temp - winStart;
                            spikeData_window{i} = spikes_temp;
                        end

                        % Apply notch filter
                        LFP_notched = filtfilt(dNotch, LFP_segment);

                        % Filter and extract phases for each band
                        dTheta = designfilt('bandpassiir', 'FilterOrder', 4, ...
                            'HalfPowerFrequency1', thetaBand(1), 'HalfPowerFrequency2', thetaBand(2), ...
                            'SampleRate', Fs);
                        dBeta = designfilt('bandpassiir', 'FilterOrder', 4, ...
                            'HalfPowerFrequency1', betaBand(1), 'HalfPowerFrequency2', betaBand(2), ...
                            'SampleRate', Fs);
                        dLowGamma = designfilt('bandpassiir', 'FilterOrder', 4, ...
                            'HalfPowerFrequency1', lowGammaBand(1), 'HalfPowerFrequency2', lowGammaBand(2), ...
                            'SampleRate', Fs);

                        LFP_theta = filtfilt(dTheta, LFP_notched);
                        LFP_beta = filtfilt(dBeta, LFP_notched);
                        LFP_lowGamma = filtfilt(dLowGamma, LFP_notched);

                        phase_theta = angle(hilbert(LFP_theta));
                        phase_beta = angle(hilbert(LFP_beta));
                        phase_lowGamma = angle(hilbert(LFP_lowGamma));

                        spikePhases = cell(size(spikeData_window, 1), 3);

                        for i = 1:length(spikeData_window)
                            spikes = spikeData_window{i};
                            spikes = round(spikes * Fs);
                            spikes(spikes < 1 | spikes > length(phase_theta)) = [];

                            % Extract phases for each spike
                            spikePhases{i, 1} = phase_theta(spikes);
                            spikePhases{i, 2} = phase_beta(spikes);
                            spikePhases{i, 3} = phase_lowGamma(spikes);
                        end

                        % Compute Rayleigh test results and vector lengths
                        numCells = size(spikePhases, 1);
                        vectorLengths = zeros(numCells, 3);
                        rayleighPs = zeros(numCells, 3);
                        rayleighZs = zeros(numCells, 3);
                        significantCells = cell(numWindows, 3); % Store significant cells for each window and band

                        for i = 1:numCells
                            for j = 1:3 % Theta, Beta, Low Gamma
                                if ~isempty(spikePhases{i, j})
                                    % Vector length
                                    vectorLengths(i, j) = circ_r(spikePhases{i, j});

                                    % Rayleigh test
                                    [rayleighPs(i, j), rayleighZs(i, j)] = circ_rtest(spikePhases{i, j});

                                    % Identify significant cells
                                    if rayleighPs(i, j) < 0.05
                                        significantCells{winIdx, j} = [significantCells{winIdx, j}, i];
                                    end
                                else
                                    vectorLengths(i, j) = NaN;
                                    rayleighPs(i, j) = NaN;
                                    rayleighZs(i, j) = NaN;
                                end
                            end
                        end

                        % Save results for each window and mouse
                        result = struct('spikePhases', {spikePhases}, ...
                                        'avgPhase', mean(vectorLengths, 1), ...
                                        'significantCells', significantCells(winIdx, :), ...
                                        'meanAngles', mean(vectorLengths, 1), ...
                                        'sigCellspvalue', rayleighPs, ...
                                        'sigCellszvalue', rayleighZs, ...
                                        'vectorLengths', vectorLengths);

                        save(fullfile(cd, strcat(struct_name, '_Window', num2str(winIdx), '_Mouse', num2str(jj), '.mat')), 'result');
                         save(fullfile(savelocation, strcat(struct_name, '_Window', num2str(winIdx), '_Mouse', num2str(jj), '.mat')), 'result');

                        
                    end
                end
            end
        end
    end

    cd(main);
end
