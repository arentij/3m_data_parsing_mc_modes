HLN=[1:4];
MLN=[5:11];
EQ=[12:20];
MLS=[21:27];
HLS=[28:31];

pp=probepos();

% probes = [EQ];
m=10;

probes_lat = [probes',pp(probes,3)];


x0 = 0:2*pi/m:2*pi-0.02;

order = zeros(length(probes_lat),2);

probe_done = zeros(length(probes_lat),1);
amount_probes_done = 0;

steps = 1000;
x1=x0;
for step = 1:steps
    x1 = x1+2*pi/m/steps;
    
    for probe_n=1:length(probes_lat)
        if probe_done(probe_n)
            continue
        end
        
        for gap_ind = 1:m
            if probes_lat(probe_n,2) >= x0(gap_ind) & probes_lat(probe_n,2) <= x1(gap_ind)
                probe_done(probe_n) = 1;
                amount_probes_done=amount_probes_done+1;
                order(amount_probes_done,1) = probes_lat(probe_n,1);
                order(amount_probes_done,2) = step/steps;
                break
            end
        end
    end
end
        
m        
[order, [0; diff(order(:,2))]]
