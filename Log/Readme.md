# Robotics Challenge - Log
### Todo
- simulation
  - add ballast displacement module
  - add GPS input for real lat long
### Description
Project day summeries
## 16/10/22
  - found and thrashed bug that caused the terrain in sydney_regatta not to spawn.
      - this removed the neccesity to build the whole VRX_Gazebo package to build sydney_regatta world.
      - problem layed in package.xml Following lines added, to source model file locations in model SDF config
        ``` <gazebo_ros gazebo_model_path="${prefix}/models"/> ```
        ``` <gazebo_ros gazebo_media_path="${prefix}"/> ```
## 14/10/22
- Added Centerthruster to model
  - Gone away from the concept of 2 thrusters, and now have only one that can rotate 360 degress in front. 
    this ensures that the thruster vector is simulated in the right direction.
- Reworked Thrusters, they can now rotate thrust vector.
- Topics for thruster 
  - ```/ros_robot/thrusters/right_thrust_cmd```      float -1 max forward, 1 max backwards.
  - ```/ros_robot/thrusters/right_thrust_angle```    float  1.57 rads+-
  - ```/ros_robot/thrusters/left_thrust_cmd```       float -1 max forward, 1 max backwards.
  - ```/ros_robot/thrusters/left_thrust_angle```     float  1.57 rads+-
  - ```/ros_robot/thrusters/left_thrust_cmd```       float -1 max forward, 1 max backwards.
  - ```/ros_robot/thrusters/Center_thrust_cmd```     float -1 max forward, 1 max backwards.
  - ```/ros_robot/thrusters/Center_thrust_angle```   float  1.57 rads+- when positive, thruster points towards left and pushes boat to right
## 13/10/22
- Moved project to Noetic installation of ROS and Ubuntu 20.4 iot simulate water.
- reworked urdf, separated sensors and thrusters in own files.
- Applied VRX Package on project in order to simulate water.
- Made own simulated world based on VRX example project.
- Added ocean to simulation.
- Added thrusters to model, currently only back thrusters are working. 
- Added bouancy to model(parameters need to be tweaked)
<img src="https://i.im.ge/2022/10/14/2axspM.gazebo.png" width="800">

## 11/10/22
- Updated dimensions on model. Model Scales by a factor of 10. Size of model now matches the task description
  of 1m length and 40cm width. 
- Added 4 new camera points IAW PDR breif, one left, one right, one overview of arm and one on the arm To model.
- Added URDF model to gazebo under launch file gazebo.launch
- Camera topics /image_raw/camera_arm , /image_raw/camera_back, /image_raw/camera_front, /image_raw/camera_right, /image_raw/camera_left
- moveing model in gazebo is done with Twist to /cmd_vel topic 
- TODO add Gps topic
 
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
