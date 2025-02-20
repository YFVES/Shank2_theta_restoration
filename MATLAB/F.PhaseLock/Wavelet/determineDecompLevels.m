function decompLevels = determineDecompLevels(Fs, maxLevel, freqBands, waveletName)
    % Frequency range for each decomposition level
    freqRange = Fs / 2 ./ (2.^(1:maxLevel));

    % Find the decomposition level for each frequency band
    decompLevels = arrayfun(@(x) find(freqRange <= freqBands(x, 1), 1, 'first') - 1, 1:size(freqBands, 1));
    decompLevels(decompLevels < 1) = 1;
    decompLevels(decompLevels > maxLevel) = maxLevel;
end
