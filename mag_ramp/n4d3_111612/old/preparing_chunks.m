
folder = '111612';
daq_file =  '/mr_Ro_n430';
exp_time1 = 60940; exp_time2 = 65111;
tb1 = 60300; 
tb2 = 60450;
t_list = [61080, 61380, 61690, 62057, 62377, 62700, 63010, 63340, 63650, 63974, 64295, 64536, 64912];
chunk_l = 230;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm
