
folder = '111512';
daq_file =  '/mr_Ro_n170';
exp_time1 = 54100; exp_time2 = 62200;
tb1 = 62450; 
tb2 = 62900;
t_list = [54171, 54747, 55367, 55989, 56606, 57226, 57844, 58460, 59080, 59700, 60317, 60946, 61589];
chunk_l = 500;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm
