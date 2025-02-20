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
    ylim([0, 45]); % Ensuring proper Y-axis limits for social behavior
    xlim([1, 10]);

    % PCC Plot with Shaded Error Bars - Use Right Y-Axis
    yyaxis right;

    % Original PCC data
    mean_PCC = nanmean(PCC_values.(trial_type), 1);
    sem_PCC = nanstd(PCC_values.(trial_type), 0, 1) ./ sqrt(sum(~isnan(PCC_values.(trial_type)), 1));

    % Upper and lower bounds for PCC
    upper_bound_PCC = mean_PCC + sem_PCC;
    lower_bound_PCC = mean_PCC - sem_PCC;

    % Fill shaded area for PCC
    fill([time_windows, fliplr(time_windows)], [upper_bound_PCC, fliplr(lower_bound_PCC)], colors(t,:), 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    plot(time_windows, mean_PCC, 'Color', colors(t,:), 'LineWidth', 2, 'DisplayName', [trial_type ' PCC']);

    ylabel('PCC');
    ylim([0, 0.4]);
    xlabel('Time Window');
    title(['Social Behavior Duration and PCC Over Time - ' trial_type]);
    xlim([1, 10]);

    % Linear Regression on PCC Values
    [p_pcc, ~] = polyfit(time_windows, mean_PCC, 1); % Fit regression line
    y_fit_pcc = polyval(p_pcc, time_windows); % Predicted PCC values from regression
    plot(time_windows, y_fit_pcc, 'k--', 'LineWidth', 2, 'DisplayName', 'Linear Fit for PCC');

    % Test if the slope is significantly different from 0
    [b_pcc, ~, ~, ~, stats_pcc] = regress(mean_PCC', [ones(num_windows, 1), time_windows']);
    p_value_pcc = stats_pcc(3); % P-value for PCC regression
    R_square_pcc = stats_pcc(1); % R-squared value for PCC regression

    % Display slope, p-value, and R-squared on the plot
    text_info_pcc = sprintf('Slope: %.3f\np-value: %.3f\nR^2: %.3f', b_pcc(2), p_value_pcc, R_square_pcc);
    text(max(time_windows) * 0.7, max(mean_PCC) * 0.9, text_info_pcc, 'FontSize', 10, 'BackgroundColor', 'white');
end
