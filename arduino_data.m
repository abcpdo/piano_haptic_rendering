classdef arduino_data < handle
   properties (SetAccess = private)
       force_m double
       torque_m double
       f_key double
       status_sol int
       status_lra int
       a int
       b int
       q queue
   end
   % get arduino
   % a = arduino('/dev/cu.usbserial-AL03G1P2','uno')
   methods
      function force_m = motor_force(F_motor_out)
          % function to tell arduino motor force output
          force_m = F_motor_out;
      end
      function status_sol = solenoid_status(a)
          % function to turn arduino solenoid on/off
          if(a == 1)
              %sol on
          else
              %sol off
          end
      end
      function status_lra = LRA_status(b)
          % function to turn arduino LRA  on/off
          if (b == 1)
              %LRA on
          else
              %LRA off
          end
      end
      function f_key = force_sensor()
          %function return force on the key sensor
          %f_key = sensor force
          %return f_key;
      end
   end
end


