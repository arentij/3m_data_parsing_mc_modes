% 
import = 0;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    t1 = 22+ [63573, 63899, 64218, 64530, 64849, 65168, 65509, 65816, 66140, 66465, 66785, 67187, 67505, 67858, 68169];
    t2 =     [63894, 64215, 64528, 64847, 65166, 65503, 65814, 66138, 66460, 66779, 67144, 67492, 67850, 68157, 68472];
    tb1 = t1(1);
    tb2 = t2(1);
    record = grab_3mdata_chunks('111412',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();