function plotLaplacianTransformedSignal(dataFinalized, dataLaplac)
    % This function plots the first electrode/channel from dataFinalized and dataLaplac.
    
    % Validate input dimensions
    assert(size(dataFinalized, 1) >= 1, 'The finalized data should have at least one channel.');
    assert(all(size(dataFinalized) == size(dataLaplac)), 'The finalized and Laplacian-transformed data should have the same dimensions.');

    % Create figure and plot data from the first channel before Laplacian transformation
    figure;
    subplot(2, 1, 1);  
    plot(dataFinalized(1, :), 'r'); 
    title('Signal for Channel 1 Before Laplacian Transformation');
    xlabel('Time Points');
    ylabel('Amplitude');

    % Plot data from the first channel after Laplacian transformation
    subplot(2, 1, 2);  
    plot(dataLaplac(1, :), 'b');  
    title('Signal for Channel 1 After Laplacian Transformation');
    xlabel('Time Points');
    ylabel('Amplitude');

    % Optionally: adjust subplot spacing for better visibility
    %set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Maximize figure window
    %set(gcf, 'Position', get(0, 'Screensize')); % Maximize figure based on screen size
end
