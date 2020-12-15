classdef brake_model < handle
   properties (SetAccess = private)
       count double
       ramp double
       lag double
       prev_signal logical
   end
   methods
      function obj = brake_model(ramp_time, lag_time)  %linear time to ramp to full strength
          obj.ramp = ramp_time;
          obj.lag = lag_time;
          obj.prev_signal = false;
          obj.count = 0;
      end
      function F_brake = step(obj,Signal,F_user,dt)
        if(Signal && obj.count >= round(obj.ramp/dt))  %full power phase
            F_brake = -F_user;
            obj.count = obj.count + 1;
            obj.prev_signal = Signal;
        elseif(Signal && obj.count < round(obj.ramp/dt))  %ramp up phase
            if(obj.count > 0)   
               F_brake = -F_user*(obj.count/(obj.ramp/dt));
            else
            F_brake = 0;  
            end
            obj.count = obj.count + 1;
            obj.prev_signal = Signal;
        else
            F_brake = 0;
            if(obj.prev_signal)
                obj.count = round(-obj.lag/dt); %can't actuate instantly. lag time 
            end
            obj.prev_signal = Signal;
        end
      end
   end
end


