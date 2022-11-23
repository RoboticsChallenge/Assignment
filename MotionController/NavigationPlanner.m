% Motion planner
% The intent of this script is to demonstart how the navigation planner
% would be used to create a path for the robot to follow
% The map of the harbour and the RRT* algorithm is not actually
% implemented, but would be used in ecatly the same ways as PRM
% For this demonstartation the map to Peter Corke of a house is used and the
% PRM planner is used to place nodes on the map
% The princicple would be same for our vessel. The RRT* algorithm will
% place nodes at good (calculated) locations instead of random as PRM.
% When using the precalculated nodes our planner will also use A* to search
% for an optimal path throught the graph.
clear all, close all, clc
load house
prm = PRM(house);           % load the map into the planner
prm.plan('npoints', 150)    % place nodes at strategic locations

init = [25 180];            % vessel position recived from sensor package
final = [400 10];           % desired end position
prm.query(init, final)      % calculate a path from current to target position
prm.plot()                  

% the coordinates from the planer will be feed as target positions to the
% motion controller with a fixed time interval. The controller will be
% casing this moving target location along the path thereby creating a trajectory
