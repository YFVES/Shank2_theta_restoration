%% Behavioural Annotation, Social Interactions
xmlcode_7behaviors

%mouse1
unisniffing_data = unisniffingraw{1,1}(:,1:3); 
unisniffing_data = unisniffing_data(:,1:2) *1/29.97; %unit = seconds
unisniffing_data(:,3) = unisniffingraw{1,1}(:,3); 

bisniffing_data = bisniffingraw{1,1}(:,1:3); 
bisniffing_data = bisniffing_data(:,1:2) *1/29.97; %unit = seconds
bisniffing_data(:,3) = bisniffingraw{1,1}(:,3); 

chasing_data = chasingraw{1,1}(:,1:3); 
chasing_data = chasing_data(:,1:2) *1/29.97; %unit = seconds
chasing_data(:,3) = chasingraw{1,1}(:,3); 

approach_data = approachraw{1,1}(:,1:3); 
approach_data = approach_data(:,1:2) *1/29.97; %unit = seconds
approach_data(:,3) = approachraw{1,1}(:,3); 

escape_data = escaperaw{1,1}(:,1:3); 
escape_data = escape_data(:,1:2) *1/29.97; %unit = seconds
escape_data(:,3) = escaperaw{1,1}(:,3); 

% 
% TopRange = max(ZPlot)*1.2;
% BottomRange = min(ZPlot)*0.8;
% 
% sg6 = annoteAreas (rearing_data,TopRange, BottomRange, [0.9290 0.6940 0.1250]); %yellow 
% sg5 = annoteAreas (sniffing_data,TopRange, BottomRange, [0 1 1]); %cyan 
% sg4 = annoteAreas (attack_data,TopRange, BottomRange, [0.6350 0.0780 0.1840]); %crimson 
% sg3 = annoteAreas (digging_data,TopRange, BottomRange, [0.4660 0.6740 0.1880]); %green 
% sg2 = annoteAreas (grooming_data,TopRange, BottomRange, [0 0.4470 0.7410]);%blue 
% sg1 = annoteAreas (mounting_data,TopRange, BottomRange, [0.4940 0.1840 0.5560]); %purple 
% 
% ylim([BottomRange TopRange])


%% Bout Creation

% 5 for Mice Interaction, 1 for Urine
interBout = 0.01;
% 10 for Mice Interaction, 1 for Urine
boutDuration = 0.5;

% if labelStrVec(1,1) == "Male urine sniffing" | labelStrVec(2,1) == "Male urine sniffing"
%     interBout = 1;
%     boutDuration = 1;
% end


boutU = boutConvert (unisniffing_data, interBout, boutDuration);
boutB = boutConvert (bisniffing_data, interBout, boutDuration);
boutC = boutConvert (chasing_data, interBout, boutDuration);
boutA = boutConvert (approach_data, interBout, boutDuration);
boutE = boutConvert (escape_data, interBout, boutDuration);


% figure('Position',[100, 100, 1400, 800])
% p5 = plot(time, (ZPlot),'Color',green,'LineWidth',0.5);
% set(gca, 'box', 'off')
% title(['\fontsize{18}Z Score'])
% ylabel('Z Score')
% xlabel('Time (s)')
% %%xRange = [160, 320];
% %%xlim (xRange)
% TopRange = max(ZPlot)*1.2;
% BottomRange = min(ZPlot);
% 
% hold on 
% 
% 
% sb6 = annoteAreas (boutU,TopRange, BottomRange, [0.9290 0.6940 0.1250]); %yellow 
% sb5 = annoteAreas (boutB,TopRange, BottomRange, [0 1 1]); %cyan 
% sb4 = annoteAreas (boutC,TopRange, BottomRange, [0.6350 0.0780 0.1840]); %crimson 
% sb3 = annoteAreas (boutA,TopRange, BottomRange, [0.4660 0.6740 0.1880]); %green 
% sb2 = annoteAreas (boutE,TopRange, BottomRange, [0.4940 0.1840 0.5560]); %purple 

%% Section Divisions

boutU2 = boutU;
boutU2(:,4) = 3;
boutB2 = boutB;
boutB2(:,4) = 4;
boutC2 = boutC;
boutC2(:,4) = 5;
boutA2 = boutA;
boutA2(:,4) = 6;
boutE2 = boutE;
boutE2(:,4) = 7;

%totalBouts = [boutA2]; %;boutU2];
totalBouts = [boutC2]; 
%totalBouts = [boutU2;boutB2;boutC2;boutA2];
totalBouts = sortrows(totalBouts);


% if ~isempty (totalBouts)
% 
% for i = numel(totalBouts(:,1)): -1 : 2
%     
%         if (totalBouts(i,1)) - (totalBouts(i-1,2)) <= 0.1  % Inter Bout times, normally 10s, but 30s if too clustered sometimes...
%             totalBouts(i,:) = [];
%         end
%     
% end
% 
% if di_finish - (totalBouts(end, 2)) < 1
%     totalBouts(end,:) = []; 
% end
% 
% splitBoutU = totalBouts(totalBouts(:,4) ==3,:);
% splitBoutB = totalBouts(totalBouts(:,4) ==4,:);
% splitBoutC = totalBouts(totalBouts(:,4) ==5,:);
% splitBoutA = totalBouts(totalBouts(:,4) ==6,:);
% splitBoutE = totalBouts(totalBouts(:,4) ==7,:);
% else
% end

% 
% 
% figure('Position',[100, 100, 1400, 800])
% p6 = plot(time, (ZPlot+1),'Color',green,'LineWidth',0.5);
% set(gca, 'box', 'off')
% title(['\fontsize{18}Z Score'])
% ylabel('Z Score')
% xlabel('Time (s)')
% 
% hold on
% 
% 
% sc6 = annoteAreas (splitBoutU,TopRange, BottomRange, [0.9290 0.6940 0.1250]); %yellow 
% sc5 = annoteAreas (splitBoutB,TopRange, BottomRange, [0 1 1]); %cyan 
% sc4 = annoteAreas (splitBoutC,TopRange, BottomRange, [0.6350 0.0780 0.1840]); %crimson 
% sc3 = annoteAreas (splitBoutA,TopRange, BottomRange, [0.4660 0.6740 0.1880]); %green 
% sc2 = annoteAreas (splitBoutE,TopRange, BottomRange, [0.4940 0.1840 0.5560]); %purple 

