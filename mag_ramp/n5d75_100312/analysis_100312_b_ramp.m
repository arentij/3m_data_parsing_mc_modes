import = 1;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [ 64495, 64752, 65015, 65284, 65545, 65862, 66155, 66417, 66666];
    t1 = t2-249;
    tb1 = 63928; 
    tb2 = 64086;
    record = grab_3mdata_chunks('100312',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();