% 
import = 1;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [64453, 64643, 64826, 65021, 65219, 65452, 65634, 65830, 66020, 66280, 66480, 66682, 66870, 67070, 67283, 67478, 67669, 67867, 68055, 68257];
    t1 = t2 - 175;
    tb1 = 64160;
    tb2 = 64430;
    record = grab_3mdata_chunks('100912',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();