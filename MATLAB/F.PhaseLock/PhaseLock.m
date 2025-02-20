close all
clear all

main = cd;
files = dir('2023-*');
foldernames = char(files.name);

spikePhases_m1m2 = {};
avgPhase_m1m2 = {};
significantCells_m1m2 = {};
meanAngles_m1m2 = {};
vectorLengths_m1m2 = {};


for ii = [1:10,12:length(foldernames)]%44:length(foldernames); 

    spikePhases_m1m2 = {};
    avgPhase_m1m2 = {};
    significantCells_m1m2 = {};


    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);

    load(struct_name, '-mat')

    if isfile (strcat(struct_name,'_LFP_m1solitary.mat'))



        m1_start = (K.Event{1,2}(1))/1000000; %microsecond to second
        m1_end = (K.Event{1,2}(2))/1000000; %microsecond to second


        m2_start = (K.Event{1,3}(1))/1000000; %microsecond to second
        m2_end = (K.Event{1,3}(2))/1000000; %microsecond to second

        mouse1ID = K.ID{1,1};
        mouse2ID = K.ID{1,2};

        if size(K.SPK,1) ~= 0

            mouse1SPK = K.SPK(:,1);
            mouse1SPK(all(cellfun(@isempty,mouse1SPK),2),:) = [];



            if size(K.SPK,2)>1
                mouse2SPK = K.SPK(:,2);
                mouse2SPK(all(cellfun(@isempty,mouse2SPK),2),:) = [];
            else
                mouse2SPK = [];
            end


            K.SPKm1 = mouse1SPK;
            K.SPKm2 = mouse2SPK;
            load(strcat(struct_name,'_LFP_m1solitary.mat'))

            mouse1LFP = mean(raw_signal_final{1,1},2);

            load(strcat(struct_name,'_LFP_m2solitary.mat'))
            mouse2LFP = mean(raw_signal_final{1,2},2);

            Fs = SamplingFreq; % Replace with your actual sampling rate
            % Define frequency bands
            thetaBand = [4, 12]; % Theta band in Hz
            betaBand = [13, 30]; % Beta band in Hz
            lowGammaBand = [30, 80]; % Low Gamma band in Hz

            % Notch filter for power line noise (adjust according to your region's power line frequency)
            notchFreq = 50; % 50 Hz for most of Europe and Asia, 60 Hz for the Americas
            Q = 35; % Quality factor for notch filter
            dNotch = designfilt('bandstopiir', 'FilterOrder', 2, ...
                'HalfPowerFrequency1', notchFreq-2, 'HalfPowerFrequency2', notchFreq+2, ...
                'DesignMethod', 'butter', 'SampleRate', Fs);




            for jj = 1:2
                if jj == 1
                    spikeData = mouse1SPK;
                    LFPdata = mouse1LFP;
                    start = m1_start;
                    finish = m1_end;

                else
                    spikeData = mouse2SPK;
                    LFPdata = mouse2LFP;
                    start = m2_start;
                    finish = m2_end;
                end

                if ~isempty(spikeData)
                    spikeData_final = cell(size(spikeData));

                    for i = 1:length(spikeData)
                        spikes_temp = spikeData{i};
                        spikes_temp = spikes_temp(spikes_temp>=start&spikes_temp<finish);
                        spikes_temp = spikes_temp-start;
                        spikeData_final{i}=spikes_temp;
                    end

                    % Apply notch filter to remove power line noise
                    LFPdata_notched = filtfilt(dNotch, LFPdata);

                    % Filter and extract phases for each band
                    spikePhases = cell(size(spikeData_final,1), 3); % Columns for theta, beta, and low gamma

                    % Design bandpass filters for each frequency band
                    dTheta = designfilt('bandpassiir', 'FilterOrder', 4, ...
                        'HalfPowerFrequency1', thetaBand(1), 'HalfPowerFrequency2', thetaBand(2), ...
                        'SampleRate', Fs);
                    dBeta = designfilt('bandpassiir', 'FilterOrder', 4, ...
                        'HalfPowerFrequency1', betaBand(1), 'HalfPowerFrequency2', betaBand(2), ...
                        'SampleRate', Fs);
                    dLowGamma = designfilt('bandpassiir', 'FilterOrder', 4, ...
                        'HalfPowerFrequency1', lowGammaBand(1), 'HalfPowerFrequency2', lowGammaBand(2), ...
                        'SampleRate', Fs);

                    % Filter signals for each band
                    LFP_theta = filtfilt(dTheta, LFPdata_notched);
                    LFP_beta = filtfilt(dBeta, LFPdata_notched);
                    LFP_lowGamma = filtfilt(dLowGamma, LFPdata_notched);

                    % Apply Hilbert transform to get instantaneous phases
                    phase_theta = angle(hilbert(LFP_theta));
                    phase_beta = angle(hilbert(LFP_beta));
                    phase_lowGamma = angle(hilbert(LFP_lowGamma));


                    for i = 1:length(spikeData_final)
                        spikes = spikeData_final{i}; % Assuming these are in seconds
                        spikes = round(spikes * Fs); % Convert to indices
                        spikes(spikes < 1 | spikes > length(phase_theta)) = [];

                        % Extract phases for each spike
                        spikePhases{i, 1} = phase_theta(spikes); % Theta
                        spikePhases{i, 2} = phase_beta(spikes);  % Beta
                        spikePhases{i, 3} = phase_lowGamma(spikes); % Low Gamma
                    end

                    avgPhase = zeros(size(spikePhases,1), 3); % For each band
                    for i = 1:size(spikePhases,1)
                        % Ensure the data is a vector
                        phaseData = spikePhases{i, 1};

                        % Check if phaseData is a cell or multidimensional array
                        if iscell(phaseData) || numel(size(phaseData)) > 2
                            % Flatten or convert the data to a vector as appropriate
                            % This is a placeholder; you'll need to adjust based on your data structure
                            phaseData = cell2mat(phaseData);  % Example for cell array
                            phaseData = phaseData(:);  % Flatten the array if multidimensional
                        end
                        avgPhase(i, 1) = circ_mean((spikePhases{i, 1})); % Theta
                        avgPhase(i, 2) = circ_mean((spikePhases{i, 2})); % Beta
                        avgPhase(i, 3) = circ_mean((spikePhases{i, 3})); % Low Gamma

                        temp = rad2deg(avgPhase(i,:));
                        temp(temp<0) = temp(temp<0)+360;

                        avgPhase(i,:) = temp;
                    end





                    numCells = size(spikePhases,1);
                    meanAngles = zeros(numCells, 3); % One column per frequency band
                    angDevs = zeros(numCells, 3);
                    vectorLengths = zeros(numCells, 3);
                    rayleighPs = zeros(numCells, 3);
                    rayleighZs = zeros(numCells, 3);

                    for i = 1:numCells
                        for j = 1:3 % Assuming 1: Theta, 2: Beta, 3: Low Gamma
                            if ~isempty(spikePhases{i, j})
                                % Compute mean angle and vector length
                                [meanAngle, vectorLength] = circ_mean(spikePhases{i, j});

                                % Compute Rayleigh's R test for non-uniformity
                                [pval, zval] = circ_rtest(spikePhases{i, j});

                                % Store results
                                meanAngles(i, j) = rad2deg(meanAngle); % Convert to degrees
                                meanAngles(i, j) = meanAngles(i, j) + 360 * (meanAngles(i, j) < 0);  % Adjust range to [0, 360]
                                vectorLengths(i, j) = vectorLength;
                                rayleighPs(i, j) = pval;
                                rayleighZs(i, j) = zval;
                            else
                                % Handle cases with no data
                                meanAngles(i, j) = NaN;
                                vectorLengths(i, j) = NaN;
                                rayleighPs(i, j) = NaN;
                                rayleighZs(i, j) = NaN;
                            end
                        end
                    end

                    significantLevel = 0.05; % Significance level
                    significantCells = cell(1, 3); % One array for each band

                    for j = 1:3
                        significantCells{j} = find(rayleighPs(:, j) < significantLevel);
                    end

                    if jj == 1


                        spikePhases_m1m2{1,1} = spikePhases;
                        avgPhase_m1m2{1,1} = avgPhase;
                        significantCells_m1m2{1,1} = significantCells;
                        meanAngles_m1m2{1,1} = meanAngles;
                        sigCellspvalue_m1m2{1,1} =rayleighPs;
                        sigCellszvalue_m1m2{1,1} =rayleighZs;
                        vectorLengths_m1m2 {1,1} = vectorLengths;
                    else
                        spikePhases_m1m2{1,2} = spikePhases;
                        avgPhase_m1m2{1,2} = avgPhase;
                        significantCells_m1m2{1,2} = significantCells;
                        meanAngles_m1m2{1,2} = meanAngles;
                        sigCellspvalue_m1m2{1,2} =rayleighPs;
                        sigCellszvalue_m1m2{1,2} =rayleighZs;
                        vectorLengths_m1m2 {1,2} = vectorLengths;

                    end

                else
                end

                save ('avgPhase','avgPhase_m1m2')
                save ('spikePhases','spikePhases_m1m2')
                save ('PhaseLockCells','significantCells_m1m2')
                save ('meanAngles','meanAngles_m1m2')
                save ('vectorLengths','vectorLengths_m1m2')



            end
        else
        end
    else
    end

    cd (main)
end



% %% plot all significantly phased locked cell. num of cells as y axis. phase as x axis.
% % Define colors for each band
% colors = {[0.8500 0.3250 0.0980], [135, 206, 235]/255, [218, 165, 32]/255}; % sky blue and goldenrod colors are normalized (0-1)
%
%
% for j = 1:3
%     if ~isempty(significantCells{j})
%         % Extract the mean angles for significant cells only
%         significantMeanAngles = meanAngles(significantCells{j}, j);
%
%         % Define the edges of the bins
%         binEdges = 0:30:360; % Change the bin size if necessary
%
%         % Create the histogram and get the values
%         figure;
%         [counts, edges] = histcounts(significantMeanAngles, 'BinEdges', binEdges);
%         bar(edges(1:end-1) + 15, counts, 'FaceColor', colors{j}, 'EdgeColor', 'k');
%
%         % Calculate the amplitude of the cosine wave based on the histogram
%         maxCount = max(counts);
%         amplitude = maxCount; % Set amplitude to match max count for visibility
%
%         % Generate a cosine wave to overlay
%         % The wave's trough will be at 180 degrees, which is pi radians
%         xValues = linspace(0, 360, 1000); % Generate 1000 points for a smooth wave
%         yValues = amplitude * (-cosd(xValues - 180) + 1)/2; % Flip the wave and shift vertically
%
%         % Overlay the cosine wave
%         hold on;
%         plot(xValues, yValues, 'k-', 'LineWidth', 2);
%         hold off;
%
%         % Add labels and title
%         xlabel('Phase (Degrees)');
%         ylabel('Number of Cells');
%         title(['Distribution of Preferred Phases - ' bands{j} ' Band']);
%
%         % Optional: Set the limits and grid
%         xlim([0 360]);
%         set(gca, 'XTick', 0:30:360); % Adjust x-axis ticks to align with bin edges
%         ylim([0, maxCount + (amplitude/2)]); % Adjust y-axis to fit the cosine wave
%         grid on;
%     end
% end





