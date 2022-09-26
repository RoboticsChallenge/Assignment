% The script vessel.m need to be run before simulink model can be simulated
% it will make sure that all the variables are in the workspace
% copy & past the code into Matlab and run script
% vessel dynamics can be changed by altering variables in the setup part

% setup
L1 = 1;                     % vessel length [m]
L2 = 0.4;                   % vessel width [m]
L3 = 0.3;                   % thruster spacing [m]
L4 = 0.4;                   % back-com dist [m]
L5 = sqrt(L4^2+(L3/2)^2);   % back thruster com dist [m]
L6 = 0.4;                   % side thruster com dist [m]
m = 60;                     % mass [kg]
I = 25;                     % inertia [kg/m^2]
B = atand((L3/2)/L4);       % torque angle (calculated) [deg]
vxm = 5;                    % max forward speed [m/s]
vym = 0.1;                  % max sideways speed [m/s]
wlim = 5000;                % max back thruster [rpm]
wlm = 2*pi*wlim;            % max back thruster [rad/s] [do not change]
wrm = 2*pi*wlim;            % max back thruster [rad/s] [do not change]
wtlim = 6000;               % max side thruster [rpm]
wtm = 2*pi*wtlim;           % max side thruster [rad/s] [do not change]
Rm = 1;                     % max turning radius [m] (back thrusters only)
accel = inf;                % simulink will limit dynamics

% find w max for back and side thruster
wm = (vxm/2)/Rm;


%equations for unknowns
syms bf bt bw bvx bvy
eq1 = bw == bf*(L5*sind(B)*wlm^2)/(I*wm);
eq2 = bw == bt*(L6*sind(B)*wtm^2)/(I*2);
eq3 = bf == bvx*(m*vxm)/(wlm^2+wrm^2);
eq4 = bt == bvy*(m*vym)/(wtm^2);

% one of the variables need to be selected, the rest is calculated
eq5 = bvx == 1.5;

svar = vpasolve([eq1,eq2,eq3,eq4,eq5],[bf,bt,bw,bvx,bvy])
bf = double(svar.bf);
bt = double(svar.bt);
bw = double(svar.bw);
bvx = double(svar.bvx);
bvy = double(svar.bvy);
