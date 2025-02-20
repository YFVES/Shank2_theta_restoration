
%% for direct interaction 

clear all 
Total = {};
folder = dir; 

f = findfiles('csv'); 

for l=1:length(f)
    name = folder(l+2).name;
    data = readtable(name); 
    name = name(1:29); 
    if size(data,1)>27000

    data = data{1:27000,2};
    else
       data = data{:,2}; 
    end
    data = numel(data(data==1)); 
    sum_data = sum(data,1); 
    time_looking = sum_data/29.97;

Total {l,1} = name;
Total {l,2} = time_looking; 

end




%% for optostim 
clear all
Total = {};
folder = dir;

f = findfiles('csv');

for l = 1:length(f)
    name = folder(l+2).name;
    data = readtable(name);
    name = name(1:29);
    
    % Adjust the length of the data to a maximum of 27000 rows
    if size(data, 1) > 27000
        data = data{1:27000, 2};
    else
        data = data{:, 2};
    end
    
    % Define the three windows
    windows = {1:9000, 9001:18000, 18001:27000};
    time_looking = zeros(1, 3); % Initialize time looking for three windows

    for w = 1:3
        % Check if the window exceeds the data length
        win = windows{w};
        win = win(win <= length(data));
        % Count the '1's within the window and calculate the time looking
        num_ones = numel(data(win(data(win) == 1)));
        time_looking(w) = num_ones / 29.97;
    end

    % Store the results
    Total{l, 1} = name;
    Total{l, 2} = time_looking(1); % Time looking for window 1
    Total{l, 3} = time_looking(2); % Time looking for window 2
    Total{l, 4} = time_looking(3); % Time looking for window 3
end
