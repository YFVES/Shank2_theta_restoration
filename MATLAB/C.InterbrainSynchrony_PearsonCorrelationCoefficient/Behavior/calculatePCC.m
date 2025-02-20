function PCC = calculatePCC(raw_signal, start_idx, end_idx, b, a, params)
    PCCs = [];
    for jj = 1:8 % Assuming 8 channels
        % Process data for mouse 1
        data1 = raw_signal{1,1}(start_idx:end_idx, jj);
        data_filtered1 = filtfilt(b, a, data1);
        [S1, ~, ~, ~] = mtspecgramc(data_filtered1, [2 0.5], params);

        % Process data for mouse 2
        data2 = raw_signal{1,2}(start_idx:end_idx, jj);
        data_filtered2 = filtfilt(b, a, data2);
        [S2, ~, ~, ~] = mtspecgramc(data_filtered2, [2 0.5], params);

        % Sum power across frequencies
        power1 = sum(S1, 2);
        power2 = sum(S2, 2);

        % Ensure non-empty and equal-length vectors before calculating correlation
        if ~isempty(power1) && ~isempty(power2) && length(power1) == length(power2)
            PCCs(jj) = (corr(power1, power2, 'type', 'Pearson'));
        else
            PCCs(jj) = NaN; % Use NaN for channels where PCC can't be computed
        end
    end

    % Average PCC across all channels for this segment, ignoring NaN values
    PCC = nanmean(PCCs);
end