clear all;
close all;
clc;


main = cd;
files = dir('2023-*');
foldernames = char(files.name);

freqBands = [4 100]; % Example frequency bands
smoothingWindow = 2; % Example smoothing window

WaveletSocial = {};

for ii = [1:10,12:length(foldernames)] %1:length(foldernames) %

    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)
    cd(files(ii).name);

    struct_name = foldern(1:19);

    load(struct_name,'-mat')

    mouse1ID = K.ID {1,1};
    mouse2ID = K.ID{1,2};
    SessionDate = K.date;

   if sum(mouse1ID == '01KO')~=4 && sum(mouse2ID == '01KO')~=4
    load(strcat(struct_name,'_LFP.mat'))

    di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
    di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second

    %% behavior separation
    % social
    m1_socialbehavior = [];
    for ss = 1:3
        m1_socialbehavior = [m1_socialbehavior;K.SocialBehavior{1,2}{1,ss}];

    end
    m1_socialbehavior = sortrows(m1_socialbehavior(:,1:2));
    %m1_socialbehavior = m1_socialbehavior+di_start;

    m2_socialbehavior = [];
    for ss = 1:3
        m2_socialbehavior = [m2_socialbehavior;K.SocialBehavior{1,3}{1,ss}];

    end
    m2_socialbehavior = sortrows(m2_socialbehavior(:,1:2));
    %m2_socialbehavior = m2_socialbehavior+di_start;

    current_data_folder = cd;

    cd C:\Users\USER\Desktop\M1_sees_M2

    csv_filename = strcat(K.date, '_','M1_sees_M2','.csv');

    if ~isfile (csv_filename)
        cd('F:\Dual interaction - sorted')
        continue
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


        cd (current_data_folder);

        %%
        % Assuming 'social_interaction_times' is defined elsewhere in your code and represents the actual social interaction periods

        % Adjust social gaze times by excluding interaction times
        social_gaze_m1 = excludeInteractionTimes(social_gaze_m1, m1_socialbehavior);
        social_gaze_m2 = excludeInteractionTimes(social_gaze_m2, m2_socialbehavior);

        % Calculate the total time of social gaze excluding interaction
        total_gaze_time_m1 = sum(social_gaze_m1(:, 2) - social_gaze_m1(:, 1));
        total_gaze_time_m2 = sum(social_gaze_m2(:,2) - social_gaze_m2(:,1));



        %% compile all social gaze timestamps

        social_gaze_total = [social_gaze_m1; social_gaze_m2];
        social_gaze_total = sortrows(social_gaze_total);
        social_gaze_total(:,3) = social_gaze_total(:,2) - social_gaze_total(:,1);

        social_gaze_total_final = [];
        sss = 1;
        for ss = 1:length(social_gaze_total)
            if social_gaze_total(ss,3)>0
                social_gaze_total_final(sss,:) = social_gaze_total(ss,:);
                sss = sss+1;
            else

            end
        end
        %% m1 m2 separately
        social_gaze_m1 (:,3) = social_gaze_m1(:,2) - social_gaze_m1(:,1);
        social_gaze_m2 (:,3) = social_gaze_m2(:,2) - social_gaze_m2(:,1);
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




        %% m1 and m2 together

                    lfp_mouse1 = raw_signal_final{1,1};
                    lfp_mouse2 = raw_signal_final{1,2};
        
                    lfpSocial1 = [];
                    lfpSocial2 = [];
        
        
                    for window = 1:size(social_gaze_total_final, 1)
                        startTime = social_gaze_total_final(window, 1);
                        endTime = social_gaze_total_final(window, 2);
                        behavior_index = find(Timestamp>startTime & Timestamp<endTime);
                        if ~isempty (behavior_index)
                        temp_lfpData1 = lfp_mouse1(behavior_index(1):behavior_index(end));
                        else
                            temp_lfpData1 = [];
                        end
                        lfpSocial1 = [lfpSocial1, temp_lfpData1];
                    end
        
                    for window = 1:size(social_gaze_total_final, 1)
                        startTime = social_gaze_total_final(window, 1);
                        endTime = social_gaze_total_final(window, 2);
                        behavior_index = find(Timestamp>startTime & Timestamp<endTime);
                        if ~isempty (behavior_index)
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
                    WaveletSocial{ii,5} = total_gaze_time_m1;
                    WaveletSocial{ii,6} = total_gaze_time_m2;

%         %% m1 m2 separately
%         lfp_mouse1 = raw_signal_final{1,1};
%         lfp_mouse2 = raw_signal_final{1,2};
% 
%         lfpSocial1_m1 = [];
%         lfpSocial2_m1 = [];
% 
%         lfpSocial1_m2 = [];
%         lfpSocial2_m2 = [];
% 
%         %% when m1 is looking at m2
% 
%         for window = 1:size(social_gaze_total_m1, 1)
%             startTime = social_gaze_total_m1(window, 1);
%             endTime = social_gaze_total_m1(window, 2);
%             behavior_index = find(Timestamp>startTime & Timestamp<endTime);
%             if ~isempty (behavior_index)
%                 temp_lfpData1 = lfp_mouse1(behavior_index(1):behavior_index(end));
%             else
%                 temp_lfpData1 = [];
%             end
% 
%             lfpSocial1_m1 = [lfpSocial1_m1, temp_lfpData1];
%         end
% 
%         for window = 1:size(social_gaze_total_m1, 1)
%             startTime = social_gaze_total_m1(window, 1);
%             endTime = social_gaze_total_m1(window, 2);
%             behavior_index = find(Timestamp>startTime & Timestamp<endTime);
%             if ~isempty (behavior_index)
%                 temp_lfpData2 = lfp_mouse2(behavior_index(1):behavior_index(end));
%             else
%                 temp_lfpData2 = [];
%             end
%             
%             lfpSocial2_m1 = [lfpSocial2_m1, temp_lfpData2];
%         end
% 
%         %% when m2 is looking at m1
%         for window = 1:size(social_gaze_total_m2, 1)
%             startTime = social_gaze_total_m2(window, 1);
%             endTime = social_gaze_total_m2(window, 2);
%             behavior_index = find(Timestamp>startTime & Timestamp<endTime);
%             if ~isempty (behavior_index)
%                 temp_lfpData1 = lfp_mouse1(behavior_index(1):behavior_index(end));
%             else
%                 temp_lfpData1 = [];
%             end
%             
%             lfpSocial1_m2 = [lfpSocial1_m2, temp_lfpData1];
%         end
% 
%         for window = 1:size(social_gaze_total_m2, 1)
%             startTime = social_gaze_total_m2(window, 1);
%             endTime = social_gaze_total_m2(window, 2);
%             behavior_index = find(Timestamp>startTime & Timestamp<endTime);
%             if ~isempty (behavior_index)
%                 temp_lfpData2 = lfp_mouse2(behavior_index(1):behavior_index(end));
%             else
%                 temp_lfpData2 = [];
%             end
%             
%             lfpSocial2_m2 = [lfpSocial2_m2, temp_lfpData2];
%         end
% 
% 
%         [wt1, freqs] = cwt(lfpSocial1_m1, 'amor', SamplingFreq);
%         [wt2, ~] = cwt(lfpSocial2_m1, 'amor', SamplingFreq);
%         correlationCoeffs_m1 = calculateWaveletCorrelation(wt1, wt2, freqs, freqBands);
% 
%         [wt1, freqs] = cwt(lfpSocial1_m2, 'amor', SamplingFreq);
%         [wt2, ~] = cwt(lfpSocial2_m2, 'amor', SamplingFreq);
% 
%         correlationCoeffs_m2 = calculateWaveletCorrelation(wt1, wt2, freqs, freqBands);

%         WaveletSocial{ii,1} = SessionDate;
%         WaveletSocial{ii,2} = mouse1ID;
%         WaveletSocial{ii,3} = mouse2ID;
%         WaveletSocial{ii,4} = correlationCoeffs_m1(1,1);
%         WaveletSocial{ii,5} = correlationCoeffs_m2(1,1);
%         WaveletSocial{ii,6} = total_gaze_time_m1;
%         WaveletSocial{ii,7} = total_gaze_time_m2;




    end
   end


    cd(main);
end


% get rid of empty row
WaveletSocial(all(cellfun(@isempty, WaveletSocial),2),:) = [];