
clear

A = 22.419; % Total spacecraft surface area (m^2)
Af = 1.077; % Projected area toward Sun (m^2)
Tspace = 4; % Deep-space temperature (K)
Tearth = 290; % Earth effective temperature (K)
sigma = 5.67e-8; % Stefan-Boltzmann constant (W/m^2-K^4)

emissivity = linspace(0.01,1,1000);
absorptivity = linspace(0,1,1000);

Fearth = 0.321;
Fspace = 1 - Fearth;

[e,a] = meshgrid(emissivity,absorptivity);

% Absorbed heat inputs (W)
Qint = 100;
Qsolar = a .* Af .* 1367;
Qalbedo = a .* A .* Fearth .* 410;

% Emitted thermal radiation (W)
Qradspace = e .* A .* Fspace .* sigma .* Tspace^4;
Qradearth = e .* A .* Fearth .* sigma .* Tearth^4;

% Radiative equilibrium
T = ((Qint + Qsolar + Qalbedo + Qradspace + Qradearth) ...
    ./ (e .* A .* sigma)).^0.25 - 273.15;

Tcold = ((Qint + Qradspace + Qradearth) ...
    ./ (e .* A .* sigma)).^0.25 - 273.15;

% Plot
figure(1)
surf(e,a,T)
xlabel('Emissivity')
ylabel('Absorptivity')
zlabel('Equilibrium Temperature (°C)')
title('Spacecraft Equilibrium Temperature in Sunlight')
colorbar
grid on
shading interp

figure(2)
plot(a, Tcold)
xlabel('Absorptivity')
ylabel('Equilibrium Temperature (°C)')
title('Spacecraft Equilibrium Temperature in Eclipse')
grid on

% Identify combinations within acceptable temperature range
valid = (T >= 0) & (T <= 20);

% Keep only acceptable temperatures
T_valid = T;
T_valid_cold = Tcold;
T_valid(~valid) = NaN;
T_valid_cold(~valid) = NaN;

% Plot acceptable region only
figure(3)
surf(e, a, T_valid)

xlabel('IR Emissivity')
ylabel('Solar Absorptivity')
zlabel('Equilibrium Temperature (°C)')
title('Acceptable Spacecraft Thermal Design Region in Sunlight')
colorbar
clim([0 20])
zlim([0 20])
grid on
shading interp

figure(4)
surf(e, a, T_valid_cold)

xlabel('Emissivity')
ylabel('Absorptivity')
zlabel('Equilibrium Temperature (°C)')
title('Acceptable Spacecraft Thermal Design Region in Eclipse')
colorbar
clim([0 20])
zlim([0 20])
grid on
shading interp
% Count valid combinations
fprintf('Acceptable combinations: %d out of %d (%.2f%%)\n', ...
    nnz(valid), numel(valid), 100*nnz(valid)/numel(valid));
