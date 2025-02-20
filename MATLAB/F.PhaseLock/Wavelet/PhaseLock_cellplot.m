%% plot all significantly phased locked cell. num of cells as y axis. phase as x axis.
% Define colors for each band
colors = {[0.8500 0.3250 0.0980], [135, 206, 235]/255, [218, 165, 32]/255}; % sky blue and goldenrod colors are normalized (0-1)

bands = {'Theta', 'Beta', 'Low Gamma'};




load('avgPhase.mat')
load('meanAngles.mat')
load('PhaseLockCells.mat')
load('spikePhases.mat')




for i = 1:2
    for j = 1:3
        significantCells = significantCells_m1m2{1,i}{1,j};
        meanAngles = meanAngles_m1m2{1,i};
        if ~isempty(significantCells)

            % Create a single figure with three subplots
           % figure('Position',[100, 100, 2000, 400])
            % Extract the mean angles for significant cells only
            significantMeanAngles = meanAngles(significantCells);

            % Define the edges of the bins
            binEdges = 0:30:360; % Change the bin size if necessary

%             % Create the subplot
%             subplot(2, 3, j);
% 
%             % Create the histogram and get the values
%             [counts, edges] = histcounts(significantMeanAngles, 'BinEdges', binEdges);
%             bar(edges(1:end-1) + 15, counts, 'FaceColor', colors{j}, 'EdgeColor', 'k');
% 
%             % Calculate the amplitude of the cosine wave based on the histogram
%             maxCount = max(counts);
%             amplitude = maxCount; % Set amplitude to match max count for visibility
% 
%             % Generate a cosine wave to overlay
%             % The wave's trough will be at 180 degrees, which is pi radians
%             xValues = linspace(0, 360, 1000); % Generate 1000 points for a smooth wave
%             yValues = amplitude * (-cosd(xValues - 180) + 1)/2; % Flip the wave and shift vertically
% 
%             % Overlay the cosine wave
%             hold on;
%             plot(xValues, yValues, 'k-', 'LineWidth', 1);
%             hold off;
% 
%             % Add labels and title
%             xlabel('Phase (Degrees)');
%             ylabel('Number of Cells');
%             title(['Distribution of Preferred Phases - ' bands{j} ' Band']);
% 
%             % Optional: Set the limits and grid
%             xlim([0 360]);
%             set(gca, 'XTick', 0:30:360); % Adjust x-axis ticks to align with bin edges
%             ylim([0, maxCount + (amplitude/2)]); % Adjust y-axis to fit the cosine wave

          
%             Choose a frequency band for visualization, for example, Theta (1), Beta (2), or Low Gamma (3)

            significantCellIndex = significantCells;
            spikePhases = spikePhases_m1m2{1,i};

            for yy = 1:length(significantCells)
                % Get the phase data for the selected cell in degrees
                significantCellPhases = spikePhases{significantCellIndex(yy),j};
                significantCellPhasesDeg = rad2deg(significantCellPhases); % Convert phases to degrees

                % Adjust phases from [-180, 180] to [0, 360]
                significantCellPhasesDeg(significantCellPhasesDeg < 0) = significantCellPhasesDeg(significantCellPhasesDeg < 0) + 360;


                % Plot the histogram for this cell
                figure;
                histogram(significantCellPhasesDeg, 'BinEdges', 0:30:360, 'Normalization', 'count', 'FaceColor', colors{j}, 'EdgeColor', 'k');

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
                title(['Spike Phase Distribution for Cell ' num2str(significantCellIndex(yy)) ' - ' bands{j} ' Band']);

                % Optional: Set the limits and grid
                xlim([0 360]);
                set(gca, 'XTick', 0:30:360); % Adjust x-axis ticks to align with bin edges

            end
        end


    end
end


%% plot polar histograms

% Loop through each i and j
for i = 1:2
    for j = 1:3
         significantCells = significantCells_m1m2{1,i}{1,j};

        % Check if there are significant cells to plot
        if ~isempty(significantCells)

            % Loop through each significant cell
            for k = 1:numel(significantCells)
                
                % Retrieve the cell angles for the significant cell 'k'
                cellAngles = spikePhases{significantCells(k),j};
                cellAngles = rad2deg(cellAngles); % Convert angles to degrees
                cellAngles(cellAngles < 0) = cellAngles(cellAngles < 0) + 360;

                % Calculate the counts for each bin for the polar histogram
                 [counts, edges] = histcounts(cellAngles, binEdges);

                % Polar histogram
                polarFig = figure;
                pax = polaraxes(polarFig);
                hold on;

                % Plot the polar histogram using the same counts and bin edges
                for bin = 1:numel(counts)
                    polarhistogram(pax, 'BinEdges', deg2rad([edges(bin), edges(bin+1)]), 'BinCounts', counts(bin), 'FaceColor', colors{j}, 'EdgeColor', 'none');
                end
                % Add title or other annotations as needed
                title(pax, ['Cell ' num2str(significantCells(k)) ' - Distribution']);

                hold on; % Release the figure for further commands

                % Calculate the mean phase using vector addition
                mean_x = mean(cos(deg2rad(cellAngles)));
                mean_y = mean(sin(deg2rad(cellAngles)));
                mean_phase_rad = atan2(mean_y, mean_x);
                mean_phase_deg = rad2deg(mean_phase_rad);

                % Calculate the unit vector length (mean resultant length)
                vector_length = sqrt(mean_x^2 + mean_y^2);

                % Get the current r-axis limits of the polar axes
                rlim = get(pax, 'RLim'); 

                % Adjust the line length based on the vector length
                line_length = rlim(2) * vector_length;

                % Plot the mean phase line with adjusted length
                polarplot(pax, [mean_phase_rad mean_phase_rad], [0, line_length], 'r-', 'LineWidth', 2);

                hold off; % Release the figure for further commands

            end

        end
    end
end

