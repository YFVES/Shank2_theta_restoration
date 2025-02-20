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


for ii = 1%:length(foldernames)

    spikePhases_m1m2 = {};
    avgPhase_m1m2 = {};
    significantCells_m1m2 = {};


    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);

    load(struct_name, '-mat')

    if isfile (strcat(struct_name,'_LFP.mat'))
        load(strcat(struct_name,'_LFP.mat'))


        di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
        di_end = (K.Event{1,4}(2))/1000000; %microsecond to second

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

            mouse1LFP = mean(raw_signal_final{1,1},2);
            mouse2LFP = mean(raw_signal_final{1,2},2);

            thetaBand = [4, 12]; % Theta band in Hz
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
                        meanAngles_m1m2{1,1} = meanAngles;
                        sigCellspvalue_m1m2{1,1} =rayleighPs;
                        vectorLengths_m1m2 {1,1} = vectorLengths;
                    else
                        spikePhases_m1m2{1,2} = spikePhases;
                        avgPhase_m1m2{1,2} = avgPhase;
                        significantCells_m1m2{1,2} = significantCells;
                        meanAngles_m1m2{1,2} = meanAngles;
                        sigCellspvalue_m1m2{1,2} =rayleighPs;
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
