
folder = '111412';
daq_file =  '/mr_Ro_n430';
exp_time1 = 54600; exp_time2 = 61880;
tb1 = 52700; 
tb2 = 53040;
t_list = [54600, 54960, 55280, 55593, 55926, 56244,  56585, 56897, 57218, 57531, 57840, 58160, 58468, 58787, 59103, 59420, 59735, 60057, 60379, 60704, 61019, 61260, 61517];
chunk_l = 250;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm

