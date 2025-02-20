
% Function to plot phases in a polar plot
function plotSpikePhases(phases, titleStr)
    figure;
    polarplot([phases; phases], [zeros(size(phases)); ones(size(phases))], 'o');
    title(titleStr);
end