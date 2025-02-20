function adjustedGazeTimes = excludeInteractionTimes(gazeTimes, interactionTimes)
    adjustedGazeTimes = []; % Initialize the adjusted gaze times
    for i = 1:size(gazeTimes, 1)
        currentGaze = gazeTimes(i, :);
        for j = 1:size(interactionTimes, 1)
            currentInteraction = interactionTimes(j, :);
            % Check for overlap and adjust the currentGaze accordingly
            if currentGaze(2) > currentInteraction(1) && currentGaze(1) < currentInteraction(2)
                % Overlap scenarios: partial overlap and complete overlap within gaze time
                if currentGaze(1) < currentInteraction(1) && currentGaze(2) > currentInteraction(2)
                    % Split into two new intervals
                    adjustedGazeTimes = [adjustedGazeTimes; currentGaze(1), currentInteraction(1)];
                    currentGaze(1) = currentInteraction(2); % Update the start of the currentGaze for further checks
                elseif currentGaze(1) >= currentInteraction(1)
                    currentGaze(1) = max(currentGaze(1), currentInteraction(2));
                else
                    currentGaze(2) = min(currentGaze(2), currentInteraction(1));
                end
            end
        end
        % Add the non-overlapping or adjusted part of the current gaze time
        if currentGaze(2) > currentGaze(1)
            adjustedGazeTimes = [adjustedGazeTimes; currentGaze];
        end
    end
end
