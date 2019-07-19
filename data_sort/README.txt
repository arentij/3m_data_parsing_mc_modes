File 'data3m_all_ro_mag_w_ek_re_etc.mat' 
contains a cell object with information about different runs of 
3M experiment with sodium. 
Each data point is a run with fixed Rossby number.

The variable is 'results', each results{1,i} contains three cells:
results{1,i}{1,1} - 'mmddyy' is the day the data was taken

results{1,i}{1,2} - [Ro, fi, fo, t0, t1, Ek, Re, Rm]: 
----------------- - [1,  2,  3,  4,  5,  6,  7,  8]: 
1-Reynolds number, 2-inner sphere rotation rate, 3-outer sphere rotation rate, 
4-time of the start, 5-time of the end (SSM format), 6-Ekmann number (might be wrong up to a constant 2Pi), 
7-Reynolds number, 8-magnetic Reynolds number

results{1,i}{1,3} - [I] vector containing values of the current through the coil/s as a function of time.

  