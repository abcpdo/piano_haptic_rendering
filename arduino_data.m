classdef arduino_data < handle
   properties (SetAccess = private)
   	force_m double
    torque_m double
    fsr_reading double
    force double
    status_sol int
    status_lra int
    pwmSol int
    p double
    T double
    y int
    q queue
    a arduino
    s serial
	pwmPin1 int  % motor
	dirPin1 int 
	pwmPin2 int  % solenoid
	dirPin2 int  
	aPinFSR int  % FSR connected to A0 port 
	rh double
	rp double
	rs double
	xh double
   end

	configurePin(a,pwmPin2,'DigitalOutput');
	configurePin(a,dirPin2,'DigitalOutput');
   methods
   	function obj = arduino_data(pwmSol,motor_torque)
	   % get arduino
  	 	a = arduino('/dev/cu.usbserial-AL03G1P2','uno')
		s = serial('/dev/cu.usbserial-AL03G1P2','uno')
		obj.p = pwmSol;
		obj.T = F_motor_out;
        obj.pwmPin1 = 5;
        obj.dirPin1 = 8;
        obj.pwmPin2 = 6; % solenoid
        obj.dirPin2 = 7; 
        obj.aPinFSR = 0; % FSR connected to A0 port 
        rh = 0.8654;	//[m]
    	rp = 0.0486;   //[m]
    	rs = 0.7443;   //[m]
	
	fopen(s);
    end
    function fsr_reading = force_sensor()
         %function return force on the key sensor
        fsr_reading = readAnalogPin(aPinFSR);
    end
    function xh = handle_position(obj)
	% get position from serial
	xh = fscanf(s);
	end
    function solenoidOn(obj) % 225 - on, 0 - off
          % function to turn solenoid on
		writeDigitalPin(a,dirPin2,obj.p);
    end	
  	function solenoidOff(obj)
	% function to turn solenoid off
    		writeDigitalPin(a,dirPin2,0);
	end

%      function status_lra = LRA_status(y)
%          % function to turn arduino LRA  on/off
%          if (y == 1)
%              %LRA on
%          else
%              %LRA off
%          end
%      	end
    function motorTorque(obj)
          % function to control the motor
	  % send force to serial
	  write(s,obj.T,"double");
    end
   end
end


