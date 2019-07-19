
folder = '050914';
daq_file ='/050914_2';
exp_time1 = 49585; exp_time2 = 56920;
tb1 = 57349; 
tb2 = 57690;
t_list = [49700, 50390, 51180, 55590, 52340, 53200, 54280]; %, 56780];
chunk_l = 690;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm