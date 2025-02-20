function plotLfpCorrelationOverTime(lfp_mouse1, lfp_mouse2, Fs, freqBands, smoothingWindow)
    % Average signal of mouse1 and mouse2 across all channels
    avg_lfp_mouse1 = mean(lfp_mouse1, 2);
    avg_lfp_mouse2 = mean(lfp_mouse2, 2);
    
    % Determine the number of segments (each segment is 1 second)
    numSegments = floor(min(length(avg_lfp_mouse1), length(avg_lfp_mouse2)) / Fs);

    % Wavelet parameters
    waveletName = 'db4'; % Daubechies wavelet

    % Maximum decomposition level
    maxDecompLevel = wmaxlev(length(avg_lfp_mouse1), waveletName);

    % Determine the decomposition levels for the specified frequency bands
    decompLevels = determineDecompLevels(Fs, maxDecompLevel, freqBands, waveletName);

    % Preallocate matrix for correlation coefficients
    correlationMatrix = zeros(numSegments, length(freqBands));

    % Calculate correlation for each one-second segment
    for seg = 1:numSegments
        startIdx = (seg - 1) * Fs + 1;
        endIdx = seg * Fs;

        % Decompose signals
        [cA1, cD1] = wavedec(avg_lfp_mouse1(startIdx:endIdx), maxDecompLevel, waveletName);
        [cA2, cD2] = wavedec(avg_lfp_mouse2(startIdx:endIdx), maxDecompLevel, waveletName);

        % Calculate correlation for each frequency band
        for band = 1:length(freqBands)
            level = decompLevels(band);
            detail1 = detcoef(cA1, cD1, level);
            detail2 = detcoef(cA2, cD2, level);

            % Store the correlation coefficient
            correlationMatrix(seg, band) = corr(detail1(:), detail2(:));
        end
    end

    % Smooth the data
    for band = 1:length(freqBands)
        correlationMatrix(:, band) = smoothdata(correlationMatrix(:, band), 'movmean', smoothingWindow);
    end

    % Plot the correlation coefficients over time for each frequency band in subplots
    figure;
    % Find global y-axis limits
    globalMin = min(correlationMatrix, [], 'all');
    globalMax = max(correlationMatrix, [], 'all');

    for band = 1:length(freqBands)
        subplot(length(freqBands), 1, band);
        plotData = correlationMatrix(:, band);
        plot(1:numSegments, plotData);
        ylim([globalMin, globalMax]); % Standardize y-axis
        xlabel('Time (seconds)');
        ylabel('Correlation Coeff.');
        title(sprintf('Frequency Band %d-%d Hz', freqBands(band, 1), freqBands(band, 2)));
        
        % Mark values above 0.4
        hold on;
        highValueIndices = find(plotData > 0.4);
        plot(highValueIndices, plotData(highValueIndices), 'r.', 'MarkerSize', 10);

        % Overlay mouse behavior
        overlayMouseBehavior(S_NS_Vector, ii, 4, 6, TopRange, BottomRange); % Mouse 1
        overlayMouseBehavior(S_NS_Vector, ii, 5, 7, TopRange, BottomRange); % Mouse 2

     
        hold off;
    end
end

function decompLevels = determineDecompLevels(Fs, maxLevel, freqBands, waveletName)
    % Frequency range for each decomposition level
    freqRange = Fs / 2 ./ (2.^(1:maxLevel));

    % Find the decomposition level for each frequency band
    decompLevels = arrayfun(@(x) find(freqRange <= freqBands(x, 1), 1, 'first') - 1, 1:size(freqBands, 1));
    decompLevels(decompLevels < 1) = 1;
    decompLevels(decompLevels > maxLevel) = maxLevel;
end
