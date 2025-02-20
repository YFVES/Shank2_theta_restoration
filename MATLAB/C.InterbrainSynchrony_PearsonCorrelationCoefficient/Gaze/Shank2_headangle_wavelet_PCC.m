clear all;
close all;
clc;


main = cd;
files = dir('2020*');
foldernames = char(files.name);

freqBands = [13 30]; % Example frequency bands
smoothingWindow = 0; % Example smoothing window

WaveletSocial = {};

for ii = 1:length(foldernames)

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    struct_name = foldern(1:19);

    load(struct_name,'-mat')

    mouse1ID = K.ID {1,1};
    mouse2ID = K.ID{1,2};
    SessionDate = K.date;

   % if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
        load(strcat(struct_name,'_LFP.mat'))

        di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
        di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second

        current_data_folder = cd;


        %% social gaze time
        cd C:\Users\USER\Desktop\M1_sees_M2

        csv_filename = strcat(K.date, '_','M1_sees_M2','.csv');

        if ~isfile (csv_filename)
            cd(current_data_folder)
            
        else

            data = readtable(csv_filename);
            cd (current_data_folder)

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
            %social_gaze_m1 (:,3) = social_gaze_m1(:,2) - social_gaze_m1(:,1);


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


           
        end


        %% head direction time

        current_data_folder = cd;

        cd C:\Users\USER\Desktop\Angle

        csv_filename = strcat(K.date, '_','Angle','.csv');
        %csv_filename = strcat(K.date, '_', mouse1ID,'_',mouse2ID,'_','Angle','.csv');

        if ~isfile (csv_filename)
            cd(current_data_folder)
            
        else

            data = readtable(csv_filename);
            cd (current_data_folder);

            if size(data,1)>17982

                data = data{2:17983,2};
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


            head_angle = [start_positions;end_positions]';
            head_angle = head_angle / 29.97;





            social_gaze_total = [social_gaze_m1; social_gaze_m2];
            social_gaze_total = sortrows(social_gaze_total);

            head_angle = excludeInteractionTimes(head_angle,social_gaze_total);

            head_angle (:,3) = head_angle(:,2) - head_angle(:,1);

            %% compile all social gaze timestamps
            head_angle_total_final = [];
            sss = 1;
            for ss = 1:length(head_angle)
                if head_angle(ss,3)>0
                    head_angle_total_final(sss,:) = head_angle(ss,:);
                    sss = sss+1;
                else

                end
            end



            lfp_mouse1 = raw_signal_final{1,1};
            lfp_mouse2 = raw_signal_final{1,2};

            lfpSocial1 = [];
            lfpSocial2 = [];


            for window = 1:size(head_angle_total_final, 1)
                startTime =head_angle_total_final(window, 1);
                endTime = head_angle_total_final(window, 2);
                behavior_index = find(Timestamp>startTime & Timestamp<endTime);
                if ~isempty (behavior_index)
                    temp_lfpData1 = lfp_mouse1(behavior_index(1):behavior_index(end));
                else
                    temp_lfpData1 = [];
                end
                lfpSocial1 = [lfpSocial1, temp_lfpData1];

            end

            for window = 1:size(head_angle_total_final, 1)
                startTime = head_angle_total_final(window, 1);
                endTime = head_angle_total_final(window, 2);
                behavior_index = find(Timestamp>startTime & Timestamp<endTime);

                if ~isempty(behavior_index)
                    temp_lfpData2 = lfp_mouse2(behavior_index(1):behavior_index(end));
                else
                    temp_lfpData2 = [];
                end

                lfpSocial2 = [lfpSocial2, temp_lfpData2];

            end


            [wt1, freqs] = cwt(lfpSocial1, 'amor', SamplingFreq);
            [wt2, ~] = cwt(lfpSocial2, 'amor', SamplingFreq);

            correlationCoeffs = calculateWaveletCorrelation(wt1, wt2, freqs, freqBands);

            WaveletSocial{ii,1} = SessionDate;
            WaveletSocial{ii,2} = mouse1ID;
            WaveletSocial{ii,3} = mouse2ID;
            WaveletSocial{ii,4} = correlationCoeffs(1,1);
            %WaveletSocial{ii,5} = correlationCoeffs(2,1);
            %WaveletSocial{ii,6} = correlationCoeffs(3,1);
 
         
        end
        cd(main);
    %end


    cd(main);
end


