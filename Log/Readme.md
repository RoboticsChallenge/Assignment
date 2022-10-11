# Robotics Challenge - Log

### Description
Meeting summaries...

## 11/10/22
- Updated dimensions on model. Model Scales by a factor of 10. Size of model now matches the task description
  of 1m length and 40cm width. Added 4 new camera points IAW PDR breif, one left, one right, one overview of arm and one on the arm.

## 04/10/22
- Made PDR breif

## 30/9/22
- Added framework and folder setup for robot repo
- Added new Repo for robot https://github.com/RoboticsChallenge/ROS_Robot
- added 3D model boat with 6DOF arm 

## 29/9/22
- Kinematic model with matlab simulation code uploaded to assignment repo

## 20/9/22:
- Defined dynamic model for vessel
- Redefinition of task requirements
  -  task search area set 1NM x 1NM
  -  additional added thruster in relative y direction of vessel.
- Discussed Navigation Strategies
2 strategies for navigation is proposed by group
  - Map based navigation planning
    - group descision lattice planer, lattice radius must be appropiate in accordace with arm length   
  - Reactive exploration of unknown enviroment
    - Shore search algorithm, random search algorithm  
  - object found phase
    - phases ship will conduct after detection of object
    - vision system needed for transition descision and object tracking.
- Descided preliminary control strategy for navigation
  - point to point navigation based on set point and navigation trajectory
- Sensor-package for vessel
  - Position sensory   
    - IMU
    - GPS
  - Camera package
    - Rangefinder
    - Vision   
- Assigned individual tasks / responsibilities
  - see main GitHub page...
