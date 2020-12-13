classdef brake_model < handle
   properties (SetAccess = private)
       count double
       ramp double
       lag double
   end
   methods
      function obj = brake_model(ramp_time, lag_time)  %linear time to ramp to full strength
          obj.ramp = ramp_time;
          obj.lag = lag_time;
      end
      function F_brake = step(obj,Signal,F_user,stiffness,max_depth,dt)
        if(Signal && obj.count >= round(obj.ramp/dt))  %full power phase
            F_brake = -F_user;
            obj.count = obj.count + 1;
        elseif(Signal && obj.count < round(obj.ramp/dt))  %ramp up phase
            if(obj.count > 0)   
               F_brake = -F_user*(obj.count/(obj.ramp/dt));
            else
            F_brake = 0;  
            end
            obj.count = obj.count + 1;
        else
            F_brake = 0;
            obj.count = round(-obj.lag/dt); %can't actuate instantly. lag time 
        end
      end
   end
end


