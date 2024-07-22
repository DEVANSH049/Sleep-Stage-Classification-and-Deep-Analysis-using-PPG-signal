% Load data from CSV file
Final_nfle_Wavelet = [];
All_ins_PPG = readmatrix('last_comb_nfle.csv');  % Load data from CSV file

% Initialize wavelet scattering transform
sf = waveletScattering('SignalLength', 3840, 'SamplingFrequency', 128);

% Initialize label vector
labels = [];

% Process all rows
for i = 1:size(All_ins_PPG, 1)
    fprintf('Processing row index: %d\n', i);  % Progress display
   
    temp_Wavelet = [];
   
    data_chunk = All_ins_PPG(i, :);  % Get one row at a time
   
    temp = handle_non_finite(data_chunk);  % Handle non-finite values
   
    % Ensure the length of temp matches the SignalLength (3840)
    if length(temp) < 3840
        temp = [temp, zeros(1, 3840 - length(temp))];  % Pad with zeros
    elseif length(temp) > 3840
        temp = temp(1:3840);  % Trim to 3840
    end
   
    smat_A = featureMatrix(sf, temp);
    temp_Wavelet = cat(1, temp_Wavelet, smat_A');
   
    % Count the number of segments (rows) in temp_Wavelet
    num_segments = size(temp_Wavelet, 1);
   
    % Add label 0 for each segment
    labels = [labels; zeros(num_segments, 1)];
   
    Final_nfle_Wavelet = cat(1, Final_nfle_Wavelet, temp_Wavelet);
end

% Combine wavelet features with labels
Final_nfle_Wavelet_labeled = [Final_nfle_Wavelet, labels];

% Save the data after processing all rows
filename = "Wavelet_Scattering_nfle_PPG.csv";
writematrix(Final_nfle_Wavelet_labeled, filename);

% Function to handle non-finite values by interpolation
function data = handle_non_finite(data)
    if any(~isfinite(data))
        data(~isfinite(data)) = interp1(find(isfinite(data)), data(isfinite(data)), find(~isfinite(data)), 'linear', 'extrap');
    end
end