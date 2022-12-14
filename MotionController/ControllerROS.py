#! /usr/bin/env python

import rospy
import math
from math import sin, asin, cos, acos, tan, atan, atan2, exp, sqrt, radians, pi
from sensor_msgs.msg import Imu
from sensor_msgs.msg import NavSatFix
from std_msgs.msg import Float32
from std_msgs.msg import Bool
from geometry_msgs.msg import Point
from tf.transformations import euler_from_quaternion


# 4. order approximation formula for converting lat deg to meters
def MetersPerLat(latitude): # function of latitude
    #lat = radians(latitude)
    #return 111132.92 - 559.82*cos(2*lat) + 1.175*cos(4*lat) - 0.0023*cos(6*lat)
    return 111320 # approx value for all lat degrees

# 4. order approximation formula for converting long deg to meters
def MetersPerLong(latitude): # function of latitude
    #lat = radians(latitude)
    #return 111412.84*cos(lat) - 93.5*cos(3*lat) + 0.118*cos(5*lat)
    return 40075000 * cos(radians(-33.72))/360 # approx value for specific lat degree

class ControllerClass:
    def __init__(self):
        # Initialze a ros node
        rospy.init_node('controller')
        
        # Create a subscriber to the sensor topics using as a callback function to extract values into local variables
        self.sub_imu = rospy.Subscriber('/sensors/imu/data', Imu, self.clbk_imu, queue_size=1)
        self.sub_gps = rospy.Subscriber('/sensors/gps/fix', NavSatFix, self.clbk_gps, queue_size=1)
        self.sub_auto = rospy.Subscriber('/controller/auto', Bool, self.clbk_auto, queue_size=1)
        self.sub_sp = rospy.Subscriber('/controller/sp', Point, self.clbk_sp, queue_size=1)
        
        # Create a publisher to the command topics
        self.pub_wl = rospy.Publisher('/ros_robot/thrusters/left_thrust_cmd', Float32, queue_size=1)
        self.pub_wr = rospy.Publisher('/ros_robot/thrusters/right_thrust_cmd', Float32, queue_size=1)
        self.pub_wt = rospy.Publisher('/ros_robot/thrusters/Center_thrust_cmd', Float32, queue_size=1)
        self.pub_wt_angle = rospy.Publisher('/ros_robot/thrusters/Center_thrust_angle', Float32, queue_size=1)

        #default values for the variables as a placeholder until the actual sensor values are recieved through from the ros topic
        self.imu_bx, self.imu_by, self.imu_bz, self.imu_bw, self.imu_ax, self.imu_ay, self.imu_az = 0, 0, 0, 0, 0, 0, 0
        self.gps_lat, self.gps_long = 0, 0
        self.sp_lat, self.sp_long = 0.0, 0.0
        self.auto = False
        
        # setup global variables
        self.dt = 0.01          # sampling time
        self.I = 64.2           # angle between horizontal plane and magnetic vector
        self.D = 90             # deviation between magnetic and geographic north
        self.B = 5.7065e-5      # magnetic field strength
        self.g = 9.81           # acceleration due to gravity


    #Callback function for the sensor topics
    def clbk_imu(self, msg):
        self.imu_bx = msg.orientation.x
        self.imu_by = msg.orientation.y
        self.imu_bz = msg.orientation.z
        self.imu_bw = msg.orientation.w
        self.imu_ax = msg.linear_acceleration.x
        self.imu_ay = msg.linear_acceleration.y
        self.imu_az = msg.linear_acceleration.z
        
    def clbk_gps(self, msg): # position from gps is lat/long. Scaled to meter for internal use inside controller
        self.gps_lat = msg.latitude * MetersPerLat(msg.latitude)
        self.gps_long = msg.longitude * MetersPerLong(msg.latitude)
   
    def clbk_auto(self, msg): # bit recived from topic used to set controller in auto / manual mode
        self.auto = msg.data
            
    def clbk_sp(self, msg): # sp is provided in same format (lat/long) as gps. Scaled to meter for internal use inside controller
        self.sp_lat = msg.y * MetersPerLat(msg.y)
        self.sp_long = msg.x * MetersPerLong(msg.y)            

    def FilterGPS(self, lat_prev, long_prev):               # exponential filter
        tau = 0.1                                           # filter time constant
        k = 1 - exp(-self.dt/tau)               
        
        lat = lat_prev + (self.gps_lat - lat_prev)*k        # sensor values are rate limited
        long = long_prev + (self.gps_long - long_prev)*k
        
        return lat, long                                    # output filtered values
    
    def FilterIMU(self, bx_prev, by_prev, bz_prev, bw_prev, ax_prev, ay_prev, az_prev): # exponential filter
        tau = 0.1                                   # filter time constant
        k = 1 - exp(-self.dt/tau)
        
        bx = bx_prev + (self.imu_bx - bx_prev)*k    # sensor values are rate limited
        by = by_prev + (self.imu_by - by_prev)*k
        bz = bz_prev + (self.imu_bz - bz_prev)*k
        bw = bw_prev + (self.imu_bw - bw_prev)*k
        ax = ax_prev + (self.imu_ax - ax_prev)*k
        ay = ay_prev + (self.imu_ay - ay_prev)*k
        az = az_prev + (self.imu_az - az_prev)*k

        return bx, by, bz, bw, ax, ay, az           # output filtered values
    
    
    def ProcessIMU(self,bx, by, bz, bw, ax, ay, az):
        roll, pitch, yaw = euler_from_quaternion([bx, by, bz, bw])  # extract orientation from quarternion
        yaw + self.D*pi/180                                         # add magnetic deviation before output
        
        if yaw > pi:            # make sure yaw is in [-pi,pi]
            yaw = yaw - 2*pi
        elif yaw < -pi:
            yaw = yaw + 2*pi
            
        return yaw
        
    #main loop running the control logic
    def runController(self):
        r = rospy.Rate(100)     # Defines the frequency in Hz in which the following loop will run
        finished = False
        
        # setup
        Kv = 500;       # Gain Kp distance controller
        Dv = 100;       # Gain Kd distance controller
        Iv = 0;         # Gain Ki distance controller
        Ka = 8000;      # Gain Kp angle controller
        Da = 200;       # Gain Kd angle controller
        ptc = 0.1;      # filter time constant
        offset = 0;     # offset set when point tracking
        k = 1-exp(-self.dt/ptc) # precomputed exponential filter constant
        
        # setup controller memory variables
        lat_prev, long_prev = 0, 0
        bx_prev, by_prev, bz_prev, bw_prev, ax_prev, ay_prev,az_prev = 0, 0, 0, 0, 0, 0, 0
        ef_prev, df_prev = 0, 0
        
        while not finished:
            # get new filtered inputs
            lat, long = self.FilterGPS(lat_prev, long_prev)
            lat_prev, long_prev = lat, long                                                                         # store previous values
            bx,by,bz,bw,ax,ay,az = self.FilterIMU(bx_prev, by_prev, bz_prev, bw_prev, ax_prev, ay_prev, az_prev)
            bx_prev, by_prev, bz_prev, bw_prev, ax_prev, ay_prev, az_prev = bx,by,bz,bw,ax,ay,az                    # store previous values
            
            # process IMU values
            theta = self.ProcessIMU(bx, by, bz, bw, ax, ay, az)
            
            # calculate errors
            d = max(sqrt((self.sp_lat-lat)**2+(self.sp_long-long)**2) - offset,0)       # dist is positive
            angle = atan2((self.sp_lat-lat),(self.sp_long-long))                        # angle in [-pi,pi]
            e = (angle-theta) % (2*pi)
            if e > pi:                                                                  # error in [-pi,pi]
                e = e - 2*pi
            elif e < -pi:
                e = e + 2*pi
            
            # determine if vessel shall move forward or reverse
            if d<10 and e>pi/2:
                sign = -1
                e = e-pi
            elif d<10 and e<-pi/2:
                sign = -1
                e = e+pi
            else:
                sign = 1

            # low pass filter derivative for PD controller
            ef = ef_prev + (e-ef_prev)*k        # filter limits rate of change
            de = (ef - ef_prev) / self.dt       # calc derivative
            ef_prev = ef
                        
            df = df_prev + (d-df_prev)*k        # filter limits rate of change
            dd = (df - df_prev) / self.dt       # calc derivative
            df_prev = df

            # calculate controller outputs
            ua = max(min(Ka*ef + Da*de,6000),-6000)
            uv = max(min((Kv*df + Dv*dd)*sign,5000),-5000)
            
            # change control outputs based of distance to target
            if d > 0.5:
                wl = uv * (1 - sign*ua/8000)
                wr = uv * (1 + sign*ua/8000)
                wt = ua
            else:
                wl = uv * (1 - sign*ua/2000)*10
                wr = uv * (1 + sign*ua/2000)*10
                wt = 0

            # Publish msg (scaled and inverted to [-1,1])
            self.pub_wl.publish(max(min(wl/5000,1),-1))
            self.pub_wr.publish(max(min(wr/5000,1),-1))
            self.pub_wt.publish(max(min(wt/6000,1),-1))
            
            # sleeps for the time needed to ensure that the loop will be executed with the previously defined frequency
            r.sleep()

if __name__ == '__main__':
    nav = ControllerClass()
    nav.runController()
