function overlayMouseBehavior(S_NS_Vector, ii, socialIdx, nonsocialIdx, TopRange, BottomRange)
    % Extract and overlay social data
    social_data = extractBehaviorData(S_NS_Vector, ii, socialIdx);
    overlayBehaviorEvents(social_data, [0.4940 0.1840 0.5560], TopRange, BottomRange); % Social data color

    % Extract and overlay nonsocial data
    nonsocial_data = extractBehaviorData(S_NS_Vector, ii, nonsocialIdx);
    overlayBehaviorEvents(nonsocial_data, [0.9290 0.6940 0.1250], TopRange, BottomRange); % Nonsocial data color
end