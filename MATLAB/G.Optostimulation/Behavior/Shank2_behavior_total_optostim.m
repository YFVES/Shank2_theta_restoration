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
    bodycontact_dat = zeros(total_minutes, 2);  % minutes x (total time, count)
    unisniffing_dat = zeros(total_minutes, 2);
    bisniffing_dat = zeros(total_minutes, 2);
    chasing_dat = zeros(total_minutes, 2);
    approach_dat = zeros(total_minutes, 2);
    escape_dat = zeros(total_minutes, 2);

    % Process behaviors within each minute
    for minute = 1:total_minutes
        % Get start and end frames for this minute
        start_frame = (minute - 1) * 60 * 29.97;
        end_frame = minute * 60 * 29.97;

        % Body contact
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 1 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 2}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 2}.clipitem;
            bodycontact = [];
            if iscell(clipitem)  % Multiple clipitems
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        bodycontact = [bodycontact; in_frame, out_frame, duration];
                    end
                end
            else  % Single clipitem
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    bodycontact = [bodycontact; in_frame, out_frame, duration];
                end
            end

            if isempty(bodycontact)
                bodycontact = [0, 0, 0];
            end

            bodycontact_dat(minute, :) = [sum(bodycontact(:, 3)), length(bodycontact(:, 1))];
        end

        % Uni-sniffing
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 2 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 3}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 3}.clipitem;
            unisniffing = [];
            if iscell(clipitem)
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        unisniffing = [unisniffing; in_frame, out_frame, duration];
                    end
                end
            else
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    unisniffing = [unisniffing; in_frame, out_frame, duration];
                end
            end

            if isempty(unisniffing)
                unisniffing = [0, 0, 0];
            end

            unisniffing_dat(minute, :) = [sum(unisniffing(:, 3)), length(unisniffing(:, 1))];
        end

        % Bi-sniffing
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 3 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 4}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 4}.clipitem;
            bisniffing = [];
            if iscell(clipitem)
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        bisniffing = [bisniffing; in_frame, out_frame, duration];
                    end
                end
            else
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    bisniffing = [bisniffing; in_frame, out_frame, duration];
                end
            end

            if isempty(bisniffing)
                bisniffing = [0, 0, 0];
            end

            bisniffing_dat(minute, :) = [sum(bisniffing(:, 3)), length(bisniffing(:, 1))];
        end

        % Chasing
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 4 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 5}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 5}.clipitem;
            chasing = [];
            if iscell(clipitem)
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        chasing = [chasing; in_frame, out_frame, duration];
                    end
                end
            else
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    chasing = [chasing; in_frame, out_frame, duration];
                end
            end

            if isempty(chasing)
                chasing = [0, 0, 0];
            end

            chasing_dat(minute, :) = [sum(chasing(:, 3)), length(chasing(:, 1))];
        end

        % Approach
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 5 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 6}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 6}.clipitem;
            approach = [];
            if iscell(clipitem)
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        approach = [approach; in_frame, out_frame, duration];
                    end
                end
            else
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    approach = [approach; in_frame, out_frame, duration];
                end
            end

            if isempty(approach)
                approach = [0, 0, 0];
            end

            approach_dat(minute, :) = [sum(approach(:, 3)), length(approach(:, 1))];
        end

        % Escape
        if length(x.xmeml{1, 2}.sequence.media.video.track) > 6 && isfield(x.xmeml{1, 2}.sequence.media.video.track{1, 7}, 'clipitem')
            clipitem = x.xmeml{1, 2}.sequence.media.video.track{1, 7}.clipitem;
            escape = [];
            if iscell(clipitem)
                for n = 1:length(clipitem)
                    in_frame = str2double(struct2cell(clipitem{n}.in));
                    out_frame = str2double(struct2cell(clipitem{n}.out));

                    if in_frame >= start_frame && out_frame <= end_frame
                        duration = (out_frame - in_frame) / 29.97;
                        escape = [escape; in_frame, out_frame, duration];
                    end
                end
            else
                in_frame = str2double(struct2cell(clipitem.in));
                out_frame = str2double(struct2cell(clipitem.out));

                if in_frame >= start_frame && out_frame <= end_frame
                    duration = (out_frame - in_frame) / 29.97;
                    escape = [escape; in_frame, out_frame, duration];
                end
            end

            if isempty(escape)
                escape = [0, 0, 0];
            end

            escape_dat(minute, :) = [sum(escape(:, 3)), length(escape(:, 1))];
        end
    end

    % Sum all behaviors for each minute
    %total_behavior_duration = bodycontact_dat(:, 1) + unisniffing_dat(:, 1) + bisniffing_dat(:, 1) + chasing_dat(:, 1) + approach_dat(:, 1) + escape_dat(:, 1);
    %total_behavior_duration =bisniffing_dat(:, 1);
    total_behavior_duration = unisniffing_dat(:, 1) + chasing_dat(:, 1) + approach_dat(:, 1);


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
