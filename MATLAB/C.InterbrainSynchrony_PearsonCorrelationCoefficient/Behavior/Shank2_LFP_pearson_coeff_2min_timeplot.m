main = cd;
files = dir('2023-*');
foldernames = char(files.name);

PCC_all = {};

for ii = 1:length(foldernames)  % Uncomment to process all folders
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    load(struct_name, '-mat');

    mouse1ID = foldern(end-8:end-5);
    mouse2ID = foldern(end-3:end);

    if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        if isfile(strcat(struct_name,'_LFP.mat'))
            load(strcat(struct_name,'_LFP.mat'));

            di_start = (K.Event{1,4}(1))/1000000; % Convert microsecond to second
            di_finish = (K.Event{1,4}(2))/1000000; % Convert microsecond to second

            current_data_folder = cd;

            cd C:\Users\USER\Desktop\M1_sees_M2

            csv_filename = strcat(K.date, '_','M1_sees_M2','.csv');

            if ~isfile (csv_filename)
                cd(current_data_folder)
                
            else

                data = readtable(csv_filename);

                if size(data,1)>17982

                    data = data{1:17982,2};
                else
                    data = data{:,2};
                end

                % Initialize variables to store start and end positions
                start_positions = [];
                end_positions = [];

                % Find the start and end positions of the 1s
                is_inside_bout = false;
                for i = 1:length(data)
                    if data(i) == 1
                        if ~is_inside_bout
                            start_positions = [start_positions, i];
                            is_inside_bout = true;
                        end
                    else
                        if is_inside_bout
                            end_positions = [end_positions, i - 1];
                            is_inside_bout = false;
                        end
                    end
                end

                % If a bout of 1s ends at the end of the vector, add it to end_positions
                if is_inside_bout
                    end_positions = [end_positions, length(data)];
                end


                social_gaze_m1 = [start_positions;end_positions]';
                social_gaze_m1 = social_gaze_m1 / 29.97;
                social_gaze_m1 (:,3) = social_gaze_m1(:,2) - social_gaze_m1(:,1);


                %mouse2 social gaze

                cd C:\Users\USER\Desktop\M2_sees_M1

                csv_filename = strcat(K.date, '_','M2_sees_M1','.csv');

                data = readtable(csv_filename);

                if size(data,1)>17982

                    data = data{1:17982,2};
                else
                    data = data{:,2};
                end

                % Initialize variables to store start and end positions
                start_positions = [];
                end_positions = [];

                % Find the start and end positions of the 1s
                is_inside_bout = false;
                for i = 1:length(data)
                    if data(i) == 1
                        if ~is_inside_bout
                            start_positions = [start_positions, i];
                            is_inside_bout = true;
                        end
                    else
                        if is_inside_bout
                            end_positions = [end_positions, i - 1];
                            is_inside_bout = false;
                        end
                    end
                end

                % If a bout of 1s ends at the end of the vector, add it to end_positions
                if is_inside_bout
                    end_positions = [end_positions, length(data)];
                end


                social_gaze_m2 = [start_positions;end_positions]';
                social_gaze_m2 = social_gaze_m2 / 29.97;
                social_gaze_m2 (:,3) = social_gaze_m2(:,2) - social_gaze_m2(:,1);

                cd (current_data_folder);
%                 %% compile all social gaze timestamps
% 
%                 social_gaze_total = [social_gaze_m1; social_gaze_m2];
%                 social_gaze_total = sortrows(social_gaze_total);
%                 social_gaze_total(:,3) = social_gaze_total(:,2) - social_gaze_total(:,1);
% 
%                 social_gaze_total_final = [];
%                 sss = 1;
%                 for ss = 1:length(social_gaze_total)
%                     if social_gaze_total(ss,3)>1
%                         social_gaze_total_final(sss,:) = social_gaze_total(ss,:);
%                         sss = sss+1;
%                     else
% 
%                     end
%                 end
                %% m1 m2 separately

                social_gaze_total_m1 = [];
                sss = 1;

                for ss = 1:length(social_gaze_m1)
                    if social_gaze_m1(ss,3)>0
                        social_gaze_total_m1(sss,:) = social_gaze_m1(ss,:);
                        sss = sss+1;
                    else

                    end
                end


                social_gaze_total_m2 = [];
                sss = 1;

                for ss = 1:length(social_gaze_m2)
                    if social_gaze_m2(ss,3)>0
                        social_gaze_total_m2(sss,:) = social_gaze_m2(ss,:);
                        sss = sss+1;
                    else

                    end
                end





                % Import social behavior data for both mice
                m1_socialgaze = social_gaze_total_m1;
                m2_socialgaze = social_gaze_total_m2;
                m1_socialgaze = sortrows(m1_socialgaze(:,1:2));
                m2_socialgaze = sortrows(m2_socialgaze(:,1:2));

                % LFP data processing parameters
                Fs = SamplingFreq;
                params.Fs = Fs;
                params.tapers = [3 5];
                params.fpass = [4 100];
                params.trialave = 0;
                params.pad = 1;
                params.err = [2 0.05];

                % Define notch filter
                notch_freq = 60; % 60 Hz line noise
                notch_width = 2; % 2 Hz bandwidth around notch frequency
                [b, a] = butter(2, [(notch_freq - notch_width/2)/(Fs/2), (notch_freq + notch_width/2)/(Fs/2)], 'stop');

                % Define the fixed number of windows
                num_windows = 10;

                % Calculate the length of each window based on the session duration
                total_session_time = 600;
                window_length = total_session_time / num_windows;

                % Initialize arrays for PCC and behavior durations
                PCCs = [];
                m1_social_durations = [];
                m2_social_durations = [];

                for seg = 1:num_windows
                    window_start_time = 0 + (seg - 1) * window_length;
                    window_end_time = window_start_time + window_length;

                    % Behavior duration calculation within the window
                    m1_duration = calculateBehaviorDuration(m1_socialgaze, window_start_time, window_end_time);
                    m2_duration = calculateBehaviorDuration(m2_socialgaze, window_start_time, window_end_time);
                    m1_social_durations = [m1_social_durations, m1_duration];
                    m2_social_durations = [m2_social_durations, m2_duration];

                    % LFP data segment indices - ensure indices are integers
                    start_idx = round((window_start_time) * Fs) + 1;
                    end_idx = min(round(start_idx + window_length * Fs - 1), length(raw_signal_final{1,1}(:,1)));

                    % Calculate PCC for this window
                    PCC_segment = calculatePCC(raw_signal_final, start_idx, end_idx, b, a, params);
                    PCCs = [PCCs, PCC_segment];
                end

                % Store results
                PCC_all{ii,1} = struct_name;
                PCC_all{ii,2} = PCCs;
                PCC_all{ii,3} = mouse1ID;
                PCC_all{ii,4} = mouse2ID;
                PCC_all{ii,5} = m1_social_durations;
                PCC_all{ii,6} = m2_social_durations;
            end
        else
        end

   end
    cd(main); % Return to the main directory after processing each folder
end

%% plotting individual figures
% figure;
%
% % Left Y-axis for Social Behavior Duration
% yyaxis left;
% bar_width = 0.35; % Width of the bars in the bar graph
% time_edges = 0:(window_length):total_session_time; % Edges of each time window
%
% % Positions for each set of bars
% positions1 = time_edges(1:end-1) + bar_width/2;
% positions2 = time_edges(1:end-1) + bar_width + bar_width/2;
%
% % Plotting the bars for social behavior duration
% bar(positions1, PCC_all{3,5}, bar_width, 'FaceColor', [0.2, 0.6, 1]); % Mouse 1 durations in lighter blue
% hold on;
% bar(positions2, PCC_all{3,6}, bar_width, 'FaceColor', [1, 0.2, 0.2]); % Mouse 2 durations in lighter red
% ylabel('Duration of Social Behavior (seconds)');
%
% % Right Y-axis for PCC
% yyaxis right;
% time_centers = (0.5 * window_length):(window_length):total_session_time; % Center of each time window
% plot(time_centers, PCC_all{3,2}, 'o-', 'MarkerFaceColor', 'k', 'Color', 'k'); % PCC plot in black for contrast
% ylabel('Pearson Correlation Coefficient (PCC)');
%
% % Shared X-axis and title
% xlabel('Time (seconds)');
% title('Social Behavior Duration and PCC Over Time');
% legend('Mouse 1 Duration', 'Mouse 2 Duration', 'PCC', 'Location', 'best');
% grid on;


%% plot average values for each trial type
PCC_all(all(cellfun(@isempty, PCC_all),2),:) = [];
% Define the fixed number of windows
num_windows = 10;

% Calculate the length of each window based on the session duration
total_session_time = 600;
window_length = total_session_time / num_windows;
% Initialize containers for sums and counters
trial_types = {'WT_WT', 'KO_KO', 'WT_KO'};
% Initialize containers for data accumulation, keyed by trial type
PCC_values = struct('WT_WT', [], 'KO_KO', [], 'WT_KO', []);
social_values = struct('WT_WT', [], 'KO_KO', [], 'WT_KO', []);

for i = 1:length(PCC_all)
    entry = PCC_all(i,:);
    mouse1ID = entry{3};
    mouse2ID = entry{4};

    % Determine trial type
    if contains(mouse1ID, 'WT') && contains(mouse2ID, 'WT')
        trial_type = 'WT_WT';
    elseif contains(mouse1ID, 'KO') && contains(mouse2ID, 'KO')
        trial_type = 'KO_KO';
    else
        trial_type = 'WT_KO';
    end

    % Accumulate PCC and social behavior values for each window
    PCC_values.(trial_type) = [PCC_values.(trial_type); entry{2}];  % Assuming entry{2} holds PCC values for all windows
    % Combine social behavior durations for both mice and accumulate
    combined_social = mean([entry{5}; entry{6}], 1);  % Assuming entry{5} and {6} hold social behavior durations for mice 1 and 2, respectively
    social_values.(trial_type) = [social_values.(trial_type); combined_social];
end

% Calculate averages per window for each trial type
average_PCC_per_window = structfun(@(x) nanmean(x, 1), PCC_values, 'UniformOutput', false);
average_social_per_window = structfun(@(x) nanmean(x, 1), social_values, 'UniformOutput', false);

% Assuming 'time_windows' represents the center of each time window
time_windows = linspace(1, num_windows, num_windows);  % Update as needed

figure; hold on;

% Set colors for each trial type
colors = lines(numel(trial_types));

% Social Behavior Duration Bar Graphs - Use Left Y-Axis
yyaxis left;
for i = 1:numel(trial_types)
    trial_type = trial_types{i};
    bar_positions = time_windows + (i - (numel(trial_types)+1) / 2) * 0.1;  % Offset each trial type to avoid bar overlap
    bar(bar_positions, average_social_per_window.(trial_type), 0.1, 'FaceColor', colors(i,:), 'EdgeColor', 'none', 'DisplayName', [trial_type ' Social Duration']);
end
ylabel('Average Social Behavior Duration (sec)');
% Ensure the limits are applied correctly by setting them again
set(gca, 'YLim', [0, 45]);

% PCC Plot with Shaded Error Bars - Use Right Y-Axis

yyaxis right;
for i = 1:numel(trial_types)
    trial_type = trial_types{i};

    % Original PCC data
    mean_PCC = nanmean(PCC_values.(trial_type), 1);
    sem_PCC = nanstd(PCC_values.(trial_type), 0, 1) ./ sqrt(sum(~isnan(PCC_values.(trial_type)), 1));

    % Interpolation for smoothing
    fine_time_windows = linspace(min(time_windows), max(time_windows), 300);  % Create a finer grid
    smooth_mean_PCC = interp1(time_windows, mean_PCC, fine_time_windows, 'pchip');  % 'pchip' for smooth interpolation
    smooth_sem_PCC = interp1(time_windows, sem_PCC, fine_time_windows, 'pchip');

    % Upper and lower bounds for shaded area on the fine grid
    upper_bound_smooth = smooth_mean_PCC + smooth_sem_PCC;
    lower_bound_smooth = smooth_mean_PCC - smooth_sem_PCC;

    % Fill shaded area with smoothed bounds
    fill([fine_time_windows, fliplr(fine_time_windows)], [upper_bound_smooth, fliplr(lower_bound_smooth)], colors(i,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % Plot smoothed mean line on top
    plot(fine_time_windows, smooth_mean_PCC, 'Color', colors(i,:), 'LineWidth', 2, 'DisplayName', [trial_type ' PCC']);
end

ylabel('PCC');


% Ensure the limits are applied correctly by setting them again
set(gca, 'YLim', [0, 0.3]);

xlabel('Time Window');
title('Social Behavior Duration and PCC Over Time by Trial Type');
% legend('show');
% grid on;

% Adjust x-axis limits to fit the time window range
xlim([min(time_windows) - 0.5, max(time_windows) + 0.5]);  % Extend limits slightly to accommodate bars and lines

%% separate graphs for each trial type

PCC_all(all(cellfun(@isempty, PCC_all),2),:) = [];
% Define the fixed number of windows
num_windows = 10;

% Calculate the length of each window based on the session duration
total_session_time = 600;
window_length = total_session_time / num_windows;
% Initialize containers for sums and counters
trial_types = {'WT_WT', 'KO_KO', 'WT_KO'};
% Initialize containers for data accumulation, keyed by trial type
PCC_values = struct('WT_WT', [], 'KO_KO', [], 'WT_KO', []);
social_values = struct('WT_WT', [], 'KO_KO', [], 'WT_KO', []);

for i = 1:length(PCC_all)
    entry = PCC_all(i,:);
    mouse1ID = entry{3};
    mouse2ID = entry{4};

    % Determine trial type
    if contains(mouse1ID, 'WT') && contains(mouse2ID, 'WT')
        trial_type = 'WT_WT';
    elseif contains(mouse1ID, 'KO') && contains(mouse2ID, 'KO')
        trial_type = 'KO_KO';
    else
        trial_type = 'WT_KO';
    end

    % Accumulate PCC and social behavior values for each window
    PCC_values.(trial_type) = [PCC_values.(trial_type); entry{2}];  % Assuming entry{2} holds PCC values for all windows
    % Combine social behavior durations for both mice and accumulate
    combined_social = mean([entry{5}; entry{6}], 1);  % Assuming entry{5} and {6} hold social behavior durations for mice 1 and 2, respectively
    social_values.(trial_type) = [social_values.(trial_type); combined_social];
end

%% without interpolation 

% Assuming 'time_windows' represents the center of each time window
time_windows = linspace(1, num_windows, num_windows);  % Update as needed

% Define trial types
trial_types = {'WT_WT', 'KO_KO', 'WT_KO'};


% Calculate averages and SEMs per window for each trial type
average_PCC_per_window = structfun(@(x) nanmean(x, 1), PCC_values, 'UniformOutput', false);
sem_PCC_per_window = structfun(@(x) nanstd(x, 0, 1) ./ sqrt(sum(~isnan(x), 1)), PCC_values, 'UniformOutput', false);

average_social_per_window = structfun(@(x) nanmean(x, 1), social_values, 'UniformOutput', false);
sem_social_per_window = structfun(@(x) nanstd(x, 0, 1) ./ sqrt(sum(~isnan(x), 1)), social_values, 'UniformOutput', false);

% Set colors for each trial type
colors = lines(numel(trial_types));

% Loop over each trial type to create separate figures
for t = 1:numel(trial_types)
    trial_type = trial_types{t};

    % New figure for each trial type
    figure; hold on;

    % Social Behavior Duration with Shaded Error Bars - Use Left Y-Axis
    yyaxis left;
    % Calculate upper and lower bounds for social behavior
    upper_bound_social = average_social_per_window.(trial_type) + sem_social_per_window.(trial_type);
    lower_bound_social = average_social_per_window.(trial_type) - sem_social_per_window.(trial_type);

    % Fill shaded area for social behavior
    fill([time_windows, fliplr(time_windows)], [upper_bound_social, fliplr(lower_bound_social)], colors(t,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    plot(time_windows, average_social_per_window.(trial_type), 'Color', colors(t,:), 'LineWidth', 2, 'DisplayName', [trial_type ' Social Duration']);
    ylabel('Average Social Behavior Duration (sec)');
    ylim([0, max(upper_bound_social) * 1.1]);

    % Ensure the limits are applied correctly by setting them again
    ylim([0, 45]);
    xlim([1 10]); 

    % Linear Regression on Social Behavior Duration
    [p, S] = polyfit(time_windows, average_social_per_window.(trial_type), 1);
    % Retrieve regression values for plotting
    y_fit = polyval(p, time_windows);
    % Plot the regression line
    plot(time_windows, y_fit, 'k--', 'LineWidth', 2, 'DisplayName', 'Linear Fit');

    % Test if the slope is significantly different from 0
    [b, bint, r, rint, stats] = regress(average_social_per_window.(trial_type)', [ones(num_windows, 1) time_windows']);
    p_value = stats(3); % P-value for the regression
    R_square = stats(1); % R-squared value

    % Display slope, p-value, and R-squared on the plot
    text_info = sprintf('Slope: %.3f\np-value: %.3f\nR^2: %.3f', b(2), p_value, R_square);
    text(max(time_windows) * 0.7, max(average_social_per_window.(trial_type)) * 0.9, text_info, 'FontSize', 10, 'BackgroundColor', 'white');
    
    % PCC Plot with Shaded Error Bars - Use Right Y-Axis
    yyaxis right;
    
    % Original PCC data
    mean_PCC = nanmean(PCC_values.(trial_type), 1);
    sem_PCC = nanstd(PCC_values.(trial_type), 0, 1) ./ sqrt(sum(~isnan(PCC_values.(trial_type)), 1));

    % Interpolation for smoothing
    fine_time_windows = linspace(min(time_windows), max(time_windows), 10);  % Create a finer grid
    smooth_mean_PCC = interp1(time_windows, mean_PCC, fine_time_windows, 'pchip');  % 'pchip' for smooth interpolation
    smooth_sem_PCC = interp1(time_windows, sem_PCC, fine_time_windows, 'pchip');

    % Upper and lower bounds for shaded area on the fine grid
    upper_bound_smooth = smooth_mean_PCC + smooth_sem_PCC;
    lower_bound_smooth = smooth_mean_PCC - smooth_sem_PCC;

    % Fill shaded area with smoothed bounds
    fill([fine_time_windows, fliplr(fine_time_windows)], [upper_bound_smooth, fliplr(lower_bound_smooth)], colors(t,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % Plot smoothed mean line on top
    plot(fine_time_windows, smooth_mean_PCC, 'Color', colors(t,:), 'LineWidth', 2, 'DisplayName', [trial_type ' PCC']);

    ylabel('PCC');
    ylim([0, 0.4]);
    xlabel('Time Window');
    title(['Social Behavior Duration and PCC Over Time - ' trial_type]);
    xlim([min(time_windows) - 0.5, max(time_windows) + 0.5]);

   
    %grid on;
end


%% original

% Calculate averages per window for each trial type
average_PCC_per_window = structfun(@(x) nanmean(x, 1), PCC_values, 'UniformOutput', false);
average_social_per_window = structfun(@(x) nanmean(x, 1), social_values, 'UniformOutput', false);

% Assuming 'time_windows' represents the center of each time window
time_windows = linspace(1, num_windows, num_windows);  % Update as needed

% Define trial types
trial_types = {'WT_WT', 'KO_KO', 'WT_KO'};

% Set colors for each trial type
colors = lines(numel(trial_types));

% Loop over each trial type to create separate figures
for t = 1:numel(trial_types)
    trial_type = trial_types{t};

    % New figure for each trial type
    figure; hold on; 

    % Assuming 'time_windows' represents the center of each time window
    time_windows = linspace(1, num_windows, num_windows);

    % Social Behavior Duration Line Plot - Use Left Y-Axis
    yyaxis left;
    plot(time_windows, average_social_per_window.(trial_type), 'Color', colors(t,:), 'LineWidth', 2, 'DisplayName', [trial_type ' Social Duration']);
    ylabel('Average Social Behavior Duration (sec)');
    
    % Ensure the limits are applied correctly by setting them again
    ylim([0, 45]);

    % PCC Plot with Shaded Error Bars - Use Right Y-Axis
    yyaxis right;

    % Original PCC data
    mean_PCC = nanmean(PCC_values.(trial_type), 1);
    sem_PCC = nanstd(PCC_values.(trial_type), 0, 1) ./ sqrt(sum(~isnan(PCC_values.(trial_type)), 1));

    % Interpolation for smoothing
    fine_time_windows = linspace(min(time_windows), max(time_windows), 300);  % Create a finer grid
    smooth_mean_PCC = interp1(time_windows, mean_PCC, fine_time_windows, 'pchip');  % 'pchip' for smooth interpolation
    smooth_sem_PCC = interp1(time_windows, sem_PCC, fine_time_windows, 'pchip');

    % Upper and lower bounds for shaded area on the fine grid
    upper_bound_smooth = smooth_mean_PCC + smooth_sem_PCC;
    lower_bound_smooth = smooth_mean_PCC - smooth_sem_PCC;

    % Fill shaded area with smoothed bounds
    fill([fine_time_windows, fliplr(fine_time_windows)], [upper_bound_smooth, fliplr(lower_bound_smooth)], colors(t,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % Plot smoothed mean line on top
    plot(fine_time_windows, smooth_mean_PCC, 'Color', colors(t,:), 'LineWidth', 2, 'DisplayName', [trial_type ' PCC']);

    ylabel('PCC');
    ylim([0, 0.5]);

    xlabel('Time Window');
    title(['Social Behavior Duration and PCC Over Time - ' trial_type]);
    xlim([min(time_windows) - 0.5, max(time_windows) + 0.5]);  % Extend limits slightly to accommodate lines

    legend('show');
    %grid on;
end

