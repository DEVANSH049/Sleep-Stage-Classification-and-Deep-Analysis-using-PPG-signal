% Load the feature matrix
feature_matrix = readmatrix('feature_matrix_ins.csv');

% Get the number of features and labels
[num_rows, num_columns] = size(feature_matrix);

% Determine the number of features (assuming last column is the label)
num_features = num_columns - 1;

% Loop over each row and plot the features
for i = 1:20
    % Extract the features and label for the current row
    features = feature_matrix(i, 1:num_features);
    label = feature_matrix(i, end);
   
    % Create a new figure for each row
    figure;
   
    % Plot the features
    plot(features);
   
    % Add title and labels
    title(['Features for Row ' num2str(i) ', Label: ' num2str(label)]);
    xlabel('Feature Index');
    ylabel('Feature Value');
   
    % Optionally, save the plot as an image file
    saveas(gcf, ['feature_plot_row_' num2str(i) '.png']);
end
