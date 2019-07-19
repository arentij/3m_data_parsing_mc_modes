import = 0;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [50390, 51180, 55590, 52340, 53200, 54280];
    t1 = t2-690;
    t1(1) = 49586;
    tb1 = 57349; 
    tb2 = 57690;
    record = grab_3mdata_chunks('050914',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();