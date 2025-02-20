function overlayBehaviorEvents(data, color, TopRange, BottomRange)
    for iii = 1:size(data, 1)
        start = data(iii, 1);
        stop = data(iii, 2);
        area([start stop], [TopRange TopRange], BottomRange, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    end
end