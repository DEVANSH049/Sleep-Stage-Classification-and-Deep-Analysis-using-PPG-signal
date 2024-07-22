count = 0;
ins_data = [];
% Initialize cell array to store individual patient segment tables
all_segments = cell(1);

% Loop over all patients
for patient_id = 1
    % Load EDF file
    edfFile = sprintf('ins%d.edf', patient_id);
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

    % Store segments data in the cell array
    all_segments{patient_id} = segments_data;
end
% Concatenate individual patient segment tables
combined_segments_ins = cat(2, all_segments{:});

