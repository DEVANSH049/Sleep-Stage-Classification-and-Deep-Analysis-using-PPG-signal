% Load the EDF file

for patient_id = 1:2
    % Load EDF file
    edfFile = sprintf('ins%d.edf', patient_id);
    [header, data] = edfread(edfFile);

    channel_name = "EMG1EMG2";
    EMGIndex = find(strcmp(header.label, channel_name));

    % Extract PLETH data
    EMGData = data(EMGIndex, :);

    % Determine sampling frequency
    fs_emg = header.samples(EMGIndex);

    numRowsEMG = find(EMGData, 1, 'last');
    timeEMG = numRowsEMG / fs_emg;


    channel_name_1 = "PLETH";
    PLETHIndex = find(strcmp(header.label, channel_name_1));

    % Extract PLETH data
    PLETHData = data(PLETHIndex, :);

    % Determine sampling frequency
    fs_pleth = header.samples(PLETHIndex);

    numRowsPLETH = find(PLETHData, 1, 'last');

    % Check if the number of rows in PLETH data equals the calculated time from EMG data
    if numRowsPLETH == timeEMG * fs_pleth
        disp('Number of rows in PLETH data matches the calculated time from EMG data.');
    else
        disp('Number of rows in PLETH data does not match the calculated time from EMG data.');
    end
end