function correlationCoeffs = calculateLfpCorrelation(lfp_mouse1, lfp_mouse2, Fs)
    % Number of channels
    numChannels = size(lfp_mouse1, 2);
    
    % Check if both signals have the same number of channels
    if size(lfp_mouse2, 2) ~= numChannels
        error('The two signals must have the same number of channels');
    end

    % Preallocate array for correlation coefficients
    correlationCoeffs = zeros(numChannels, 1);

    % Wavelet parameters (you may need to adjust these)
    waveletName = 'db4'; % Daubechies wavelet
    decompositionLevel = 5; % Level of wavelet decomposition

    % Calculate correlation for each channel
    for ch = 1:numChannels
        % Initialize temporary correlation array for each segment
        tempCorr = [];
        
        % Process each second of data
        for startIdx = 1:Fs:size(lfp_mouse1, 1)
            endIdx = min(startIdx + Fs - 1, size(lfp_mouse1, 1));
            
            % Wavelet decomposition for the current segment
            [cA1, ~] = wavedec(lfp_mouse1(startIdx:endIdx, ch), decompositionLevel, waveletName);
            [cA2, ~] = wavedec(lfp_mouse2(startIdx:endIdx, ch), decompositionLevel, waveletName);

            % Calculate correlation for the current segment
            tempCorr = [tempCorr, corr(cA1(:), cA2(:))];
        end

        % Calculate the mean correlation across all segments
        correlationCoeffs(ch) = nanmean(tempCorr);
    end
end
