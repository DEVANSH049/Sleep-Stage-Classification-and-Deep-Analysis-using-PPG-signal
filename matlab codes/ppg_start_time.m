ins_data = [];
patient_start_times = [];
all_segments = cell(1,4);  % Pre-allocate for efficiency

% Loop over all patients
for patient_id = 1:4  % Assuming multiple patients

  % Load EDF file
  edfFile = sprintf('sdb%d.edf', patient_id);
  [header, data] = edfread(edfFile);
  start_time = header.starttime;
  patient_start_times{end+1} = start_time;


 
end
