% filtfilt()EQ
HLN=[1:4];
MLN=[5:11];
EQ=[12:20];
MLS=[21:27];
HLS=[28:31];

%==========================================
k=9;
f_mode = 0.518
T=3;
k_gap = 0.01;
probes = [MLS];
%==========================================

f_out = abs(record{k,2}(2));
data_m = record{k, 3}{1, 4};
% plot(data(:,12))



d=data_m(:,probes);
d = d-mean(d);
fs=256;


[b,a]=butter(3,f_out*[-k_gap+f_mode f_mode+k_gap]/fs*2);
y = filtfilt(b,a,d);
t = (1:length(d))/fs*f_out*f_mode;
% plot(t,d,t,y)
figure(1)
i0 = find(t>fix(t(end)/2),1,'first');

i1 = find(t>T+fix(t(end)/2),1,'first')+13;
plot(t(i0:i1),y(i0:i1,:))

% plot(t,y)
legend(num2str(probes'))
std(y);

% xlim([fix(t(end)/2) fix(t(end)/2)+1])
pp = probepos33();
pp(probes,3)'/2/pi;



figure(3)
pwelch(y)
xlim([0 2*f_mode*f_out/128])


if 1
    figure(2)
    psd = 10*log(pwelch(d(:,:)));
    f = (0:(length(psd)-1))/(length(psd)-1)*128/f_out;
    plot(f,psd)
    xlim([0 2])
end


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

