close all
clear all


% code needs to run twice for two neuron types , E and I 
main = cd;
files = dir('2023-*');
foldernames = char(files.name);
bb = 0;
FIN_burst = {};
% Define burst ISI criteria
validBurstNum=2;
isi_choice = [5, 10, 15, 20, 25, 30]; % ISI thresholds for burst detection in ms
avg_rate_threshold = 0.5; % Average firing rate threshold in Hz

sesname = {'Baseline','Social','NonSocial','Immobile'};

for ii = 1:length(foldernames)
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);
    load(struct_name, '-mat');

    if length(K.Event)==4



        if size(K.SPK,1) ~= 0

            mouse1ID = K.ID{1,1};
            mouse2ID = K.ID{1,2};


            if ~isempty (K.Event{1,1})
                bl_start = (K.Event{1,1}(1))/1000000;
                bl_end = (K.Event{1,1}(2))/1000000;
            else
                bl_start = 0;
                bl_end = 0;
            end


            di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
            di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second



            behaviorCategories = {'social', 'nonsocial', 'immobile'};

            %% behavior separation
            % social
            m1_socialbehavior = [];
            for ss = 1:4
                m1_socialbehavior = [m1_socialbehavior;K.SocialBehavior{1,2}{1,ss}];

            end
            m1_socialbehavior = sortrows(m1_socialbehavior(:,1:2));
            m1_socialbehavior = m1_socialbehavior+di_start;

            m2_socialbehavior = [];
            for ss = 1:4
                m2_socialbehavior = [m2_socialbehavior;K.SocialBehavior{1,3}{1,ss}];

            end
            m2_socialbehavior = sortrows(m2_socialbehavior(:,1:2));
            m2_socialbehavior = m2_socialbehavior+di_start;
            %nonsocial
            m1_nonsocialbehavior = [];
            for nn = 1:3
                m1_nonsocialbehavior = [m1_nonsocialbehavior;K.NonSocialBehavior{1,2}{1,nn}];

            end
            m1_nonsocialbehavior = sortrows(m1_nonsocialbehavior(:,1:2));
            m1_nonsocialbehavior = m1_nonsocialbehavior+di_start;

            m2_nonsocialbehavior = [];
            for nn = 1:3
                m2_nonsocialbehavior = [m2_nonsocialbehavior;K.NonSocialBehavior{1,3}{1,nn}];

            end

            m2_nonsocialbehavior = sortrows(m2_nonsocialbehavior(:,1:2));
            m2_nonsocialbehavior = m2_nonsocialbehavior+di_start;

            %exploring
            m1_exploring = [];
            for nn = 1:size(K.Exploring{1,1},2)
                m1_exploring = [m1_exploring;K.Exploring{1,2}{1,nn}];

            end
            m1_exploring = sortrows(m1_exploring(:,1:2));
            m1_exploring = m1_exploring+di_start;

            m2_exploring = [];
            for nn = 1:size(K.Exploring{1,1},2)
                m2_exploring = [m2_exploring;K.Exploring{1,3}{1,nn}];

            end

            m2_exploring = sortrows(m2_exploring(:,1:2));
            m2_exploring = m2_exploring+di_start;


            m1_nonsocialbehavior = sortrows([m1_nonsocialbehavior;m1_exploring]);
            m2_nonsocialbehavior = sortrows([m2_nonsocialbehavior;m1_exploring]);

            %immobile
            m1_immobile = cell2mat(K.Immobile{1,2});
            m1_immobile = m1_immobile+di_start;

            m2_immobile = cell2mat(K.Immobile{1,3});
            m2_immobile = m2_immobile+di_start;

            m1_behavior = {m1_socialbehavior,m1_nonsocialbehavior,m1_immobile};
            m2_behavior = {m2_socialbehavior,m2_nonsocialbehavior,m2_immobile};

            %% seperation of neurons

            mouse1SPK = K.SPK(:,1);
            mouse1TYPE = K.SPK(:,3);
            mouse1SPK(all(cellfun(@isempty,mouse1SPK),2),:) = [];
            mouse1TYPE(all(cellfun(@isempty, mouse1TYPE),2),:) = [];



            if size(K.SPK,2)>3
                mouse2SPK = K.SPK(:,2);
                mouse2TYPE = K.SPK(:,4);
                mouse2SPK(all(cellfun(@isempty,mouse2SPK),2),:) = [];
                mouse2TYPE(all(cellfun(@isempty, mouse2TYPE),2),:) = [];
            else
                mouse2SPK = [];
                mouse2TYPE = [];
            end

            %% Loop for mouse1SPK and mouse2SPK
            for mouse_index = 1:2
                if mouse_index == 1
                    currentSPK = mouse1SPK;
                    currentTYPE = mouse1TYPE;
                    currentBehavior = m1_behavior;
                else
                    if isempty(mouse2SPK)
                        continue; % Skip mouse 2 if there are no data
                    end
                    currentSPK = mouse2SPK;
                    currentTYPE = mouse2TYPE;
                    currentBehavior = m2_behavior;
                end


                for jjj = 1:length(currentSPK)

                    fin_burstRatio = {};
                    fin_burstDur = {};
                    fin_burstSpikeNum ={};
                    fin_burstSpikeAll = {};

                    fin_burstrate = {};
                    fin_tonicrate = {};
                    fin_burstEvent = {};
                    fin_firingrate = {};

                    spiketimes = currentSPK{jjj,1};
                    neuron_type = currentTYPE{jjj};

                    DI_spiketimes_index = find(spiketimes>di_start&spiketimes<di_finish);
                    DISpiketimes = spiketimes(DI_spiketimes_index);
                    di_time = di_finish - di_start;
                    avg_DI_firing_rate = length(DISpiketimes)/di_time;

                    BL_spiketimes_index = find(spiketimes>bl_start&spiketimes<bl_end);
                    BLSpiketimes = spiketimes(BL_spiketimes_index);
                    BL_time = bl_end - bl_start; % Total recording time in seconds
                    avg_BL_firing_rate = length(BLSpiketimes) / BL_time;

                    if avg_DI_firing_rate > avg_rate_threshold && avg_BL_firing_rate > avg_rate_threshold && (strcmp(neuron_type, 'I')) %neuron type 
                        for ses = 1:length(sesname)
                            temp_burstSpikeAll = [];

                            if ses == 1
                                spiketimes = BLSpiketimes;
                                total_time = BL_time;
                            elseif ses == 2
                                currentBehaviorTimes = currentBehavior{1};
                                behaviorSpikes = [];

                                for kk = 1:size(currentBehaviorTimes,1)
                                    behaviorSpikes = [behaviorSpikes; DISpiketimes(DISpiketimes >= currentBehaviorTimes(kk,1) &DISpiketimes <= currentBehaviorTimes(kk,2))];
                                end

                                if isempty(behaviorSpikes)
                                    spiketimes = [];
                                else
                                    spiketimes = behaviorSpikes;
                                end

                                total_time = di_time;
                            elseif ses == 3
                                currentBehaviorTimes = currentBehavior{2};
                                behaviorSpikes = [];

                                for kk = 1:size(currentBehaviorTimes,1)
                                    behaviorSpikes = [behaviorSpikes; DISpiketimes(DISpiketimes >= currentBehaviorTimes(kk,1) &DISpiketimes <= currentBehaviorTimes(kk,2))];
                                end

                                if isempty(behaviorSpikes)
                                    spiketimes = [];
                                else
                                    spiketimes = behaviorSpikes;
                                end
                                total_time = di_time;
                            else
                                currentBehaviorTimes = currentBehavior{3};
                                behaviorSpikes = [];

                                for kk = 1:size(currentBehaviorTimes,1)
                                    behaviorSpikes = [behaviorSpikes; DISpiketimes(DISpiketimes >= currentBehaviorTimes(kk,1) &DISpiketimes <= currentBehaviorTimes(kk,2))];
                                end

                                if isempty(behaviorSpikes)
                                    spiketimes = [];
                                else
                                    spiketimes = behaviorSpikes;
                                end
                                total_time = di_time;
                            end

                            % Filter neurons based on type and average firing rate


                            % Analyze bursts for each ISI threshold
                            for isi_idx = 1:length(isi_choice)
                                if length(spiketimes)>1
                                    isi_threshold = isi_choice(isi_idx);

                                    % Initialize burst detection for each neuron
                                    F = {}; % Assuming F is your structure for storing spiketimes and other data
                                    F.cell = {spiketimes}; % Adapt this to your structure for storing spiketimes

                                    % Burst detection logic
                                    for c = 1:length(F.cell)
                                        F.cell{c}(:,2) = NaN; % Second column for ISI
                                        for s = 1:length(F.cell{c})-1
                                            F.cell{c}(s,2) = (F.cell{c}(s+1,1) - F.cell{c}(s,1)) * 10^3; % Convert to ms
                                        end
                                        F.cell{c}(:,3) = 0; % Third column for burst identification
                                        burstIsiCount = find(F.cell{c}(:,2) < isi_threshold); % Use current ISI threshold
                                        burstCount = 0;
                                        if ~isempty(burstIsiCount)

                                            for b = 1:length(burstIsiCount)
                                                if b == 1 || burstIsiCount(b) - burstIsiCount(b-1) > 1
                                                    burstCount = burstCount + 1;
                                                end
                                                F.cell{c}(burstIsiCount(b),3) = burstCount;
                                                if b < length(burstIsiCount) && burstIsiCount(b+1) - burstIsiCount(b) == 1
                                                    F.cell{c}(burstIsiCount(b+1),3) = burstCount;
                                                end
                                            end
                                        end
                                    end



                                    % If ses_dur is not defined, you will need to calculate or define it based on your session data
                                    if ~isempty(burstCount)
                                        % Calculate burst metrics
                                        burstSpikes = find(F.cell{1}(:,3) > 0); % Indices of spikes that are part of a burst
                                        uniqueBursts = unique(F.cell{1}(burstSpikes,3)); % Unique burst identifiers
                                        burstSpikeNum = arrayfun(@(b) sum(F.cell{1}(:,3) == b), uniqueBursts); % Number of spikes in each burst
                                        burstDur = arrayfun(@(b) range(F.cell{1}(F.cell{1}(:,3) == b, 1)), uniqueBursts) * 10^3; % Duration of each burst in ms

                                        % Store the calculated metrics
                                        % Note: You'll need to adjust indexing based on your specific requirements
                                        temp_fin_burstRatio{mouse_index,isi_idx} = sum(burstSpikeNum) / length(spiketimes) * 100;
                                        temp_fin_burstDur{mouse_index,isi_idx} = nanmean(burstDur);
                                        temp_fin_burstSpikeNum{mouse_index,isi_idx} = nanmean(burstSpikeNum);


                                        temp_fin_burstSpikeAll{mouse_index,isi_idx} = [temp_burstSpikeAll, burstSpikeNum];
                                        temp_fin_burstrate{mouse_index,isi_idx}= sum(burstSpikeNum) / total_time;
                                        temp_fin_tonicrate{mouse_index,isi_idx} = (length(spiketimes) - sum(burstSpikeNum)) / total_time;
                                        temp_fin_burstEvent{mouse_index,isi_idx}= length(uniqueBursts) / total_time;
                                        temp_fin_firingrate{mouse_index,isi_idx} = length(spiketimes) / total_time;
                                        temp_burstSpikeAll = [];
                                    else
                                        temp_fin_burstRatio{mouse_index,isi_idx} = 0;
                                        temp_fin_burstDur{mouse_index,isi_idx} = NaN;
                                        temp_fin_burstSpikeNum{mouse_index,isi_idx} = NaN;

                                        temp_fin_burstrate{mouse_index,isi_idx}= 0;
                                        temp_fin_tonicrate{mouse_index,isi_idx} = length(spiketimes) / total_time;
                                        temp_fin_burstEvent{mouse_index,isi_idx} = 0;
                                        temp_fin_firingrate{mouse_index,isi_idx} = length(spiketimes) / total_time;
                                    end
                                else
                                    temp_fin_burstRatio{mouse_index,isi_idx} = NaN;
                                    temp_fin_burstDur{mouse_index,isi_idx}= NaN;
                                    temp_fin_burstSpikeNum{mouse_index,isi_idx} = NaN;
                                    temp_fin_burstSpikeAll{mouse_index,isi_idx} = [temp_burstSpikeAll];
                                    temp_fin_burstrate{mouse_index,isi_idx}= NaN;
                                    temp_fin_tonicrate{mouse_index,isi_idx} = 0;
                                    temp_fin_burstEvent{mouse_index,isi_idx} = NaN;
                                    temp_fin_firingrate{mouse_index,isi_idx} = 0;

                                end



                            end
                            fin_burstRatio{mouse_index,ses} = temp_fin_burstRatio(mouse_index,:);
                            fin_burstDur{mouse_index,ses} =temp_fin_burstDur(mouse_index,:);
                            fin_burstSpikeNum{mouse_index,ses} = temp_fin_burstSpikeNum(mouse_index,:);
                            fin_burstSpikeAll{mouse_index,ses} = temp_fin_burstSpikeAll(mouse_index,:);
                            fin_burstrate{mouse_index,ses} = temp_fin_burstrate(mouse_index,:);
                            fin_tonicrate{mouse_index,ses} = temp_fin_tonicrate(mouse_index,:);
                            fin_burstEvent{mouse_index,ses} = temp_fin_burstEvent(mouse_index,:);
                            fin_firingrate{mouse_index,ses} = temp_fin_firingrate(mouse_index,:);
                        end





                        if mouse_index == 1
                            FIN_burst{bb+jjj,1} = K.date;
                            FIN_burst{bb+jjj,2} = mouse1ID;
                            FIN_burst{bb+jjj,3} = jjj;
                            FIN_burst{bb+jjj,4} = fin_burstRatio(1,:);
                            FIN_burst{bb+jjj,5} = fin_burstDur(1,:);
                            FIN_burst{bb+jjj,6} = fin_burstSpikeNum(1,:);
                            FIN_burst{bb+jjj,7} = fin_burstSpikeAll(1,:);
                            FIN_burst{bb+jjj,8} = fin_burstrate(1,:);
                            FIN_burst{bb+jjj,9} = fin_tonicrate(1,:);
                            FIN_burst{bb+jjj,10} = fin_burstEvent(1,:);
                            FIN_burst{bb+jjj,11} = fin_firingrate(1,:);



                        else

                            FIN_burst{bb+jjj,1} = K.date;
                            FIN_burst{bb+jjj,2} = mouse2ID;
                            FIN_burst{bb+jjj,3} = jjj;
                            FIN_burst{bb+jjj,4} = fin_burstRatio(2,:);
                            FIN_burst{bb+jjj,5} = fin_burstDur(2,:);
                            FIN_burst{bb+jjj,6} = fin_burstSpikeNum(2,:);
                            FIN_burst{bb+jjj,7} = fin_burstSpikeAll(2,:);
                            FIN_burst{bb+jjj,8} = fin_burstrate(2,:);
                            FIN_burst{bb+jjj,9} = fin_tonicrate(2,:);
                            FIN_burst{bb+jjj,10} = fin_burstEvent(2,:);
                            FIN_burst{bb+jjj,11} = fin_firingrate(2,:);

                        end



                    end



                end
                bb = size(FIN_burst,1);
            end

        end

    end

    cd(main); % Return to main directory
end

