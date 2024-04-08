function data_laplac = laplacian_reference(data_finalized, hdr_label_finalized, ch_labels)
    % Ensure the number of data_finalized rows matches the number of hdr_label_finalized
    assert(size(data_finalized, 1) == length(hdr_label_finalized), 'Mismatch between data rows and channel labels.');
    
    % Initialize the output matrix
    nChannels = length(hdr_label_finalized);
    nTimepoints = size(data_finalized, 2);
    data_laplac = zeros(nChannels, nTimepoints);
    
    % Iterate over all channels in hdr_label_finalized
    for i = 1:nChannels
        channel = hdr_label_finalized{i};  % Current channel label from finalized HDR labels
        
        % Verify the current channel is defined in the montage
        if ~isKey(ch_labels, channel)
            error('Channel %s not found in montage. Calculation cannot proceed.', channel);
        end
        
        % Retrieve neighbors for the current channel from the montage
        neighbors = ch_labels(channel);  % Neighbors as defined in montage
        
        % Find indices of neighbors in hdr_label_finalized
        neighbor_inds = find(ismember(hdr_label_finalized, neighbors));
        
        % Ensure there are enough neighbors for meaningful Laplacian calculation
        if length(neighbor_inds) < 3  % Example threshold, adjust as needed
            warning('Not enough neighbors for channel %s. Laplacian calculation may be inaccurate.', channel);
            continue;  % Optionally skip this channel or handle differently
        end
        
        % Calculate Laplacian: data for the channel minus mean of its neighbors
        data_laplac(i, :) = data_finalized(i, :) - mean(data_finalized(neighbor_inds, :), 1);
    end

    % Return Laplacian-referenced data
    return;
end
