
folder = '111312';
daq_file =  '/mr_Ro_n170';
exp_time1 = 57235; exp_time2 = 66141;
tb1 = 57300; 
tb2 = 57427;
t_list = [57235, 57458, 58081, 58707, 59325, 59941, 60571, 61191, 61821, 62441, 63058, 63821, 64612, 64987, 65367, 65741, 66121];
chunk_l = 349;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm
