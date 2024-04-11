function [dsdata_laplac, dst] = downsampleAndPlotFirstElectrode(data, originalFs, newFs, HDR_updated, outputFolderPath)
    
    % FUNCTION DESCRIPTION: Downsamples the already modified, laplacian-referenced EEG data 
    % to a new sampling frequency (newFs) of  256 Hz and plots the
    % original and downsampled signals for the first electrode in
    % HDR_updated.label_finalized. Plots figure demonstrating data from 
    % the first electrode before and after downsampling. Saves this data in main 'Data Folder' in
    % sub-folder called 'DownsampledLaplacianReferencedData'.

    % Define the path for the 'DownsampledLaplacianReferencedData' sub-folder within 'Data'
    downsampledDataPath = fullfile(outputFolderPath, 'DownsampledLaplacianReferencedData');
    if ~exist(downsampledDataPath, 'dir')
        mkdir(downsampledDataPath);  % Create the sub-folder if it doesn't exist
    end

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
    fig = figure;
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

    % Save the plot in the 'DownsampledLaplacianReferencedData' sub-folder
    saveas(fig, fullfile(downsampledDataPath, ['DownsampledSignal_Electrode_' HDR_updated.label_finalized{1} '.png']));
    close(fig);

    % Save the downsampled data and time axis in the sub-folder
    save(fullfile(downsampledDataPath, 'dsdata_laplac.mat'), 'dsdata_laplac', '-v7.3');
    save(fullfile(downsampledDataPath, 'dst.mat'), 'dst', '-v7.3');
end
