function data = extractBehaviorData(S_NS_Vector, ii, dataIndex)
    data = [];
    for jj = 1:size(S_NS_Vector{ii, dataIndex}{1, 1}, 2)
        data = [data; S_NS_Vector{ii, dataIndex}{1, 1}{1, jj}(:, 1:3)];
    end
end