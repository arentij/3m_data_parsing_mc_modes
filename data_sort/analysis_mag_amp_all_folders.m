
cd('/data/MATLAB/projects/ankit_plus/mag_amplification/')
list_of_days=dir([pwd '/*.mat']);
% save_folder = '';

for i=[16]%:length(list_of_days)
%     if length(list(i).name)

    folder=list_of_days(i).name;
    load(folder)
    folder=folder(1:end-4)

    td1 = t1+30;
    td2 = t2;

    record = grab_3mdata_chunks(folder,td1,td2,tb1,tb2); 
    
%     try
%         save(['output/' folder '_out'], 't1','t2','tb1','tb2','record')
%     catch
%         'File is too big, trying anohther option'
     save(['output/' folder '_out'], 't1','t2','tb1','tb2','record','-v7.3')
%     end
end

