clear all
f = findfiles('xml');
Total = {};

for l = 1:length(f)

    x = xml2struct(f{l});

    % Extract date and subject information
    ExpDate = f{1,l}(end-34:end-16);
    ExPSubject = f{1,l}(end-13:end-11);

    % Determine total duration of the recording (assumed from bodycontact track)
    total_frames = str2double(struct2cell(x.xmeml{1, 2}.sequence.duration));
    total_duration = total_frames / 29.97;  % Total duration in seconds

    % Define window sizes
    window_size = total_duration / 3;
    windows = [0, window_size, 2 * window_size, total_duration];  % Split into 3 windows

    % Initialize behavior data for each window
    bodycontact_dat = zeros(3, 2);  % 3 windows x (total time, count)
    unisniffing_dat = zeros(3, 2);
    bisniffing_dat = zeros(3, 2);
    chasing_dat = zeros(3, 2);
    approach_dat = zeros(3, 2);
    escape_dat = zeros(3, 2);

    % Process behaviors within the window segments
    for window = 1:3
        % Get start and end frames for this window
        start_frame = windows(window) * 29.97;
        end_frame = windows(window + 1) * 29.97;

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

            bodycontact_dat(window, :) = [sum(bodycontact(:, 3)), length(bodycontact(:, 1))];
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

            unisniffing_dat(window, :) = [sum(unisniffing(:, 3)), length(unisniffing(:, 1))];
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

            bisniffing_dat(window, :) = [sum(bisniffing(:, 3)), length(bisniffing(:, 1))];
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

            chasing_dat(window, :) = [sum(chasing(:, 3)), length(chasing(:, 1))];
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

            approach_dat(window, :) = [sum(approach(:, 3)), length(approach(:, 1))];
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

            escape_dat(window, :) = [sum(escape(:, 3)), length(escape(:, 1))];
        end
    end

    % Sum all behaviors for each window
    %total_behavior_duration = bodycontact_dat(:, 1) + unisniffing_dat(:, 1) + bisniffing_dat(:, 1) + chasing_dat(:, 1) + approach_dat(:, 1) + escape_dat(:, 1);
     %total_behavior_duration =bisniffing_dat(:, 1);
     total_behavior_duration = unisniffing_dat(:, 1) + chasing_dat(:, 1) + approach_dat(:, 1);

    % Store total for each window in separate columns of Total
    Total{l, 1} = ExpDate;
    Total{l, 2} = ExPSubject;
    Total{l, 3} = total_behavior_duration(1);  % Total behavior duration for window 1
    Total{l, 4} = total_behavior_duration(2);  % Total behavior duration for window 2
    Total{l, 5} = total_behavior_duration(3);  % Total behavior duration for window 3

    % Plot the sum of all behaviors
    windows_x = 1:3;  % Representing the three windows

    figure;
    plot(windows_x, total_behavior_duration, '-o');
    title(['Mouse ID: ', ExPSubject, ' - Total Behavior Duration']);
    xlabel('Window');
    ylabel('Duration (s)');
end
