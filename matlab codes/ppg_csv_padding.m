count = 0;

% Loop over all patients
for patient_id = 1:5
    % Load EDF file
    edfFile = sprintf('narco%d.edf', patient_id);
    [header, data] = edfread(edfFile);

    % Find index of PLETH channel
    channel_name = "PLETH";
    plethIndex = find(strcmp(header.label, channel_name));

    % Check if PLETH channel exists
    if isempty(plethIndex)
        disp(['Patient ' num2str(patient_id) ' does not have a PLETH signal.']);
        count = count + 1;
        continue; % Skip this patient
    end

    % Extract PLETH data
    plethData = data(plethIndex, :);

    % Determine sampling frequency
    fs = header.samples(plethIndex);
   
    % Find the last non-zero value index efficiently
    lastNonZeroIndex = find(plethData, 1, 'last');

    % Extract data up to the last non-zero value
    plethData = plethData(1:lastNonZeroIndex);

    % Calculate duration in seconds
    duration_seconds = size(plethData, 2) / fs;

    % Divide data into 30-second parts
    segment_length = 30 * fs;
    num_segments = floor(duration_seconds / 30);

    % Initialize matrix to store segments data
    segments_data = zeros(segment_length, num_segments);

    for i = 1:num_segments
        start_index = (i - 1) * segment_length + 1;
        end_index = min(start_index + segment_length - 1, size(plethData, 2));
        segment_data = plethData(start_index:end_index);

        % Store segment data
        segments_data(:, i) = segment_data;
    end

    % Transpose the segment data
    segments_data = segments_data';

    % Load CSV file data
    csv_filename = sprintf('final_narco%d.csv', patient_id); % Adjust the filename as needed
    opts = detectImportOptions(csv_filename, 'VariableNamingRule', 'preserve');
    csv_data = readtable(csv_filename, opts);

    % Align the data by padding with NaN values at the start if necessary
    num_rows_csv = size(csv_data, 1);
    num_rows_mat = size(segments_data, 1);

    if num_rows_csv < num_rows_mat
        % Pad CSV data with NaN values at the start
        padding = array2table(nan(num_rows_mat - num_rows_csv, size(csv_data, 2)), 'VariableNames', csv_data.Properties.VariableNames);
        for var_idx = 1:numel(csv_data.Properties.VariableNames)
            var_name = csv_data.Properties.VariableNames{var_idx};
            if iscell(csv_data.(var_name))
                padding.(var_name) = repmat({''}, size(padding, 1), 1);  % Pad cell columns with empty strings
            end
        end
        csv_data = [padding; csv_data];
    elseif num_rows_csv > num_rows_mat
        % If the CSV data is longer than the matrix data, truncate it to match
        csv_data = csv_data(end-num_rows_mat+1:end, :);
    end

    % Save the padded CSV data back to the original CSV file
    writetable(csv_data, csv_filename);
end