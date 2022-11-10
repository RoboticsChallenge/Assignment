clear, close all;

% Link lengths
L1 = 0.162575;
L1_d = 0.112;
L1_a = 0.117839;
L2 = 0.28;
L3 = 0.186904;
L4 = 0.109554;
L5 = 0.08561; 
L6 = 0.116047;


% Creating Links with DH - parameters
L(1) = Link('d',L1_d,'a',L1_a,'alpha',pi/2,'offset',0);
L(2) = Link('d',0,'a',L2,'alpha',0,'offset',0);
L(3) = Link('d',0,'a',0,'alpha',pi/2,'offset',0);
L(4) = Link('d',L3+L4,'a',0,'alpha',pi/2,'offset',0);
L(5) = Link('d',0,'a',0,'alpha',pi/2,'offset',0);
L(6) = Link('d',-(L5+L6),'a',0,'alpha',0,'offset',0);

% Creating seriallink object
RobotArm = SerialLink(L,'name', 'RobotArm');

% Need to set the joint limits
RobotArm.qlim = [[-2.1817 2.1817];[-3.4907 1.1345];[-0.6109 4.1015];[-pi pi];[-1.3090 2.6180];[-pi pi]]; 

% Joint angles for forward kinematics calculations
qi = [0 0.3 1 0];

% Calculates transformation matrix without using peter corc toolbox
T_array = {};
for i = 1:4
    T_array{i} = [cos(qi(i)) -sin(qi(i))*cos(RobotArm.links(i).alpha) sin(qi(i))*sin(RobotArm.links(i).alpha) RobotArm.links(i).a*cos(qi(i));
                 sin(qi(i)) cos(qi(i))*cos(RobotArm.links(i).alpha) -cos(qi(i))*sin(RobotArm.links(i).alpha) RobotArm.links(i).a*sin(qi(i));
                 0 sin(RobotArm.links(i).alpha) cos(RobotArm.links(i).alpha) RobotArm.links(i).d;
                 0 0 0 1];
end    

% Writes out result
T = T_array{1}*T_array{2}*T_array{3}*T_array{4}
