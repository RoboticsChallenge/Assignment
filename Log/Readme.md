# Robotics Challenge - Log
### Todo
- Add kinetic camera for object position
- Finish DH - parameters []
- Design forward kinematics []
- Design inverse kinematics []
- Link matlab with gazebo []
- Design trajectory and simulate in Matlab/Gazebo []

### Description
Project day summeries
## 16/11/22 
  - Added sensor array transformation calculations to report
## 16/11/22 common log Lars and Sander
  - Implemented RobotArm_CDR script for simulating arm movement in gazebo, with video. 
    Using Trajectory planning in matlab to move the arm in gazebo.
  - experimented with including different shapes in gazebo for the robot arm to pickup. 
## 15/11/22 common log Lars and Sander
  - Finished trajectory motion planning in matlab, with simulation video.
  - Implemented transmission and controllers for each joint in ROS.
  - Created topics for joint positions.
  - Started on matlab controller for robot arm. 
## 13/11/22 common log Lars and Sander
  - Calculated inverse kinematics in matlab.
  - Started working on motion planning in matlab. 
## 10/11/22 common log Lars and Sander
  - Had project meeting with the teachers about the RobotArm.
  - Found and calculated offset's for the joints
  - Completed the DH-parameters
  - Made SerialLink object for RobotArm in Matlab. 
  - Made matlab scripts for calculating forward kinematics without using peter cork toolbox.
    for all links and for the first 4 links.
  - Started developing robotarm controller in matlab.
## 09/11/22 common log Lars and Sander  
  - Started making a script for calculating inverse kinematics.
  - Worked on making SerialLink object and DH-parameters in matlab. 
## 03/11/22 common log Lars and Sander
  - Measured the lenght of each Link in Fusion 360. 
  - Desiged robotArm in matlab using Peter Corke Toolbox (ETS.3) with the correct link-lenghts
  - Started on the DH-parameters
## 02/11/22
  - imported robot arm files to matlab
  - tested different positions and trejectories using invers kinematics
  - completed the CDR presentation
## 27/10/22
  - Added Enxtended kalman filter to final report
  - Added IMU to final report
  - Added Localization strategy to final report
## 26/10/22
  - After debate, it was decided to fix the coordinate issues with model
    - issue with model was -x axis was forward. Due to the amount of manual changes that have been done
      to the model, axis change was only doable by hand. 
    - Coordinate axis reworked. X axis now forward
    - This affects thrusters 
    - ```/ros_robot/thrusters/right_thrust_cmd```      float 1 max forward, -1 max backwards.
    - ```/ros_robot/thrusters/left_thrust_cmd```       float 1 max forward, -1 max backwards.
## 25/10/22
  - Reworked model in fusion360 to correct axis problems
    - need to export to URDF and manualy update  
## 24/10/22
  - IMU added, update HZ not specified currently at 20Hz
    - message type sensor_msgs/Imu http://docs.ros.org/en/melodic/api/sensor_msgs/html/msg/Imu.html
    - Topics
      - ``` /sensors/imu/data ``` angular velocity, linear_acceleration
  - GPS added, update HZ not specified currently at 15Hz
    - Center of map lat/long -33.724223 150.679736 corresponds with realworld googlemaps https://goo.gl/maps/9pidXpzy6DaJMaCP9
    - message type sensor_msgs/NavSatFix http://docs.ros.org/en/melodic/api/sensor_msgs/html/msg/NavSatFix.html
    - Topics
      - ``` /sensors/gps/fix ``` Lat/long
  - Magnometer added, update HZ not specified currently at 20Hz
    - Inclination, declination and tesla set iaw https://www.magnetic-declination.com/Australia/Sydney/124736.html
    - Topics
      - ``` /sensors/magnometer ``` 3D vector
## 18/10/22
  - Found bug in simulation that caused hydro dynamics plugin to crash 
    - this bug caused all robot transforms to be moved to 0,0,0 in world frame after running a while
    - Bug caused by collision box from center propeller. Reworked proppeller collision to be cylinder
  - Bug noticed causing a natural frequency in sway direction. Can be augmented by adding linear drag in sway direction

## 17/10/22
  - Equations for Extended kalman filter simulated in Matlab

## 16/10/22
  - found and thrashed bug that caused the terrain in sydney_regatta not to spawn.
      - this removed the neccesity to build the whole VRX_Gazebo package to build sydney_regatta world.
      - problem layed in package.xml Following lines added, to source model file locations in model SDF config
        - ``` <gazebo_ros gazebo_model_path="${prefix}/models"/> ```
        - ``` <gazebo_ros gazebo_media_path="${prefix}"/> ```
  - Testworld Created, that only contains an ocean, robot and some objects.
    - ```roslaunch ros_robot_description test.launch```  
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
