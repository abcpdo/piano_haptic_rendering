classdef contact_rendering < handle
   properties (SetAccess = private)
      pos_prev double
      thresh double
      vel double
      max_vel double
      amplitude double
      count double
      dur double
      trigger logical
   end
   methods
      function obj = contact_rendering(threshold,max_velocity, duration)
          obj.thresh = threshold; 
          obj.max_vel = max_velocity;
          obj.count = 0;
          obj.amplitude = 0;
          obj.dur = duration;
          obj.trigger = false;
      end
      function V_lra = step(obj,Vel_tip,Pos_tip,dt)
          if(~obj.trigger && Vel_tip < -0.001 && abs(Pos_tip) < obj.thresh)  
            obj.trigger = true;
            obj.amplitude = abs(min(abs(obj.vel),obj.max_vel)/obj.max_vel);
          end
          if(obj.trigger && obj.count <= obj.dur/dt)
              obj.count = obj.count + 1;
              V_lra = 0; %obj.amplitude;    ????????????? MYSTERY
          elseif(obj.count > obj.dur/dt)  %exceeded active duration
              V_lra = 0;
              obj.count = 0;
              obj.trigger = false;
          else
              V_lra = 0;
          end     
      end
   end
end


