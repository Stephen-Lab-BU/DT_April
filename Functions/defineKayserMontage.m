function [MainChannels, Ch_labels] = defineKayserMontage()
%Description of Fn = Defines electrodes and electrode neighbors from the
%Kayser paper as our montage reference.
%Paper:https://www.sciencedirect.com/science/article/pii/S0167876015001609
% Define all 66 electrodes
    MainChannels = {'Fpz', 'AFz', 'Fz', 'FCz', 'Cz', 'CPz', 'Pz', 'POz', 'Oz', 'Iz', 'Fp1', 'AF3', 'F1', 'FC1', 'CP1', 'P1', 'F3', 'FC3', 'C3', 'CP3', 'P3', 'PO3', 'O1', 'AF7', 'F7', 'FT7', 'T7', 'TP9', 'P9', 'F5', 'FC5', 'C5', 'CP5', 'P5', 'PO7', 'TP7', 'P7', 'Fp2', 'AF4', 'F4', 'FC4', 'C4', 'CP4', 'P4', 'PO4', 'O2', 'F2', 'FC2', 'C2', 'CP2', 'P2', 'AF8', 'F6', 'FC6', 'C6', 'CP6', 'P6', 'PO8', 'F8', 'T8', 'TP8','P10', 'FT8','C1','P8','TP10'};
    % Initialize a containers.Map object to store electrode neighbors
    Ch_labels = containers.Map();
    % Define electrode neighbors based on the referenced paper
    Ch_labels('Fpz') = {'Fp1', 'Fp2', 'AFz', 'AF3','AF4'}; %5 neighbors
    Ch_labels('O1') = {'PO3', 'PO7', 'Iz', 'Oz', 'POz'}; %5 neighbors
    Ch_labels('O2') = {'PO8', 'Oz', 'POz', 'Iz','PO4'}; %5 neighbors
    Ch_labels('AF3') = {'AFz', 'F1', 'F3', 'AF7'};
    Ch_labels('Iz') = {'O2', 'Oz', 'O1'}; %3 neighbors
    Ch_labels('AFz') = {'Fpz', 'AF4', 'AF3', 'F2'};
    Ch_labels('AF4') = {'AF8', 'AFz', 'F4', 'Fp2'};
    Ch_labels('AF7') = {'Fp1', 'AF3', 'F5', 'F7'};
    Ch_labels('AF8') = {'Fp2', 'AF4', 'F8', 'F6'};
    Ch_labels('C1') = {'FC1', 'CP1', 'C3', 'Cz'};
    Ch_labels('AFz') = {'Fpz', 'AF4', 'AF3', 'F2'};
    Ch_labels('C2') = {'C4', 'Cz', 'CP2', 'FC2'};
    Ch_labels('C3') = {'FC3', 'C1', 'C5', 'CP3'};
    Ch_labels('C4') = {'C6', 'C2', 'FC4', 'CP4'};
    Ch_labels('C5') = {'C3', 'T7', 'FC5', 'CP5'};
    Ch_labels('C6') = {'T8', 'C4', 'CP6', 'FC6'};
    Ch_labels('CP1') = {'CP2', 'CP3', 'C1', 'P1'};
    Ch_labels('CP2') = {'CP4', 'CPz', 'C2', 'P2'};
    Ch_labels('CP3') = {'CP1', 'CP5', 'C3', 'P3'};
    Ch_labels('CP4') = {'CP6', 'CP2', 'C4', 'P4'};
    Ch_labels('CP5') = {'CP3', 'C5', 'TP7', 'P5'};
    Ch_labels('CP6') = {'TP8', 'CP4', 'P6', 'C6'};
    Ch_labels('CPz') = {'Cz', 'CP2', 'CP1', 'Pz'};
    Ch_labels('Cz') = {'FCz', 'C1', 'C2', 'CPz'};
    Ch_labels('F1') = {'Fz', 'F3', 'FC1', 'AF3'};
    Ch_labels('F2') = {'AF4', 'F4', 'FC2', 'Fz'};
    Ch_labels('F3') = {'F1', 'F5', 'AF3', 'FC3'};
    Ch_labels('F4') = {'F6', 'F2', 'AF4', 'FC4'};
    Ch_labels('F5') = {'F3', 'F7', 'AF7', 'FC5'};
    Ch_labels('F6') = {'F8', 'FC6', 'F4', 'AF8'};
    Ch_labels('F7') = {'AF7', 'F5', 'FC5', 'FT7'};
    Ch_labels('F8') = {'FT8', 'F6', 'AF8', 'FC6'};
    Ch_labels('FC1') = {'FCz', 'FC3', 'F1', 'C1'};
    Ch_labels('FC2') = {'FC4', 'FCz', 'C2', 'F2'};
    Ch_labels('FC3') = {'FC1', 'FC5', 'C3', 'F3'};
    Ch_labels('FC4') = {'FC6', 'FC2', 'F4', 'C4'};
    Ch_labels('FC5') = {'F5', 'FC3', 'FT7', 'C5'};
    Ch_labels('FC6') = {'FT8', 'F6', 'C6', 'FC4'};
    Ch_labels('FCz') = {'Fz', 'FC2', 'FC1', 'Cz'};
    Ch_labels('Fp1') = {'Fpz', 'AF7', 'AF3', 'AFz'};
    Ch_labels('Fp2') = {'AF4', 'AF8', 'Fpz', 'AFz'};
    Ch_labels('Fpz') = {'Fp1', 'Fp2', 'AFz', 'AF3', 'AF4'};
    Ch_labels('FT7') = {'FC5', 'F5', 'F7', 'T7'};
    Ch_labels('FT8') = {'T8', 'F8', 'FC6', 'F6'};
    Ch_labels('Fz') = {'AFz', 'F1', 'F2', 'FCz'};
    Ch_labels('Oz') = {'O2', 'POz', 'O1', 'Iz'};
    Ch_labels('P1') = {'Pz', 'P3', 'CP1', 'PO3'};
    Ch_labels('P10') = {'P8', 'TP8', 'PO8', 'TP10'};
    Ch_labels('P2') = {'P4', 'Pz', 'CP2', 'PO4'};
    Ch_labels('P3') = {'P1', 'P5', 'CP3', 'PO3'};
    Ch_labels('P4') = {'P2', 'P6', 'CP4', 'PO4'};
    Ch_labels('P5') = {'P3', 'P7', 'CP5', 'PO7'};
    Ch_labels('P6') = {'P8', 'P4', 'CP6', 'PO8'};
    Ch_labels('P7') = {'P5', 'PO7', 'P9', 'TP9'};
    Ch_labels('P9') = {'P7', 'TP9', 'TP7', 'PO7'};
    Ch_labels('PO3') = {'P1', 'P3', 'O1', 'PO7'};
    Ch_labels('PO4') = {'PO8', 'O2', 'POz', 'P4'};
    Ch_labels('PO7') = {'P5', 'P7', 'O1', 'PO3'};
    Ch_labels('PO8') = {'P8', 'P6', 'PO4', 'O2'};
    Ch_labels('POz') = {'Pz', 'PO4', 'Oz', 'PO3'};
    Ch_labels('Pz') = {'P2', 'Cpz', 'P1', 'POz'};
    Ch_labels('T7') = {'FT7', 'C5', 'TP7', 'TP9'};
    Ch_labels('T8') = {'TP10', 'FT8', 'C6', 'TP8'};
    Ch_labels('TP7') = {'CP5', 'TP9', 'P7', 'T7'};
    Ch_labels('TP8') = {'TP10', 'T8', 'P8', 'CP6'};
    Ch_labels('TP9') = {'T7', 'TP7', 'P9', 'P7'};
    Ch_labels('TP10') = {'TP8', 'T8', 'P10', 'PO8'};
    Ch_labels('P8') = {'TP8', 'P10', 'P6', 'PO8'};
end