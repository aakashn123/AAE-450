% Elijah Bass
% AAE 450 - Orbit Boost
% Uncontrolled CWH Relative Motion Simulation

clear; clc; close all;

%% Given Orbital Parameters
mu = 3.986004356e14; % [m^3/s^2] Earth's gravitational parameter 
R_TV = 6721.464e3; % [m] Target vehicle radius

%% Calculated Orbital Parameters
n = sqrt(mu / R_TV^3); % [rad/s] mean orbital rate 
T_orbit = 2*pi/n; % [s] orbital period

%% Initial Conditions
r0 = -1000; % [m] radial track axis position
s0 = 0; % [m] along-track axis position
z0 = 0; % [m] cross-track axis position
rdot0 = 1.0; % [m/s] radial track axis velocity
sdot0 = 0; % [m/s] along-track axis position
zdot0 = 0; % [m/s] radial track axis position

%% Simulation Setup
X0 = [r0; s0; z0; rdot0; sdot0; zdot0]; % initial condition vector
t_span = [0, T_orbit]; % simulate for 1 orbital period
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % ode tolerances
[t, X_out] = ode45(@(t, X) cwh_unforced(t, X, n), t_span, X0, options);

%% Plotting
figure(1)
hold on; grid on;
plot(X_out(:,2), X_out(:,1), 'b-', 'LineWidth', 2, 'DisplayName', 'Chase Vehicle Path');
plot(s0, r0, 'ks', 'MarkerFaceColor', 'b', 'MarkerSize', 8, 'DisplayName', 'Start Position');
plot(0, 0, 'rp', 'MarkerFaceColor', 'r', 'MarkerSize', 12, 'DisplayName', 'Target Vehicle');
title('Uncontrolled CWH Trajectory (1 Orbit Period)');
xlabel('Downtrack / s-axis (m)');
ylabel('Radial / r-axis (m)');
legend('Location', 'best');
axis equal; hold off;

%% Unforced CWH Equations Function
function dX = cwh_unforced(~, X, n)

    r = X(1); s = X(2); z = X(3);
    rdot = X(4); sdot = X(5); zdot = X(6);

    rddot = 2 * n * sdot + 3 * n^2 * r;
    sddot = -2 * n * rdot;
    zddot = -n^2 * z;
    
    dX = [rdot; sdot; zdot; rddot; sddot; zddot];
end