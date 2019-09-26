data = record{1, 3}{1, 4};
g_data = record{1, 3}{1, 6};

L = length(data);

t1=1;
t2 = fix(L);

g33= gcoeff33(data(t1:t2,:),probepos33());
g31= gcoeff3m(data(t1:t2,1:31),probepos());

% err = ((g33-g_data)./mean(abs(g33))).^2;

diff33_31 = ((g33-g_data)./mean(abs(g33))).^2;

% imagesc(rms_err)
figure()

plot((std(diff33_31)).^0.5)

% waterfall(diff33_31.^0.5)