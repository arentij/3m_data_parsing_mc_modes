import = 0;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [58095, 58700, 59600, 60300, 61000, 61700];
    t1 = t2-550;
    t1(1) = 57890;
    tb1 = 61850; 
    tb2 = 62100;
    record = grab_3mdata_chunks('050914',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();