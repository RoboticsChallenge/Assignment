clear, close all;

%%
% This script creates trajectories between three points. Home position,
% pick up plastic position and release plastic position and then goes back to
% home position again.
%%

% Link lengths
L1 = 0.162575;
L1_d = 0.112;
L1_a = 0.117839;
L2 = 0.28;
L3 = 0.186904;
L4 = 0.109554;
L5 = 0.08561; 
L6 = 0.116047;

% Link Offsets
L1_offset = pi;
L2_offset = 2.35619;
L3_offset = -0.7853734;
L5_offset = 0.68033;

% Creatin Links with DH - parameters
L(1) = Link('d',L1_d,'a',L1_a,'alpha',pi/2,'offset',L1_offset);
L(2) = Link('d',0,'a',L2,'alpha',0,'offset',L2_offset);
L(3) = Link('d',0,'a',0,'alpha',pi/2,'offset',L3_offset);
L(4) = Link('d',L3+L4,'a',0,'alpha',pi/2,'offset',0);
L(5) = Link('d',0,'a',0,'alpha',pi/2,'offset',L5_offset);
L(6) = Link('d',-(L5+L6),'a',0,'alpha',0,'offset',0);

RobotArm = SerialLink(L,'name', 'RobotArm');

% Need to set the joint limits
RobotArm.qlim = [[-2.1817 2.1817];[-3.4907 1.1345];[-0.6109 4.1015];[-pi pi];[-1.3090 2.6180];[-pi pi]]; 

% Defines a workplace window to operate in Matlab. 
W = [-1 1 -1 1 -1 1]; 

% Forward kinematic to find "Home-Pos" 
T0 = RobotArm.fkine([0 0 0 0 0 0]);

% Positions given in angles, with inverse kinematics:
HOME = RobotArm.ikine(T0,'mask',[1 1 1 1 1 1]); % Home pos in angles 

PLASTIC = [deg2rad(90) deg2rad(-137) deg2rad(100) deg2rad(0) deg2rad(2.2) deg2rad(0)] % Chosen Pickup position
RELEASE = [deg2rad(0) deg2rad(-24) deg2rad(200) deg2rad(-180) deg2rad(18) deg2rad(0)] % Release plastic position

% Then we make a trajectory calculated with 50 iterations.
% Trajectory from "Home pos" --> "Pickup pos"
Trajectory1 = jtraj(HOME, PLASTIC , 50) 

% Plots the arm movement
RobotArm.plot(Trajectory1, 'workspace', W)
hold on

pause(2)

% Trajectory from "Pickup pos" --> "Release plastic pos"
Trajectory2 = jtraj(PLASTIC, RELEASE , 50) 

% Let's now plot the movement:
RobotArm.plot(Trajectory2, 'workspace', W)
hold on

pause(2)

% Trajectory from "Release plastic pos" --> "home pos"
Trajectory3 = jtraj(RELEASE, HOME , 50) 

% Let's now plot the movement:
RobotArm.plot(Trajectory3, 'workspace', W)
hold on


