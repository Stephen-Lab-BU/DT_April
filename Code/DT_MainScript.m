%% STEP 1: Defining Electrodes based on our Kayser Laplacian Montage

addpath('/Users/daphne/Desktop/StephenLab     Rotation/DT_April/Functions')
%Call the defineKayesMontage for our Laplacian Montage
[MainChannels, Ch_labels] = defineKayserMontage();
% MainElectrode now contains the array of electrode names
% Ch_labels now contains the map of electrode neighbors

%% STEP 2 : 1) Load data & 2) Simultaneously remove channels based on notes & align data 

% Load data 
load('Archive_1_CN7.mat')

% Specify the output folder path where you want to save the processed HDR and data
outputFolderPath= '/Users/daphne/Desktop/StephenLab     Rotation/Data'; % Replace this with your desired path or leave it out to use the default

% Call the processHDRandData function
[HDR_updated, data_finalized] = processHDRandData(HDR, data, outputFolderPath);
%% STEP3: Laplacian Calculation on Data 

outputFolderPath = '/Users/daphne/Desktop/StephenLab     Rotation/Data';  % Path to the existing 'Data' folder

% If HDR_updated.label_finalized exists and contains the updated channel labels
if isfield(HDR_updated, 'label_finalized')
    HDR_updated_label_finalized = HDR_updated.label_finalized;
else
    error('HDR_updated does not contain label_finalized field.');
end

% Call the modified laplacian_reference function
[data_laplac, validChannels] = laplacian_reference(data_finalized, HDR_updated_label_finalized, Ch_labels, outputFolderPath);

%% STEP4: Plot first channel before & after laplacian_reference.m function

%Can likely remove after E.S. approves
%Call plotLaplacianTransformedSignal function with original EEG data and
%Laplacian-transformed signals
%Plotting channels with insufficient neighbors post-laplacian
plotLaplacianTransformedSignal(data_finalized, data_laplac);
%Notes about bad channels: Index for P7 = 17, Index for T7 = 20 , Index for T8 = 21 

%% STEP 5: Downsample Laplacian-Transformed Data

% Assume HDR.frequency contains the original sampling frequencies in a 1x104 array
originalFs = HDR.frequency(1);  % Using the first value, ensure this is consistent for your data

% Define target sampling frequency
newFs = originalFs/4;  % Downsampling to 256 Hz %Ask E.S. about this - use '/' or actual value '256'?

%Define outputfolderpath for the downsampling data
outputFolderPath_Downsample= '/Users/daphne/Desktop/StephenLab     Rotation/Data';

% Call the function
[dsdata_laplac, dst] = downsampleAndPlotFirstElectrode(data, originalFs, newFs, HDR_updated, outputFolderPath);

% 'dsdata_laplac' now contains the downsampled Laplacian-transformed EEG data
% 'dst' contains the corresponding downsampled time axis
% Downsampled laplacian referenced data is also saved in a separate folder

%% STEP 6: Run spectrograms for every electrode and save the figures 

outputFolderPath_Spectrograms = '/Users/daphne/Desktop/StephenLab     Rotation/Figures';

% Call the function with the defined path
[numFiguresFullSession, numFiguresFocused] = runSpectrograms(dsdata_laplac, newFs, HDR_updated, validChannels, outputFolderPath_Spectrograms);
