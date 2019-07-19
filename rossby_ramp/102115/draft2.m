
d_eq1 = record{6, 3}{1, 4}(:,12);
d_eq2 = record{6, 3}{1, 4}(:,13);
d_eq3 = record{6, 3}{1, 4}(:,14);

f1 = fft(d_eq1-mean(d_eq1));
f2 = fft(d_eq2-mean(d_eq2));
f3 = fft(d_eq3-mean(d_eq3));

p1 = pwelch(d_eq1-mean(d_eq1));

a1 = angle(f1);
a2 = angle(f2);
a3 = angle(f3);

f = [0:(length(a1)-1)]/(length(a1)-1)*128/record{6, 2}(1)*-1  ;

figure(1)
plot(f,log(abs(f3)))
xlim([0 2])
figure(2)
plot(f,(a1-a2).*abs(f3))
xlim([0 2])



