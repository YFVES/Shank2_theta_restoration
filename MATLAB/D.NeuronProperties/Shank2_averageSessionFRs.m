close all
clear all

main = cd;
files = dir('2020-*');
foldernames = char(files.name);

% Initialize cell to store ISI proportions for each neuron and behavior for both mice
FR = cell(length(files), 2); % Second dimension for mouse1 and mouse2

sesname = {'baseline', 'openfield','direcinteraction'};

% Create x vector
binEdges = 0:5:200;

for ii = 1:length(foldernames)
    foldern = foldernames(ii,:);
    struct_name = foldern(1:19)

    cd(files(ii).name);
    load(struct_name, '-mat');

    if length(K.Event)==4
        FR{ii, 1} = K.date;


        if size(K.SPK,1) ~= 0

            mouse1ID = K.ID{1,1};
            mouse2ID = K.ID{1,2};

            FR{ii, 2} = mouse1ID;
            FR{ii, 3} = mouse2ID;

            if ~isempty(K.Event{1,1})
                bl_start = (K.Event{1,1}(1))/1000000;
                bl_end = (K.Event{1,1}(2))/1000000;
            else
               bl_start = 0;
                bl_end = 0;
            end

            di_start = (K.Event{1,4}(1))/1000000; %microsecond to second
            di_finish = (K.Event{1,4}(2))/1000000; %microsecond to second



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
                    if ~isempty(K.Event{1,2})
                        of_start = (K.Event{1,2}(1))/1000000;
                        of_end = (K.Event{1,2}(2))/1000000;
                    else
                        of_start = 0;
                        of_end = 0;
                    end
                else

                    if ~isempty(K.Event{1,3})
                        of_start = (K.Event{1,3}(1))/1000000;
                        of_end = (K.Event{1,3}(2))/1000000;
                    else
                        of_start = 0;
                        of_end = 0;
                    end
                end

                if mouse_index == 1
                    currentSPK = mouse1SPK;
                    currentTYPE = mouse1TYPE;

                else
                    if isempty(mouse2SPK)
                        continue; % Skip mouse 2 if there are no data
                    end
                    currentSPK = mouse2SPK;
                    currentTYPE = mouse2TYPE;

                end

                currentBehavior = {[bl_start,bl_end],[of_start,of_end],[di_start,di_finish]};

                % Initialize cell to store ISI proportions for current neuron across behaviors
                neuron_FR = cell(length(sesname), 1);

                for jj = 1:length(currentSPK)
                    spiketimes = currentSPK{jj,1};
                    
                    %calculate session pecific FRs
                    average_FR =[]; 

                    for bc = 1:length(sesname)
                        currentBehaviorTimes = currentBehavior{bc};

                        behaviorSpikes = spiketimes(spiketimes >= currentBehaviorTimes(1,1) & spiketimes <= currentBehaviorTimes(1,2));


                        if isempty(behaviorSpikes)
                            continue; % No spikes in this behavior period
                        end
                        totaltime = currentBehaviorTimes(1,2)-currentBehaviorTimes(1,1);
                        averageFR = length(behaviorSpikes)/totaltime;

                        
                            average_FR(bc, :) = averageFR; % Store proportions for current behavior
                        

                    end

                    neuron_FR{jj,1} = average_FR; % Store proportions for all behaviors of current neuron
                    neuron_FR{jj,2} = currentTYPE{jj};
                end

                FR{ii, mouse_index+3} = neuron_FR; % Store ISI proportions for all neurons of mouse1 and mouse2

            end
        end


    end

    cd(main); % Return to main directory
end


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     �