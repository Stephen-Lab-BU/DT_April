function runSpectrograms(dsdata_laplac, newFs, HDR_updated)
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

   % Loop through each electrode
    for i = 1:size(dsdata_laplac, 1)
        % Use HDR_updated.label_finalized for labeling
        electrodeLabel = HDR_updated.label_finalized{i};

        % Run full session spectrogram
        params.fpass = [0, params.Fs/2];  % Full frequency range for full session spectrogram
        [S_full, t_full, f_full] = mtspecgramc(dsdata_laplac(i,:), movingwin, params);
        figure;
        imagesc(t_full, f_full, 10*log10(S_full)');
        axis xy; colorbar;
        title(['Electrode ' electrodeLabel ' Full Session Spectrogram']);
        saveas(gcf, fullfile(folderSet1, ['Electrode_' electrodeLabel '_FullSessionSpectrogram.png']));

        % Run focused spectrogram
        params.fpass = [0, 45];  % Frequency range of interest for focused spectrogram
        % Assuming startTimeIdx and endTimeIdx are calculated elsewhere in your function
        dataSegment = dsdata_laplac(i, startTimeIdx:endTimeIdx);
        [S_focus, t_focus, f_focus] = mtspecgramc(dataSegment, movingwin, params);
        figure;
        imagesc(t_focus + startTimeSec, f_focus, 10*log10(S_focus)');  % Offset time axis by startTimeSec
        axis xy; colorbar;
        title(['Electrode ' electrodeLabel ' Focused Spectrogram (33-35 mins, 0-45 Hz)']);
        saveas(gcf, fullfile(folderSet2, ['Electrode_' electrodeLabel '_FocusedSpectrogram.png']));
    end
end


