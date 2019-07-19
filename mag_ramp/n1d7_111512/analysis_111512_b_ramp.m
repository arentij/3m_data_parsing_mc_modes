import = 0;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [54747, 55367, 55989, 56606, 57226, 57844, 58460, 59080, 59700, 60317, 60946, 61589];
    t1 = t2-500;
    t1(1) = 54128;
    tb1 = 62450; 
    tb2 = 62900;
    record = grab_3mdata_chunks('111512',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();