%% Behavioural Annotation, Social Interactions
Shank2_nonsocial_for_raster

%mouse1
grooming_data = groomingraw{1,1}(:,1:3); 
grooming_data = grooming_data(:,1:2) *1/29.97; %unit = seconds
grooming_data(:,3) = groomingraw{1,1}(:,3); 

rearing_data = rearingraw{1,1}(:,1:3); 
rearing_data = rearing_data(:,1:2) *1/29.97; %unit = seconds
rearing_data(:,3) = rearingraw{1,1}(:,3); 

jumping_data = jumpingraw{1,1}(:,1:3); 
jumping_data = jumping_data(:,1:2) *1/29.97; %unit = seconds
jumping_data(:,3) = jumpingraw{1,1}(:,3); 

immobile_data = immobileraw{1,1}(:,1:3); 
immobile_data = immobile_data(:,1:2) *1/29.97; %unit = seconds
immobile_data(:,3) = immobileraw{1,1}(:,3); 




%% Bout Creation

% 5 for Mice Interaction, 1 for Urine
interBout = 0.01;
% 10 for Mice Interaction, 1 for Urine
boutDuration = 0.5;



boutG = boutConvert (grooming_data, interBout, boutDuration);
boutR = boutConvert (rearing_data, interBout, boutDuration);
boutJ = boutConvert (jumping_data, interBout, boutDuration);
boutI = boutConvert (immobile_data, interBout, boutDuration);





%% Section Divisions

boutG2 = boutG;
boutG2(:,4) = 3;
boutR2 = boutR;
boutR2(:,4) = 4;
boutJ2 = boutJ;
boutJ2(:,4) = 5;
boutI2 = boutI;
boutI2(:,4) = 6;



%totalBouts = [boutG2]; 
totalBouts = [boutG2;boutR2;boutJ2]; 
%totalBouts = [boutG2;boutR2;boutJ2;boutI2];
totalBouts = sortrows(totalBouts);

% 
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
% splitBoutG = totalBouts(totalBouts(:,4) ==3,:);
% splitBoutR = totalBouts(totalBouts(:,4) ==4,:);
% splitBoutJ = totalBouts(totalBouts(:,4) ==5,:);
% splitBoutI = totalBouts(totalBouts(:,4) ==6,:);
% 
% 
% else
% end
