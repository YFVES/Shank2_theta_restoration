close all
clear all

main = cd;
files = dir('2020-*');
foldernames = char(files.name);

% Initialize cell to store ISI proportions for each neuron and behavior for both mice
ISI_proportions = cell(length(files), 2); % Second dimension for mouse1 and mouse2

behaviorCategories = {'social', 'nonsocial', 'immobile'};

for ii = 1:length(foldernames)
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);
    load(struct_name, '-mat');

    if length(K.Event)==4
        ISI_proportions{ii, 1} = K.date;




        if size(K.SPK,1) ~= 0

            mouse1ID = K.ID{1,1};
            mouse2ID = K.ID{1,2};

            ISI_proportions{ii, 2} = mouse1ID;
            ISI_proportions{ii, 3} = mouse2ID;

            di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
            di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second

            % Define the bins for the histogram
            binEdges = 0:5:200; % Bins from 0 to 200 ms with 5 ms bin width
            clear behavior_ts

            

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

               

                % Initialize cell to store ISI proportions for current neuron across behaviors
                neuron_ISI_proportions = cell(length(behaviorCategories), 1);

                for jj = 1:length(currentSPK)
                    spiketimes = currentSPK{jj,1};
                    % Calculate overall ISIs for current neuron
                    overall_ISIs = diff(spiketimes)*1000; % Convert to ms
                    [overall_counts, ~] = histcounts(overall_ISIs, binEdges);
                    overall_proportion = overall_counts / sum(overall_counts);
                    %calculate behavior specific ISIs
                    behavior_ISI_proportions = zeros(length(behaviorCategories), length(binEdges)-1); % For storing proportions of each behavior

                    for bc = 1:length(behaviorCategories)
                        currentBehaviorTimes = currentBehavior{bc};
                        behaviorSpikes = [];

                        for kk = 1:size(currentBehaviorTimes,1)
                            behaviorSpikes = [behaviorSpikes; spiketimes(spiketimes >= currentBehaviorTimes(kk,1) & spiketimes <= currentBehaviorTimes(kk,2))];
                        end

                        if isempty(behaviorSpikes)
                            continue; % No spikes in this behavior period
                        end

                        ISIs = diff(behaviorSpikes)*1000; % Convert to ms
                        [counts, ~] = histcounts(ISIs, binEdges);
                        proportion = counts / sum(counts);
                        behavior_ISI_proportions(bc, :) = proportion; % Store proportions for current behavior
                    end

                    neuron_ISI_proportions{jj,1} = [overall_proportion;behavior_ISI_proportions]; % Store proportions for all behaviors of current neuron
                    neuron_ISI_proportions{jj,2} = currentTYPE{jj}; 
                end

                ISI_proportions{ii, mouse_index+3} = neuron_ISI_proportions; % Store ISI proportions for all neurons of mouse1 and mouse2
               
            end
        end

    end

    cd(main); % Return to main directory
end


% 'significant_differences' now contains information about neurons and behaviors with significant differences in ISI proportions for both mice
