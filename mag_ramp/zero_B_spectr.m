bn = 1;

data_sph = record{bn, 3}{1, 6};
data_33  = record{bn, 3}{1, 4};
data_p   = record{bn, 3}{1, 3};
f_o  = abs(record{bn, 2}(2));

figure(2)
for i=1:24
    
    spec_vec = 10/log(10)*log(pwelch(data_sph(:,i)-mean(data_sph(:,i))));
    
    if i == 1
        length_pwelch = length(spec_vec);
        f = [0:(length(spec_vec)-1)]/(length(spec_vec)-1)*128/f_o;
        ind_f_eq_2 = find(f>2,1)+1;
        spectr_gauss_coeff = zeros(ind_f_eq_2,24);

    end
    spectr_gauss_coeff(1:ind_f_eq_2,i) = spec_vec(1:ind_f_eq_2);
end

waterfall(f(1:ind_f_eq_2),(1:24),(spectr_gauss_coeff'))
% title('')
% xlabel('\omega/\Omega_{out}','FontSize',18);
% ylabel('Lehnard number','FontSize',18);
% zlabel('Hall Probes average power density, dB');

figure(3)
for i=1:33
    
    spec_vec = 10/log(10)*log(pwelch(data_33(:,i)-mean(data_33(:,i))));
    
    if i == 1
        length_pwelch = length(spec_vec);
        f = [0:(length(spec_vec)-1)]/(length(spec_vec)-1)*128/f_o;
        ind_f_eq_2 = find(f>2,1)+1;
        spectr_gauss_coeff = zeros(ind_f_eq_2,24);

    end
    spectr_gauss_coeff(1:ind_f_eq_2,i) = spec_vec(1:ind_f_eq_2);
end

waterfall(f(1:ind_f_eq_2),(1:33),(spectr_gauss_coeff'))
