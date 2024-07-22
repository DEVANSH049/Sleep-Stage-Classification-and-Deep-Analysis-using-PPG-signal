% Load data from CSV file
Final_nfle_Wavelet = [];
All_ins_PPG = readmatrix('last_comb_ins.csv');  % Load data from CSV file
chunk_size = 10;  % We will process only the first 10 rows

% Initialize wavelet scattering transform
sf = waveletScattering('SignalLength', 3840, 'SamplingFrequency', 128);

% Process only the first 10 rows
for i = 1:chunk_size:min(10, size(All_ins_PPG, 1))  % Process only up to the 10th row
    fprintf('Processing row index: %d\n', i);  % Progress display
   
    temp_Wavelet = [];
   
    data_chunk = All_ins_PPG(i:min(i + chunk_size - 1, 10), :);  % Ensure not to go beyond the 10th row
   
    for jk = 1:size(data_chunk, 1)
        temp = data_chunk(jk, :);
        temp = handle_non_finite(temp);  % Handle non-finite values
       
        % Ensure the length of temp matches the SignalLength (3840)
        if length(temp) < 3840
            temp = [temp, zeros(1, 3840 - length(temp))];  % Pad with zeros
        elseif length(temp) > 3840
            temp = temp(1:3840);  % Trim to 3840
        end
       
        smat_A = featureMatrix(sf, temp);
        temp_Wavelet = cat(1, temp_Wavelet, smat_A');
    end
   
    Final_nfle_Wavelet = cat(1, Final_nfle_Wavelet, temp_Wavelet);
   
    % Save the data after processing the chunk
    filename = "Wavelet_Scattering_ins_PPG.csv";
    writematrix(Final_nfle_Wavelet, filename);
end

% Visualization of the first transformed row for simplicity
%figure;
%imagesc(Final_nfle_Wavelet');
%title('Wavelet Scattering Transform');
%xlabel('Feature Index');
%ylabel('Time/Scale');
%colorbar;

% Function to handle non-finite values by interpolation
function data = handle_non_finite(data)
    if any(~isfinite(data))
        data(~isfinite(data)) = interp1(find(isfinite(data)), data(isfinite(data)), find(~isfinite(data)), 'linear', 'extrap');
    end
end