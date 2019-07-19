import = 0;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [54960, 55280, 55593, 55926, 56244,  56585, 56897, 57218, 57531, 57840, 58160, 58468, 58787, 59103, 59420, 59735, 60057, 60379, 60704, 61019, 61260, 61517];
    t1 = t2-250;
    tb1 = 52700; 
    tb2 = 53040;
    record = grab_3mdata_chunks('111412',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();