import = 1;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [61380, 61690, 62057, 62377, 62700, 63010, 63340, 63650, 63974, 64295, 64536, 64912];
    t1 = t2-230;
    tb1 = 60300; 
    tb2 = 60450;
    record = grab_3mdata_chunks('111612',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();