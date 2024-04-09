function [numFiguresSet1, numFiguresSet2] = runSpectrograms(dsdata_laplac, newFs, HDR_updated, validChannels)
    % Initialize counters for the number of figures saved in each set
    numFiguresSet1 = 0;
    numFiguresSet2 = 0;

    % Validate inputs
    if ~isnumeric(dsdata_laplac) || isempty(dsdata_laplac)
        error('Input data must be a non-empty numeric matrix.');
    end
    
    if ~isnumeric(newFs) || ~isscalar(newFs) || newFs <= 0
        error('Sampling frequency (newFs) must be a positive scalar.');
    end
    
    % Define parameters for multitaper spectrogram
    params.Fs = newFs;             % Sampling frequency
    params.tapers = [10 8];        % Time-bandwidth product and the number of tapers [TW K]
    movingwin = [10 5];            % Window length is 10s and step size is 5s for overlap
    
    % Create directories for saving the figures
    folderSet1 = 'MATLABSpectrograms_Set1';  % Folder for all session spectrograms
    folderSet2 = 'MATLABSpectrograms_Set2';  % Folder for 33-35 mins focused spectrograms
    if ~exist(folderSet1, 'dir'), mkdir(folderSet1); end
    if ~exist(folderSet2, 'dir'), mkdir(folderSet2); end

    % Calculate total recording time in seconds and the starting index for 33 minutes
    numDataPoints = size(dsdata_laplac, 2);  % Total number of data points per electrode
    totalRecordingTimeSec = numDataPoints / newFs;

    startMinutes = 33;  % Start time in minutes for focused spectrogram
    startTimeSec = startMinutes * 60; % Convert to seconds
    if startTimeSec >= totalRecordingTimeSec
        error('Start time (33 minutes) exceeds total recording length.');
    end

    startTimeIdx = round(startTimeSec * newFs); % Starting index for 33 minutes
    endTimeIdx = startTimeIdx + round(120 * newFs);  % End index 120 seconds later
    if endTimeIdx > numDataPoints
        error('Focused spectrogram window exceeds data length.');
    end

     % Loop through each channel in HDR_updated.label_finalized
    for i = 1:length(HDR_updated.label_finalized)
        if ~validChannels(i)
            continue;  % Skip channels marked as invalid
        end

        channelLabel = HDR_updated.label_finalized{i};

        % Run full session spectrogram
        params.fpass = [0, params.Fs/2];  % Full frequency range for full session spectrogram
        [S_full, t_full, f_full] = mtspecgramc(dsdata_laplac(i,:), movingwin, params);
        fig = figure('visible','off');  % Create an invisible figure
        imagesc(t_full, f_full, 10*log10(S_full)');
        axis xy; colorbar;
        title(['Electrode ' channelLabel ' Full Session Spectrogram']);
        saveas(fig, fullfile(folderSet1, ['Electrode_' channelLabel '_FullSessionSpectrogram.png']));
        numFiguresSet1 = numFiguresSet1 + 1;  % Increment counter for Set1

        % Run focused spectrogram
        params.fpass = [0, 45];  % Frequency range of interest for focused spectrogram
        dataSegment = dsdata_laplac(i, startTimeIdx:endTimeIdx);
        fig = figure('visible','off');  % Create another invisible figure for the focused spectrogram
        imagesc(t_focus + startTimeSec, f_focus, 10*log10(S_focus)');
        axis xy; colorbar;
        title(['Electrode ' channelLabel ' Focused Spectrogram (33-35 mins, 0-45 Hz)']);
        saveas(fig, fullfile(folderSet2, ['Electrode_' channelLabel '_FocusedSpectrogram.png']));
        numFiguresSet2 = numFiguresSet2 + 1;  % Increment counter for Set2
    end

    % Display the number of figures saved in each folder
    disp(['Number of figures saved in Set 1: ', num2str(numFiguresSet1)]);
    disp(['Number of figures saved in Set 2: ', num2str(numFiguresSet2)]);
end