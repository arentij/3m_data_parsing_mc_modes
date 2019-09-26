% 
import = 1;
recalc = 1;
plotting = 1;
save_folder = '';

if import 
    
    t2 = [57458, 58081, 58707, 59325, 59941, 60571, 61191, 61821, 62441, 63058, 63821, 64612, 64987, 65367, 65741, 66121];
    t1 = t2-349;
    t1(1) = 57236;
    tb1 = 57300; 
    tb2 = 57427;
    record = grab_3mdata_chunks('111312',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();