function [data_laplac, validChannels] = laplacian_reference(data_finalized, HDR_updated_label_finalized, ch_labels, outputFolderPath)
    % Ensure the number of data_finalized rows matches the number of HDR_updated_label_finalized
    assert(size(data_finalized, 1) == length(HDR_updated_label_finalized), 'Mismatch between data rows and HDR_updated.label_finalized.');
    
    % Initialize an array to keep track of valid channels
    validChannels = true(1, length(HDR_updated_label_finalized));  % Assume all channels are valid initially

    % Initialize the output matrix
    nChannels = length(HDR_updated_label_finalized);
    nTimepoints = size(data_finalized, 2);
    data_laplac = zeros(nChannels, nTimepoints);
    
    % Iterate over all channels in HDR_updated_label_finalized
    for i = 1:nChannels
        channel = HDR_updated_label_finalized{i};  % Current channel label from finalized HDR labels
        
        % Verify the current channel is defined in the montage
        if ~isKey(ch_labels, channel)
            warning('Channel %s not found in montage. Skipping this channel.', channel);
            validChannels(i) = false;  % Mark this channel as invalid
            continue;  % Skip this channel
        end
        
        % Retrieve neighbors for the current channel from the montage
        neighbors = ch_labels(channel);  % Neighbors as defined in montage
        
        % Find indices of neighbors in HDR_updated_label_finalized
        neighbor_inds = find(ismember(HDR_updated_label_finalized, neighbors));
        
        % Ensure there are enough neighbors for meaningful Laplacian calculation
        if length(neighbor_inds) < 3
            warning('Not enough neighbors for channel %s. Laplacian calculation may be inaccurate.', channel);
            validChannels(i) = false;  % Mark this channel as having insufficient neighbors
            continue;  % Optionally skip this channel or handle differently
        end
        
        % Calculate Laplacian: data for the channel minus mean of its neighbors
        data_laplac(i, :) = data_finalized(i, :) - mean(data_finalized(neighbor_inds, :), 1);
    end

    % Save the Laplacian-referenced data and valid channels
    if ~exist(outputFolderPath, 'dir')
        mkdir(outputFolderPath);  % Create the folder if it doesn't exist
    end

    save(fullfile(outputFolderPath, 'data_laplac.mat'), 'data_laplac', '-v7.3');
    save(fullfile(outputFolderPath, 'validChannels.mat'), 'validChannels', '-v7.3');
end
