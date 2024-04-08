function [HDR_updated, data_finalized] = processHDRandData(HDR, data, outputFolderPath)
    % Check if the output folder path was provided; if not, set a default
    if nargin < 4  % If fewer than 4 arguments are provided
        outputFolderPath = fullfile(pwd, 'UpdatedChannelsAndData');  % Default to a folder in the current directory
    end

    % Print the original size of HDR.label and data
    fprintf('Original size of HDR.label: %d\n', length(HDR.label));
    fprintf('Original size of data: %d x %d\n', size(data, 1), size(data, 2));

    % Step 1: Copy HDR and data to avoid modifying the originals
    HDR_updated = HDR; % Make a copy of HDR to modify
    data_copy = data; % Make a copy of data to modify

    % Step 2: Define channels to remove and remove them from the first 60 channels
   %From CH_7 notes: M1 and M2 are bad channels, FT8 and TP7 are noise
 channelsToRemove = {'M1', 'M2', 'FT8', 'FT7','PO5','PO6'};
    logicalIndicesToRemove = ismember(HDR_updated.label(1:60), channelsToRemove);
    removedChannels = HDR_updated.label(logicalIndicesToRemove);
    HDR_updated.label_finalized = HDR_updated.label(~logicalIndicesToRemove);

    % Remove data rows corresponding to removed channels
    data_copy(logicalIndicesToRemove, :) = []; % Remove data rows


    % Step 3: Adjust data rows to match HDR_updated.label_finalized
    data_finalized = zeros(length(HDR_updated.label_finalized), size(data_copy, 2));
    for i = 1:length(HDR_updated.label_finalized)
        originalIndex = find(strcmp(HDR.label, HDR_updated.label_finalized{i}));
        if ~isempty(originalIndex)
            data_finalized(i, :) = data_copy(originalIndex, :);
        else
            warning('Label %s in HDR_updated.label_finalized not found in HDR.label.', HDR_updated.label_finalized{i});
        end
    end

    % Print the size of HDR.label and data after channel removal
    fprintf('Size of HDR.label after channel removal: %d\n', length(HDR_updated.label_finalized));
    fprintf('Size of data after channel removal: %d x %d\n', size(data_finalized, 1), size(data_finalized, 2));

    % Step 5: Save to the output folder
    if ~exist(outputFolderPath, 'dir')
        mkdir(outputFolderPath); % Create the folder if it doesn't exist
    end
    save(fullfile(outputFolderPath, 'HDR_updated.mat'), 'HDR_updated', '-v7.3');
save(fullfile(outputFolderPath, 'data_finalized.mat'), 'data_finalized', '-v7.3');

    % Display messages or perform additional actions if necessary
end
