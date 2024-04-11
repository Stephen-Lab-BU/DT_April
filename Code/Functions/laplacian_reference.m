function [data_laplac, validChannels] = laplacian_reference(data_finalized, HDR_updated_label_finalized, ch_labels, outputFolderPath)

    %FUNCTION DESCRIPTION: This function conducts laplacian calculations on
    %our updated HDR.labels & data, this conducts a check for if and when a
    %channel/electrode has an insufficient amount of channel neighbors and
    %will proceed to output an error warning with the specific channels
    %with insufficient channel neighbors. Might consider adjusting
    %threshold but for now it is less than 3 (< 3). This function will also
    %plot the first electrode pre and post-laplacian reference and will
    %also plot the channels with insufficient neighbors. All of this will
    %be saved onto the main 'Data' folder within sub-folder
    %'AllLaplacianReferencedData'. data_laplac = is laplacian referenced
    %data. 

    % Ensure the number of data_finalized rows matches the number of HDR_updated_label_finalized
    assert(size(data_finalized, 1) == length(HDR_updated_label_finalized), 'Mismatch between data rows and HDR_updated.label_finalized.');
    
    % Initialize an array to keep track of valid channels
    validChannels = true(1, length(HDR_updated_label_finalized));

    % Initialize the output matrix
    nChannels = length(HDR_updated_label_finalized);
    nTimepoints = size(data_finalized, 2);
    data_laplac = zeros(nChannels, nTimepoints);

    % Define the path for the 'AllLaplacianReferencedData' sub-folder within 'Data'
    allLaplacianDataPath = fullfile(outputFolderPath, 'AllLaplacianReferencedData');
    if ~exist(allLaplacianDataPath, 'dir')
        mkdir(allLaplacianDataPath);
    end

    % Define the path for insufficient neighbor channel plots within 'AllLaplacianReferencedData'
    insuffNeighborPlotsPath = fullfile(allLaplacianDataPath, 'InsufficientNeighborPlots');
    if ~exist(insuffNeighborPlotsPath, 'dir')
        mkdir(insuffNeighborPlotsPath);
    end

    % Iterate over all channels in HDR_updated_label_finalized
    for i = 1:nChannels
        channel = HDR_updated_label_finalized{i};

        % Verify the current channel is defined in the montage
        if ~isKey(ch_labels, channel)
            warning('Channel %s not found in montage. Skipping this channel.', channel);
            validChannels(i) = false;
            continue;
        end

        % Retrieve neighbors for the current channel from the montage
        neighbors = ch_labels(channel);

        % Find indices of neighbors in HDR_updated_label_finalized
        neighbor_inds = find(ismember(HDR_updated_label_finalized, neighbors));

        % Ensure there are enough neighbors for meaningful Laplacian calculation
        if length(neighbor_inds) < 3
            warningMessage = sprintf('Not enough neighbors for channel %s. Laplacian calculation may be inaccurate.', channel);
            warning(warningMessage);
            validChannels(i) = false;

            % Create a figure for the insufficient neighbors warning
            fig = figure('visible', 'off');
            plot(data_finalized(i, :));
            title({['Channel ' channel ' - Insufficient Neighbors'], warningMessage});
            xlabel('Time Points');
            ylabel('Amplitude');

            % Save the figure in 'InsufficientNeighborPlots' within 'AllLaplacianReferencedData'
            saveas(fig, fullfile(insuffNeighborPlotsPath, ['Channel_' channel '_InsuffNeighbors.png']));
            close(fig);

            continue;
        end

        % Calculate Laplacian: data for the channel minus mean of its neighbors
        data_laplac(i, :) = data_finalized(i, :) - mean(data_finalized(neighbor_inds, :), 1);
    end

    % Save the Laplacian-referenced data and valid channels into the 'AllLaplacianReferencedData' folder
    save(fullfile(allLaplacianDataPath, 'data_laplac.mat'), 'data_laplac', '-v7.3');
    save(fullfile(allLaplacianDataPath, 'validChannels.mat'), 'validChannels', '-v7.3');
end
