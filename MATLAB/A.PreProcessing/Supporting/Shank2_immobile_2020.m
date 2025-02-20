%% Behavioural Annotation, Social Interactions (choose temp for the last file)

Shank2_rest_behavior_2020
%Shank2_temp_rest_behavior_2020

%mouse1
immobile_data = immobileraw{1,1}(:,1:3); 
immobile_data = immobile_data(:,1:2) *1/29.97; %unit = seconds
immobile_data(:,3) = immobileraw{1,1}(:,3); 

movement_data = movementraw{1,1}(:,1:3); 
movement_data = movement_data(:,1:2) *1/29.97; %unit = seconds
movement_data(:,3) = movementraw{1,1}(:,3); 

counterclockwise_data = counterclockwiseraw{1,1}(:,1:3); 
counterclockwise_data = counterclockwise_data(:,1:2) *1/29.97; %unit = seconds
counterclockwise_data(:,3) = counterclockwiseraw{1,1}(:,3); 

clockwise_data = clockwiseraw{1,1}(:,1:3); 
clockwise_data = clockwise_data(:,1:2) *1/29.97; %unit = seconds
clockwise_data(:,3) = clockwiseraw{1,1}(:,3); 


%% Bout Creation

% 5 for Mice Interaction, 1 for Urine
interBout = 1;
% 10 for Mice Interaction, 1 for Urine
boutDuration = 1;

% if labelStrVec(1,1) == "Male urine sniffing" | labelStrVec(2,1) == "Male urine sniffing"
%     interBout = 1;
%     boutDuration = 1;
% end


boutIMMMOBILE = boutConvert (immobile_data, interBout, boutDuration);


%% Section Divisions

boutIMMOBILE2 = boutIMMMOBILE;
boutIMMOBILE2(:,4) = 3;




totalBouts = [boutIMMOBILE2];
totalBouts = sortrows(totalBouts);


if ~isempty (totalBouts)

for i = numel(totalBouts(:,1)): -1 : 2
    
        if (totalBouts(i,1)) - (totalBouts(i-1,2)) <= 1  % Inter Bout times, normally 10s, but 30s if too clustered sometimes...
            totalBouts(i,:) = [];
        end
    
end

if di_finish - (totalBouts(end, 2)) < 1
    totalBouts(end,:) = []; 
end

splitBoutREST = totalBouts(totalBouts(:,4) ==3,:);

else
end

