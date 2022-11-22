% Extended Kalman Filter
function [xp]= fcn(wl, wr, wt, gpsx, ax, gpsy, ay, theta, w)

% setup variables for discrete dynamical model
% this setup is performed in the matlab directory once and not inside this block
% having it inside this block make the code run every sample (inefficient)
% included here for completeness in the report
bf = 0.00000022797266319525999242560527370454;
bt = 0.000000047494304832345840121157828362533;
bvx = 1.5;
bvy = 11.250000000000000471813528064349;
bw = 0.54;
L1 = 1;                     % vessel length
L2 = 0.4;                   % vessel width
L3 = 0.3;                   % thruster spacing
L4 = 0.4;                   % back-com dist
L5 = sqrt(L4^2+(L3/2)^2);   % back thruster com dist
L6 = 0.4;                   % side thruster com dist
m = 60;                     % mass
I = 25;                     % inertia
B = atand((L3/2)/L4);       % torque angle (calculated)
cf = bf/m;
ct = bt/m;
baf = (L5*sind(B)*bf)/I;
bat = (L6*bt)/I;

% setup variables for extended kalman filter
% same as above, only persistent variables need to be declared inside block
persistent P
if isempty(P) P = diag([10 10 10 10 10 10 10 10 10]); end
R = diag([1 0.1 1 0.1 5 0.1].^2);
Q = diag([0.01 0.05 0.01 0.01 0.05 0.01 0.2 0.05 0.01]);
Fx = @(cos,sin) [1 cos*dt cos*dt^2/2 0 -sin*dt -sin*dt^2/2 0  0    0;
                 0   1         dt    0    0        0       0  0    0;
                 0 -bvx        0     0    0        0       0  0    0;
                 0 sin*dt sin*dt^2/2 1 cos*dt  cos*dt^2/2  0  0    0;
                 0   0         0     0    1        dt      0  0    0;
                 0   0         0     0  -bvy       0       0  0    0;
                 0   0         0     0    0        0       1  dt dt^2/2;
                 0   0         0     0    0        0       0  1   dt;
                 0   0         0     0    0        0       0 -bw  0];
Fw = eye(9);
Hx = [1 0 0 0 0 0 0 0 0;
      0 0 1 0 0 0 0 0 0;
      0 0 0 1 0 0 0 0 0;
      0 0 0 0 0 1 0 0 0;
      0 0 0 0 0 0 1 0 0;
      0 0 0 0 0 0 0 1 0];
Hv = eye(6);

% initialize predicted values to zero(will converge to optimal estimate eventually)
persistent xe
if isempty(xe) xe = [0;0;0;0;0;0;0;0;0]; end

% trick to fool filter to believe that gps updates only occour every 100 sample
persistent k
if isempty(k) k = 0; end


% Kalman filter Prediction
axp = -xe(2)*bvx + cf*wl + cf*wr;   % predicted
vxp = xe(2) + xe(3)*dt;             % predicted
sxp = xe(1) + cos(xe(7))*xe(2)*dt + cos(xe(7))*0.5*xe(3)*dt^2 - sin(xe(7))*xe(5)*dt - sin(xe(7))*0.5*xe(6)*dt^2;   % predicted

ayp = -xe(5)*bvy + ct*wt;   % predicted
vyp = xe(5) + xe(6)*dt;     % predicted
syp = xe(4) + sin(xe(7))*xe(2)*dt + sin(xe(7))*0.5*xe(3)*dt^2 + cos(xe(7))*xe(5)*dt + cos(xe(7))*0.5*xe(6)*dt^2;   % predicted

tap = xe(7) + xe(8)*dt + 0.5*xe(9)*dt^2;    % predicted
wap = xe(8) + xe(9)*dt;                     % predicted
aap = -xe(8)*bw - baf*wl + baf*wr + bat*wt*(1-(9*xe(2))/50);    % predicted

xp = [sxp; vxp; axp; syp; vyp; ayp; tap; wap; aap];  % predicted values

% Kalman filter Correction
% map inputs to vector of measurements, use new gps values only every 100 sample
if mod(k,100) ~= 0  % new gps reading
    z = [gpsx; ax; gpsy; ay; theta; w];
else % treat old xy estimated values as measurements
    z = [xe(1); ax; xe(4); ay; theta; w];
end

Fxx = Fx(cos(tap),sin(tap));            % evaluate jacobian at timestep
P = Fxx*P*Fxx' + Fw*Q*Fw';              % predict new covariance matrix
K = P*Hx'*inv(Hx*P*Hx' + Hv*R*Hv');     % calculate new kalman gain
xe = xp + K*(z - Hx*xp);                % calculate estimate with prediction and inovation
P = (eye(9)-K*Hx)*P;                    % update state covariance matrix
k = k+1;

