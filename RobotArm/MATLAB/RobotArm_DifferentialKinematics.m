clear, close all;
clc;

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

% Creating Links with DH - parameters
L(1) = Link('d',L1_d,'a',L1_a,'alpha',pi/2,'offset',L1_offset);
L(2) = Link('d',0,'a',L2,'alpha',0,'offset',L2_offset);
L(3) = Link('d',0,'a',0,'alpha',pi/2,'offset',L3_offset);
L(4) = Link('d',L3+L4,'a',0,'alpha',pi/2,'offset',0);
L(5) = Link('d',0,'a',0,'alpha',pi/2,'offset',L5_offset);
L(6) = Link('d',-(L5+L6),'a',0,'alpha',0,'offset',0);

RobotArm = SerialLink(L,'name', 'RobotArm');

% Need to set the joint limits
RobotArm.qlim = [[-2.1817 2.1817];[-3.4907 1.1345];[-0.6109 4.1015];[-pi pi];[-1.3090 2.6180];[-pi pi]]; 

% Draw elipsoid that demonstrates in which directions the end effector can
% achive high velocities
RobotArm.teach('callback', @(r,q) r.vellipse(q)); 