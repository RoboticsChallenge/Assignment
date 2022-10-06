# Robotics Challenge

### Description
Robotics assignment, western university of applied science.

## Next scheduled meeting:
    
    Tirsdag 11/10-22 14:00 Discord
    Torsdag 6/10-22 11:00 Zoom PDR breif
    ~Torsdag 6/10-22 11:00 Zoom PDR breif~
    Tirsdag 4/10-22 14:00 Discord
    Tirsdag 27/9-22 12:00 Discord
    Tirsdag 20/9-22 14:00 oppstart
    

## Overarching project tasks
- [x] Publish tasks.
- [ ] Interface topology (All)
- [x] Kinematic modeling (Mathias)
    - [x] Kinematic model
    - [x] Model Simulation Matlab
- [ ] Motion algorithm (Mathias)
- [ ] Sensor package (Fredrik F.)
- [x] Make Model(Fredrik F.)
    - [x] Make 3D model of assignment
    - [ ] Model simulation Gazebo\Rviz
- [ ] Robot arm (Fredrik, Lars, Sander)
- [ ] Preplaned Navigation Planning (...)

## Project Tasks
### Develop the forward kinematics of your robotic solution, in Matlab (not Toolbox) or by hand: 
##### For the robot arm(s): 
- [ ] Develop the table of DH parameters 
- [ ] Develop the transformation mapping end-effector to base (for the first 4 
joints only) 
##### For the mobile robot platform(s): 
- [x] Draw a model of the mobile robot with the necessary variables defined 
(see Fig. 4.1 in Corke for inspiration) 
- [x] Develop the kinematic equations of motion for the mobile robot 
- [x] Discuss whether the mobile robot is holonomic or non-holonomic 
##### For the robotic system in general: 
- [ ] Develop the transformation from the chosen sensor system to the 
relevant coordinate system on the robot (world, end-effector, mobile 
robot, etc) 

### Model your robot kinematics with Peter Corke's Robotics Toolbox in Matlab: 
##### For the robot arm(s): 
- [ ] Demonstrate equivalence of the forward kinematic solution obtained 
previously in Matlab (not Toolbox) or by hand 
- [ ] Develop the differential kinematics (i.e. relating joint and Cartesian 
velocities), and demonstrate how it could be used 
- [ ] Develop the inverse kinematics, and demonstrate how it could be used 
- [ ] Demonstrate example motion planning, on a task relevant to your robot 
design challenge (or similar) 
##### For the mobile robot platform(s): 
- [ ] Determine suitable controller(s) to control the mobile robot for your 
chosen challenge 
- [x] Implement the kinematic model and the controller(s) in Matlab(/Simulink) 
##### For the robotic system in general: 
- [ ] Demonstrate using the sensory system to command the robot, 
according to the task chosen. That is, show the calculations necessary to 
make the sensory data (e.g. an apple detected at an arbitrary location 
from a static 3D camera) useful to the robot (e.g. calculate the joint 
angles to put the tool point of the end-effector at the apple’s location). 

### Simulate the kinematics of your robot in Matlab: 
##### For the robot arm(s), depending on robot design challenge either: 
- [ ] Use motion planning to move the robot end-effector through the 
required positions/orientations for the task chosen, or 
- [ ] Use differential kinematics to move the end-effector using velocity 
commands according to the task chosen 
##### For the mobile robot platform(s): 
- [x] Simulate your chosen challenge, and discuss the simulation results in 
terms of chosen control strategy and performance 
- [x] Discuss and implement a navigation strategy for the mobile robot for 
your challenge 
- [x] Discuss how you would implement a localization strategy for the mobile 
robot for your challenge 

### Connect the Matlab code to ROS and simulate the physical robot in Gazebo 
##### For the complete system: 
- [x] Model your complete robot system using URDF and visualize the robot in Gazebo
- [x] Your robot arm(s) mounted on your mobile platform 
- [ ] Your mobile platform, with wheels, sensors etc 
##### For the robot arm(s): 
- [ ] Demonstrate controlling your robot arm(s) in Gazebo over ROS from Matlab, by following along a trajectory 
calculated in Matlab, or controlled using your differential kinematics implemented in Matlab. 
##### For the mobile robot(s): 
- [ ] Demonstrate controlling your mobile robot platform in 
Gazebo over ROS from Matlab. 
### Optional
- [ ] Control a physical UR, Turtlebot, or other robot using coordinates 
calculated with your Matlab code through ROS. 
