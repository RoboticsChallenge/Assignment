# Vessel Dynamical Model

### Description
The dynamical model for the vessel has been created based on force and torque equations.
 - The **input** into the system is back thrusters `wl` and `wr` [0-5000rpm] and side thruster `wt` [0-6000rpm]
 - The **output** from the dynamical system is `x`, `y`, `theta` in reference to the world coordinate frame

<img src="https://user-images.githubusercontent.com/108756538/192135453-7e650e00-44de-40d3-a451-cc342bc07211.png" width="400" align="center">

<img src="https://user-images.githubusercontent.com/108756538/192135274-998c62ff-3ff1-417c-8120-dc9e8a0b9aaa.png" width="800">

<img src="https://user-images.githubusercontent.com/108756538/192136240-7d41045b-eddc-4a42-a53d-c5dba972e868.png" width="800">

The dynamics ripple through the system: **Rpm** -> **Thrust** -> **Acceleration** -> **Velocity** -> **Position**

#### Model key take aways
 - Thruster can operate in forward and backward direction
   - Back thrusters: $\pm5000$ rpm
   - Side thruster:  $\pm6000$ rpm
 - Motion is not instantanious. It will take time to build up acceleration and velocity
   - The vessel will coast if propulsion is instantly dropped to zero until friction has reduced the velocity to zero
   - Will coast $\approx 1m$ when vessel is at max speed of $5 m/s$
 - Maximum forward velocity of $5 m/s$ is obtained with back thrusters at max rpm
 - The model is non-linear in terms of rpm to velocity
<img src="https://user-images.githubusercontent.com/108756538/192136490-fce1ee96-94d2-4d1e-9185-7fb032998748.png" width="400">
image show forward velocity when back thruster are linearly increased to $5000rpm$
<br><br>

 - Rotation by adjusting ratio of left and right thruster or by side thruster
 - The efficiency of the side thruster is reduced with increasing forward velocity (limiter in simulink)
 <img src="https://user-images.githubusercontent.com/108756538/192135179-4e6580bc-3bea-424f-8e4c-ede20508731c.jpg" width="400">
image show amount of sidewards thrust $[100-10\%]$ when forward velocity is increased from $[0-5m/s]$



## Innstallation instructions
- [ ] Download vessel.m and sl_vessel.slx to local machine
- [ ] Run vessel.m so that variables are placed in the workspace
- [ ] Run simulink model
- [ ] Uncomment controller to enable it

<img src="https://user-images.githubusercontent.com/108756538/192135787-8635dbdb-6488-4f90-b296-4aca7e3a15d4.png" width="200">
