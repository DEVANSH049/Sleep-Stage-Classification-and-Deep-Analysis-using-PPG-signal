% Load the CSV data
%data = readmatrix('last_comb_plm.csv');  % Replace 'yourfile.csv' with your actual file name
data = combined_segments_norm';
% Extract the number of rows to process
num_rows = size(data, 1);
signal_length = 3840;

% Initialize the wavelet scattering object
sf = waveletScattering('SignalLength', signal_length, 'SamplingFrequency', 128);

% Initialize the feature matrix
feature = [];

% Loop over all epochs in the dataset
for i = 1:num_rows
    % Extract the signal and the label
    signal = data(i, 1:signal_length);
    label = "n";
   
    % Apply wavelet scattering transform
    [smat, u] = featureMatrix(  sf, signal');
   
    % Compute the mean of the scattering coefficients
    p = mean(smat, 2);
   
    % Store the features and label
    feature = [feature; p', label];  % p' to make it a row vector and add "ins" label
end

% Save the feature matrix to a new CSV file
writematrix(feature, 'feature_matrix_n.csv');