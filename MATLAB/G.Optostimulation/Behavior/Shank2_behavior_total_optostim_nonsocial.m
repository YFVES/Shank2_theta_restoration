%% non social 

clear all
f = findfiles('xml');
Total = {};

for l = 1:length(f)

    x = xml2struct(f{l});

    % Extract date and subject information
    ExpDate = f{1,l}(end-34:end-16)
    ExPSubject = f{1,l}(end-13:end-11);

    % Determine total duration of the recording (assumed from bodycontact track)
    total_frames = str2double(struct2cell(x.xmeml{1, 2}.sequence.duration));
    total_duration = total_frames / 29.97;  % Total duration in seconds

    % Calculate the total number of minutes
    total_minutes = floor(total_duration / 60);  % Convert total duration to minutes and round up

    % Initialize behavior data for each minute
    nonsocial_dat = zeros(total_minutes, 2);  % minutes x (total time, count)
   
    % Process behaviors within each minute
    for minute = 1:total_minutes
        % Get start and end frames for this minute
        start_frame = (minute - 1) * 60 * 29.97;
        end_frame = minute * 60 * 29.97;

        % Body contact
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 1 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 1}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 1}.clipitem;
            nonsocial = [];
            if iscell(clipitem)  % Multiple clipitems
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        nonsocial = [nonsocial; in_frame, out_frame, duration];
                    end
                end
            else  % Single clipitem
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    nonsocial = [nonsocial; in_frame, out_frame, duration];
                end
            end

            if isempty(nonsocial)
                nonsocial = [0, 0, 0];
            end

            nonsocial_dat(minute, :) = [sum(nonsocial(:, 3)), length(nonsocial(:, 1))];
        end

       
    total_behavior_duration = nonsocial_dat(:, 1);


    % Store total behavior duration for each minute in separate columns of Total
    Total{l, 1} = ExpDate;
    Total{l, 2} = ExPSubject;

    % Store total duration for each minute in separate columns starting from column 3
    for minute = 1:total_minutes
        Total{l, 2 + minute} = total_behavior_duration(minute);
    end

    %     % Plot the sum of all behaviors by the minute
    %     minutes_x = 1:total_minutes;  % Representing the minutes
    %
    %     figure;
    %     plot(minutes_x, total_behavior_duration, '-o');
    %     title(['Mouse ID: ', ExPSubject, ' - Total Behavior Duration by Minute']);
    %     xlabel('Minute');
    %     ylabel('Duration (s)');
    end
end

%% immobile 
clear all
f = findfiles('xml');
Total = {};

for l = 1:length(f)

    x = xml2struct(f{l});

    % Extract date and subject information
    ExpDate = f{1,l}(end-34:end-16)
    ExPSubject = f{1,l}(end-13:end-11);

    % Determine total duration of the recording (assumed from bodycontact track)
    total_frames = str2double(struct2cell(x.xmeml{1, 2}.sequence.duration));
    total_duration = total_frames / 29.97;  % Total duration in seconds

    % Calculate the total number of minutes
    total_minutes = floor(total_duration / 60);  % Convert total duration to minutes and round up

    % Initialize behavior data for each minute
    nonsocial_dat = zeros(total_minutes, 2);  % minutes x (total time, count)
   
    % Process behaviors within each minute
    for minute = 1:total_minutes
        % Get start and end frames for this minute
        start_frame = (minute - 1) * 60 * 29.97;
        end_frame = minute * 60 * 29.97;

        % Body contact
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 7 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 8}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 8}.clipitem;
            nonsocial = [];
            if iscell(clipitem)  % Multiple clipitems
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        nonsocial = [nonsocial; in_frame, out_frame, duration];
                    end
                end
            else  % Single clipitem
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    nonsocial = [nonsocial; in_frame, out_frame, duration];
                end
            end

            if isempty(nonsocial)
                nonsocial = [0, 0, 0];
            end

            nonsocial_dat(minute, :) = [sum(nonsocial(:, 3)), length(nonsocial(:, 1))];
        end

       
    total_behavior_duration = nonsocial_dat(:, 1);


    % Store total behavior duration for each minute in separate columns of Total
    Total{l, 1} = ExpDate;
    Total{l, 2} = ExPSubject;

    % Store total duration for each minute in separate columns starting from column 3
    for minute = 1:total_minutes
        Total{l, 2 + minute} = total_behavior_duration(minute);
    end

    %     % Plot the sum of all behaviors by the minute
    %     minutes_x = 1:total_minutes;  % Representing the minutes
    %
    %     figure;
    %     plot(minutes_x, total_behavior_duration, '-o');
    %     title(['Mouse ID: ', ExPSubject, ' - Total Behavior Duration by Minute']);
    %     xlabel('Minute');
    %     ylabel('Duration (s)');
    end
end
