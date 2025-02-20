function lfpData = extractLfpData(rawSignal, startTime, endTime, Fs)
    startIndex = round(startTime * Fs);
    endIndex = round(endTime * Fs);
    lfpData = rawSignal(startIndex:endIndex);
end