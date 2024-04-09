function [dsdata_laplac, dst] = downsampleAndPlotFirstElectrode(data, originalFs, newFs, HDR_updated, outputFolderPath)
    % Downsamples the given EEG data to a new sampling frequency (newFs) and plots the
    % original and downsampled signals for the first electrode in HDR_updated.label_finalized.

    % Calculate the downsampling factor
    dsfactor = originalFs / newFs;

    % Downsample the data for each channel
    dsdata_laplac = resample(data', newFs, originalFs)';  % Transpose data for resample function

    % Calculate the downsampled time axis
    L = size(data, 2);  % Total number of time points in the original data
    t = (0:L-1) / originalFs;  % Original time axis
    dst = downsample(t, dsfactor);  % Downsampled time axis
    
    % Assuming the first electrode in HDR_updated.label_finalized is what you want to plot
    firstElectrodeIndex = find(strcmp(HDR_updated.label_finalized, HDR_updated.label_finalized{1}));

    % Plotting the first electrode before and after downsampling
    figure;
    subplot(2, 1, 1);  
    plot(t, data(firstElectrodeIndex, :), 'b'); 
    title(['Original Signal for Electrode ' HDR_updated.label_finalized{1}]);
    xlabel('Time (s)');
    ylabel('Amplitude');

    subplot(2, 1, 2);  
    plot(dst, dsdata_laplac(firstElectrodeIndex, :), 'r');  
    title(['Downsampled Signal for Electrode ' HDR_updated.label_finalized{1}]);
    xlabel('Time (s)');
    ylabel('Amplitude');

% Save the downsampled data and time axis
    if ~exist(outputFolderPath, 'dir')
        mkdir(outputFolderPath);  % Create the folder if it doesn't exist
    end

    save(fullfile(outputFolderPath, 'dsdata.mat'), 'dsdata_laplac');
    save(fullfile(outputFolderPath, 'dst.mat'), 'dst');
end

