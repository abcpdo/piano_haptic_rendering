classdef arduino_data < handle
   properties (SetAccess = private)
   	force_m double
    torque_m double
    fsr_reading double
    force double
    p double
    T double
    q queue
    a arduino
    %s serial
    s string
	pwmPin1 string  % motor
	dirPin1 string 
	pwmPin2 string  % solenoid
	dirPin2 string  
	aPinFSR string  % FSR connected to A0 port 
	rh double
	rp double
	rs double
	xh double
    baud double
   end


   methods
   	function obj = arduino_data(pwmSol,Torque)
	   % get arduino
        % baud = 9600;
  	 	obj.a = arduino('/dev/cu.usbserial-AL03G1P2','Uno');
        ports = serialportlist();
		obj.s = device(obj.a,'SerialPort',ports(3));
        obj.pwmPin1 = 'D5';
        obj.dirPin1 = 'D8';
        obj.pwmPin2 = 'D6'; % solenoid
        obj.dirPin2 = 'D7'; 
        obj.aPinFSR = 'A0'; % FSR connected to A0 port 
        obj.p = pwmSol;
        obj.T = Torque;
	
		configurePin(obj.a,obj.pwmPin2,'DigitalOutput');
		configurePin(obj.a,obj.dirPin2,'DigitalOutput');
	fopen(obj.s);
    end
    function fsr_reading = force_sensor()
         %function return force on the key sensor
        fsr_reading = readAnalogPin(obj.aPinFSR);
    end
    function xh = handle_position()
	% get position from serial
	xh = fscanf(obj.s); %fread()?
	end
    function solenoidOn(obj) % 225 - on, 0 - off
          % function to turn solenoid on
		writeDigitalPin(obj.a,obj.dirPin2,obj.p);
    end	
  	function solenoidOff(obj)
	% function to turn solenoid off
    		writeDigitalPin(obj.a,obj.dirPin2,0);
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
	  write(obj.s,obj.T,"double");
    end
    fend(s);
   end
end

