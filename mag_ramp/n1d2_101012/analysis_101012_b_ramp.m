
import = 0;
recalc = 0;
plotting = 1;
save_folder = '';

if import 
    t1 = 22+ [60900, 61130, 61330, 61530, 61804, 61997, 62188, 62395, 62592, 62779, 62973, 63171, 63369, 63570, 63776, 63986, 64189, 64428, 64627, 64837, 65041, 65243];
    t2 =     [61117, 61320, 61524, 61796, 61989, 62185, 62391, 62583, 62774, 62966, 63165, 63364, 63566, 63770, 63978, 64162, 64423, 64623, 64832, 65037, 65236, 65523];
    tb1 = 60785;
    tb2 = 61017;
    record = grab_3mdata_chunks('101012',t1,t2,tb1,tb2); 
end

calc_and_plt_mag_ramp();

