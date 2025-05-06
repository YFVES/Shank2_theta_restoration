function indices = findMatchingCells(cellArray, searchString)
    % cellArray: The cell array to search through
    % searchString: The variable to compare against
    
    % Initialize an empty array to store indices
    indices = [];
    
    % Loop through each cell in the cell array
    for i = 1:numel(cellArray)
        % Check if the content of the current cell matches the searchString
        if ischar(cellArray{i}) && strcmp(cellArray{i}, searchString)
            % If there is a match, add the index to the indices array
            indices = [indices, i];
        end
    end
end
