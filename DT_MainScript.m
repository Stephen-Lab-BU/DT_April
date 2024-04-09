%% STEP 1: Defining Electrodes 
addpath('/Users/daphne/Desktop/StephenLab     Rotation/DT_April/Functions')
%Call the defineKayesMontage for our Laplacian Montage
[MainChannels, Ch_labels] = defineKayserMontage();
% MainElectrode now contains the array of electrode names
% Ch_labels now contains the map of electrode neighbors

%% STEP 2 : 1) Load data 2) Simultaneously remove channels based on notes & align data 

% Load data 
load('Archive_1_CN7.mat')

% Call the processHDRandData function for simultaneous channel removal and data
% adjustment - new HDR
[HDR_updated, data_finalized] = processHDRandData(HDR, data); 

%% STEP3: Laplacian Calculation on Data

% Now call laplacian_reference function with the processed data, finalized labels, and montage
[data_laplac, validChannels] = laplacian_reference(data_finalized, HDR_updated.label_finalized, Ch_labels);

% 'data_laplac' now contains the Laplacian-referenced data

%% STEP4: Plot first channel before & after laplacian_reference.m function

%Can likely remove after E.S. approves
%Call plotLaplacianTransformedSignal function with original EEG data and
%Laplacian-transformed signals
plotLaplacianTransformedSignal(data_finalized, data_laplac);

%% STEP 5: Downsample Laplacian-Transformed Data

% Assume HDR.frequency contains the original sampling frequencies in a 1x104 array
originalFs = HDR.frequency(1);  % Using the first value, ensure this is consistent for your data

% Define your target sampling frequency
newFs = originalFs/4;  % Downsampling to 256 Hz %Ask Emily about this 

% Call the function to downsample and plot before and after downsampling on
% first electrode
[dsdata_laplac, dst] = downsampleAndPlotFirstElectrode(data_laplac, originalFs, newFs, HDR_updated);

% 'dsdata_laplac' now contains the downsampled Laplacian-transformed EEG data
% 'dst' contains the corresponding downsampled time axis

%% STEP 6: Run spectrograms for every electrode and save the figures 

addpath(genpath('//Users/daphne/Desktop/StephenLab     Rotation/chronux_2_12'));

addpath('/Users/daphne/Desktop/StephenLab     Rotation/DT_April/Functions')

[numFiguresSet1, numFiguresSet2] = runSpectrograms(dsdata_laplac, newFs, HDR_updated, validChannels);

%fix downsampling code, rerun spectrograms, session spectrograms, create a
%new spectrogram that is only 2 mins, read multitaper paper, 