
%filtfilt()EQ
HLN=[1:4];
MLN=[5:11];
EQ=[12:20];
MLS=[21:27];
HLS=[28:31];

gc0 = [1,4,9,16];
gc1 = [2,5,10,17];
gc2 = [7,12,19];
gc3 = [14,21];
gc4 = [23];

%==========================================
k=2;
f_mode = 0.14
T=3;
k_gap = 0.012;
probes = [MLN];

harmonics_m = gc1;
%==========================================

f_out = abs(record{k,2}(2));
data_m = record{k, 3}{1, 4};
ld = length(data_m);
part_of_l = 0;        % removing first part of the length
data_m =data_m(1+fix(ld*part_of_l):end,:);
% plot(data(:,12))
data_sph=record{k, 3}{1, 6};
data_sph = data_sph(1+fix(ld*part_of_l):end,:);
data_sph = data_sph - mean(data_sph);

for i = 1:24
    data_sph(:,i) = fix(i^0.5)*(fix(i^0.5)+1)* data_sph(:,i);
end

d=data_m(:,probes);
d = d-mean(d);
fs=256;


[b,a]=butter(3,f_out*[-k_gap+f_mode f_mode+k_gap]/fs*2);
y = filtfilt(b,a,d);
t = (1:length(d))/fs*f_out*f_mode;
% plot(t,d,t,y)


figure(1)
i0 = find(t>fix(t(end)/2),1,'first');

i1 = find(t>T+fix(t(end)/2),1,'first')+50;
plot(t(i0:i1),y(i0:i1,:))
title('chosen probes filtered signal in time');

legend(num2str(probes'))
std(y);
pp = probepos33();
pp(probes,3)'/2/pi;


figure(2)
psd = 10*log(pwelch(d(:,:)));
f = (0:(length(psd)-1))/(length(psd)-1)*128/f_out;
plot(f,psd)
xlim([0 2])
title('Spectrum of the chosen probes')


figure(3)
pwelch(y)
xlim([0 2*f_mode*f_out/128])
title('Resultive spectrum after filtering')

figure(4)

psd = 10*log(pwelch(data_sph(:,harmonics_m)));
f = (0:(length(psd)-1))/(length(psd)-1)*128/f_out;
plot(f,psd)
xlim([0 2])

title('Spectrum of the chosen g coeff')


   

probes_signal_orger = zeros(length(probes),T+1);
for ind_ch = 1:length(probes)
    [pks, locs] = findpeaks(y(i0:i1,ind_ch));
    probes_signal_orger(ind_ch,:) = [probes(ind_ch), locs(1:T)'./(i1-i0+1)*T];
end
    
probes_signal_orger_sort = sortrows(probes_signal_orger,2);



ind_of_probe_n12 = find(probes_signal_orger_sort(:,1) ==12,1);
if ind_of_probe_n12
    probes_signal_orger_sort(:,2:T+1) = probes_signal_orger_sort(:,2:T+1) - (probes_signal_orger_sort(ind_of_probe_n12,2));
end

[probes_signal_orger_sort, [0; diff(probes_signal_orger_sort(:,2))] ]


