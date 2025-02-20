close all
clear all

main = cd;
files = dir('2023-*');
foldernames = char(files.name);

spikePhases_m1m2 = {};
avgPhase_m1m2 = {};
significantCells_m1m2 = {};


for ii = 1:length(foldernames)

    spikePhases_m1m2 = {};
    avgPhase_m1m2 = {};
    significantCells_m1m2 = {};


    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);

    load(struct_name, '-mat')
    load(strcat(struct_name,'_LFP.mat'))

    di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
    di_end = (K.Event{1,4}(2))/1000000; %microsecond to second

    mouse1ID = K.ID{1,1};
    mouse2ID = K.ID{1,2};

    mouse1SPK = K.SPK(:,1);
    mouse1SPK(all(cellfun(@isempty,mouse1SPK),2),:) = [];



    mouse2SPK = K.SPK(:,2);
    mouse2SPK(all(cellfun(@isempty,mouse2SPK),2),:) = [];

    K.SPKm1 = mouse1SPK;
    K.SPKm2 = mouse2SPK;

    mouse1LFP = mean(raw_signal_final{1,1},2);
    mouse2LFP = mean(raw_signal_final{1,2},2);

    thetaBand = [4, 8]; % Theta band in Hz
    betaBand = [13, 30]; % Beta band in Hz
    lowGammaBand = [30, 50]; % Low Gamma band in Hz

    Fs = SamplingFreq; % Replace with your actual sampling rate

    for jj = 1:2
        if jj == 1
            spikeData = mouse1SPK;
            LFPdata = mouse1LFP;
        else
            spikeData = mouse2SPK;
            LFPdata = mouse2LFP;
        end

        if ~isempty(spikeData)
            spikeData_final = cell(size(spikeData));

            for i = 1:length(spikeData)
                spikes_temp = spikeData{i};
                spikes_temp = spikes_temp(spikes_temp>=di_start&spikes_temp<di_end);
                spikes_temp = spikes_temp-di_start;
                spikeData_final{i}=spikes_temp;
            end


            [wcoefs, freqs] = cwt(LFPdata, 'amor', Fs);


            % Find indices for frequency bands
            [~, thetaIdx] = min(abs(freqs - mean(thetaBand)));
            [~, betaIdx] = min(abs(freqs - mean(betaBand)));
            [~, lowGammaIdx] = min(abs(freqs - mean(lowGammaBand)));

            spikePhases = cell(size(spikeData_final,1), 3); % For each band

            for i = 1:length(spikeData_final)
                spikes = spikeData_final{i}; % Assuming these are in seconds
                spikes = round(spikes * Fs); % Convert to indices
                spikes(spikes < 1 | spikes > size(wcoefs, 2)) = []; % Remove invalid indices

                % Extract phases for each frequency band
                spikePhases{i, 1} = angle(wcoefs(thetaIdx, spikes)); % Theta
                spikePhases{i, 2} = angle(wcoefs(betaIdx, spikes)); % Beta
                spikePhases{i, 3} = angle(wcoefs(lowGammaIdx, spikes)); % Low Gamma
            end

            avgPhase = zeros(size(spikePhases,1), 3); % For each band
            for i = 1:size(spikePhases,1)
                avgPhase(i, 1) = circ_mean((spikePhases{i, 1})'); % Theta
                avgPhase(i, 2) = circ_mean((spikePhases{i, 2})'); % Beta
                avgPhase(i, 3) = circ_mean((spikePhases{i, 3})'); % Low Gamma

                temp = rad2deg(avgPhase(i,:));
                temp(temp<0) = temp(temp<0)+360;

                avgPhase(i,:) = temp;
            end



            %     % Bar plot for Theta band
            %     figure;
            %     bar(avgPhase(:, 1)); % Convert radians to degrees
            %     title('Average Phase for Theta Band');
            %     xlabel('Cell Index');
            %     ylabel('Average Phase (Degrees)');
            %     ylim([0 360]); % Set y-axis limits to cover the full range of phases in degrees
            %
            %     % Repeat for Beta and Low Gamma bands
            %     figure;
            %     bar(avgPhase(:, 2)); % Convert radians to degrees
            %     title('Average Phase for Beta Band');
            %     xlabel('Cell Index');
            %     ylabel('Average Phase (Degrees)');
            %     ylim([0 360]); % Set y-axis limits to cover the full range of phases in degrees
            %
            %     figure;
            %     bar(avgPhase(:, 3)); % Convert radians to degrees
            %     title('Average Phase for Low Gamma Band');
            %     xlabel('Cell Index');
            %     ylabel('Average Phase (Degrees)');
            %     ylim([0 360]); % Set y-axis limits to cover the full range of phases in degrees


            numCells = size(spikePhases,1);
            meanAngles = zeros(numCells, 3); % One column per frequency band
            angDevs = zeros(numCells, 3);
            vectorLengths = zeros(numCells, 3);
            rayleighPs = zeros(numCells, 3);
            rayleighZs = zeros(numCells, 3);

            for i = 1:numCells
                for j = 1:3 % Assuming 1: Theta, 2: Beta, 3: Low Gamma
                    [meanAngle, angDev, vectorLength, rayleighP, rayleighZ] = circularStat(spikePhases{i, j});

                    % Store results
                    meanAngles(i, j) = meanAngle;
                    angDevs(i, j) = angDev;
                    vectorLengths(i, j) = vectorLength;
                    rayleighPs(i, j) = rayleighP;
                    rayleighZs(i, j) = rayleighZ;
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
            else
                spikePhases_m1m2{1,2} = spikePhases;
                avgPhase_m1m2{1,2} = avgPhase;
                significantCells_m1m2{1,2} = significantCells;


            end

        else
        end

        save ('avgPhase','avgPhase_m1m2')
        save ('spikePhases','spikePhases_m1m2')
        save ('PhaseLockCells','significantCells_m1m2')
        save(K.date, 'K');

   
    end
    %cd('F:\Dual interaction - sorted\)')
    cd('H:\')
end


%     bands = {'Theta', 'Beta', 'Low Gamma'};
%     for j = 1:3
%         if ~isempty(significantCells{j})
%             figure;
%             bar(meanAngles(significantCells{j}, j));
%             xlabel('Cell Index');
%             ylabel('Mean Angle (Degrees)');
%             title(['Mean Angle of Significantly Phase-Locked Cells - ' bands{j}]);
%         end
%     end


%% plot
% Define colors for each band
colors = {[0.8500 0.3250 0.0980], [135, 206, 235]/255, [218, 165, 32]/255}; % sky blue and goldenrod colors are normalized (0-1)


for j = 1:3
    if ~isempty(significantCells{j})
        % Extract the mean angles for significant cells only
        significantMeanAngles = meanAngles(significantCells{j}, j);

        % Define the edges of the bins
        binEdges = 0:30:360; % Change the bin size if necessary

        % Create the histogram and get the values
        figure;
        [counts, edges] = histcounts(significantMeanAngles, 'BinEdges', binEdges);
        bar(edges(1:end-1) + 15, counts, 'FaceColor', colors{j}, 'EdgeColor', 'k');

        % Calculate the amplitude of the cosine wave based on the histogram
        maxCount = max(counts);
        amplitude = maxCount; % Set amplitude to match max count for visibility

        % Generate a cosine wave to overlay
        % The wave's trough will be at 180 degrees, which is pi radians
        xValues = linspace(0, 360, 1000); % Generate 1000 points for a smooth wave
        yValues = amplitude * (-cosd(xValues - 180) + 1)/2; % Flip the wave and shift vertically

        % Overlay the cosine wave
        hold on;
        plot(xValues, yValues, 'k-', 'LineWidth', 2);
        hold off;

        % Add labels and title
        xlabel('Phase (Degrees)');
        ylabel('Number of Cells');
        title(['Distribution of Preferred Phases - ' bands{j} ' Band']);

        % Optional: Set the limits and grid
        xlim([0 360]);
        set(gca, 'XTick', 0:30:360); % Adjust x-axis ticks to align with bin edges
        ylim([0, maxCount + (amplitude/2)]); % Adjust y-axis to fit the cosine wave
        grid on;
    end
end


% Choose a frequency band for visualization, for example, Theta (1), Beta (2), or Low Gamma (3)
bandIndex = 1; % Assuming 1 corresponds to Theta
significantCellIndex = 10;

% Get the phase data for the selected cell in degrees
significantCellPhases = spikePhases{significantCellIndex, bandIndex};
significantCellPhasesDeg = rad2deg(significantCellPhases); % Convert phases to degrees

% Adjust phases from [-180, 180] to [0, 360]
significantCellPhasesDeg(significantCellPhasesDeg < 0) = significantCellPhasesDeg(significantCellPhasesDeg < 0) + 360;


% Plot the histogram for this cell
figure;
histogram(significantCellPhasesDeg, 'BinEdges', 0:30:360, 'Normalization', 'count', 'FaceColor', colors{1}, 'EdgeColor', 'k');

% Overlay the cosine wave
hold on;
maxCount = max(histcounts(significantCellPhasesDeg, 'BinEdges', 0:30:360)); % Get the max count for scaling the cosine wave
amplitude = maxCount; % Set amplitude to match max count for visibility
xValues = linspace(0, 360, 1000); % Generate 1000 points for a smooth wave
yValues = amplitude * (-cosd(xValues - 180) + 1)/2; % Flip the wave and shift vertically
plot(xValues, yValues, 'k-', 'LineWidth', 2);
hold off;

% Add labels and title
xlabel('Phase (Degrees)');
ylabel('Spike Count');
title(['Spike Phase Distribution for Cell ' num2str(significantCellIndex) ' - ' bands{bandIndex} ' Band']);

% Optional: Set the limits and grid
xlim([0 360]);
set(gca, 'XTick', 0:30:360); % Adjust x-axis ticks to align with bin edges




