function correlationCoeffs = calculateWaveletCorrelation(wt1, wt2, freqs, freqBands)
    numBands = size(freqBands, 1);
    correlationCoeffs = zeros(numBands, 1);
    for band = 1:numBands
        bandIndices = freqs >= freqBands(band, 1) & freqs <= freqBands(band, 2);
        bandData1 = mean(abs(wt1(bandIndices, :)), 1);
        bandData2 = mean(abs(wt2(bandIndices, :)), 1);
        correlationCoeffs(band) = corr(bandData1', bandData2');
    end
end