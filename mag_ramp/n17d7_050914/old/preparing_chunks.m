
folder = '050914';
daq_file = '/050914_3';
exp_time1 = 57840; exp_time2 = 61740;
tb1 = 61850; tb2 = 62100;
t_list = [58100, 58100, 58700, 59600, 60300, 61000, 61700];
chunk_l = 550;

if 1
    [data, time, abstime] = daqread(['/data/3m/' folder daq_file]);
    dossm();
    time = time + ssm;
    ['T1= ' num2str(fix(time(1))) '  T2= ' num2str(fix(time(end)))];
end

record = prep_chunks(data, time, exp_time1, exp_time2, tb1, tb2, t_list, chunk_l, folder);

clearvars folder daq_file exp_time1 exp_time2 tb1 tb2 t_list chunk_l flg abstime ssm

