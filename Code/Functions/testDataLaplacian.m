%Verifying that 'laplacian_reference' function works

%Accessing eeglab folder
eeglabpath = '/Users/daphne/Desktop/StephenLab Rotation/DT_April/ThirdPartyPackages/eeglab2024.0';  % New EEGLAB path
addpath(genpath(eeglabpath));  % Adds the new EEGLAB path and its subdirectories to MATLAB's search path
savepath;

Nchannels = length(HDR_updated.label_finalized);  
data_test = eye(Nchannels); 

data_laplac_test = laplacian_reference(data_test, HDR.label_finalized, Electrode_neighbors);

chanlocs = struct('labels', HDR.label_finalized);

chanlocs = pop_chanedit(chanlocs, 'lookup', fullfile(eeglabpath, 'plugins', 'dipfit', 'standard_BESA', 'standard-10-5-cap385.elp'));

for i = 1:Nchannels
    figure;  % Create a new figure for each channel's plot
    topoplot(data_laplac_test(:, i), chanlocs);  
    title(sprintf('Laplacian of Channel %s', HDR.label_finalized{i}));
end

%%
% For easier visualization and verification
eeglabpath = '/Users/daphne/Desktop/StephenLab Rotation/DT/eeglab2024.0';  % New EEGLAB path
addpath(genpath(eeglabpath));  % Adds the new EEGLAB path and its subdirectories to MATLAB's search path
savepath;

Nchannels = length(HDR.label_finalized); 
data_test = eye(Nchannels);  

data_laplac_test = laplacian_reference(data_test, HDR.label_finalized, Electrode_neighbors);

chanlocs = struct('labels', HDR.label_finalized);

chanlocs = pop_chanedit(chanlocs, 'lookup', fullfile(eeglabpath, 'plugins', 'dipfit', 'standard_BESA', 'standard-10-5-cap385.elp'));

figure; 
Nchannels = length(HDR.label_finalized); 
nrows = ceil(sqrt(Nchannels));  
ncols = ceil(Nchannels / nrows);

for i = 1:Nchannels
    subplot(nrows, ncols, i);  
    topoplot(data_laplac_test(:, i), chanlocs);  
    title(HDR.label_finalized{i});  
end

% Improve subplot layout
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);  % Optionally maximize figure window

% Add title in the bottom left corner 
annotation('textbox', [0.01, 0.01, 0.1, 0.05], 'String', 'Laplacian of All Channels', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontSize', 30);
