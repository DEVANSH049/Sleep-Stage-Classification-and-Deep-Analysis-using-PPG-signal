% Specify the patient ID you're interested in
patient_id = 1;

% Load EDF file
edfFile = sprintf('n1%d.edf', patient_id);
[header, data] = edfread(edfFile);

% Find index of PLETH channel
channel_name = "PLETH";
plethIndex = find(strcmp(header.label, channel_name));

% Check if PLETH channel exists
if isempty(plethIndex)
    disp(['Patient ' num2str(patient_id) ' does not have a PLETH signal.']);
else
    % Extract PLETH data
    plethData = data(plethIndex, :);

    % Determine sampling frequency
    fs = header.samples(plethIndex);
    disp(['Patient ' num2str(patient_id) ' PLETH frequency: ' num2str(fs) ' Hz']);

    % Calculate duration in seconds
    duration_seconds = size(plethData, 2) / fs;

    % Divide data into 30-second parts
    segment_length = 30 * fs;
    num_segments = floor(duration_seconds / 30);
    segments = cell(1, num_segments);

    for i = 1:num_segments
        start_index = (i - 1) * segment_length + 1;
        end_index = min(start_index + segment_length - 1, size(plethData, 2));
        segments{i} = plethData(start_index:end_index);
    end

    % Plot the first segment of 30 seconds
    figure;
    plot(segments{1});
    title(['Patient ' num2str(patient_id) ' - First 30-second segment of PLETH data']);
    xlabel('Sample');
    ylabel('PLETH Signal');
end
