% Solar Array Sizing Code

Pe = ; % Avg Power Required in eclipse [W]
Pd = ; % Avg Power Required in daylight [W]
alt = 300; % Orbit Altitude [km]
t = 90 / 365; % Mission Duration [years]
te = ; % time in eclipse [min]
td = ; % time in daylight [min]
xe = ; %path efficiency
xd = ; %path efficiency

Psa = ((Pe * te / xe) + (Pd * td / xd)) / td; % Power solar array must provide in daylight
n = ; % Solar panel efficiency
Po = 1368; % Solar array power output

Id = ; % Inherent Degridation
theta = ; % Sun Incidence Angle

Pbol = Po * Id * cos(theta); % Power at beginning of life
D = ; % Degredation per year

Ld = (1 - D)^t; % Lifetime degridation

Peol = Pbol * Ld; % Power at end of life

Asa = Psa / Peol; % Solar Array area to support Psa

Dod = ; % Depth of Discharge
Nb = ; % number of batteries
nb = ; % Battery efficiency

C = Pe * Te / (Dod * Nb * nb); % Spacecraft Battery Capacity

Ed = ; % Energy density

mb = C * Ed; % Mass of batteries