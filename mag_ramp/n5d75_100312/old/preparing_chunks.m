
folder = '100312';
daq_file = '/mr_Ro_n575';
exp_time1 = 64184; exp_time2 = 66740;
tb1 = 63928; 
tb2 = 64086;
t_list = [64230, 64495, 64752, 65015, 65284, 65545, 65862, 66155, 66417, 66666];
chunk_l = 249;

if 0
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm
