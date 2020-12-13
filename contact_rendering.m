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
          obj.vel = 0;
          obj.max_vel = max_velocity;
          obj.pos_prev = 0;
          obj.count = 0;
          obj.amplitude = 0;
          obj.dur = duration;
          obj.trigger = false;
      end
      function V_lra = step(obj,Pos_tip,dt)
          obj.vel = (Pos_tip - obj.pos_prev)/dt;
          if(obj.vel < -0.001 && abs(Pos_tip) < obj.thresh)
            obj.amplitude = min(abs(obj.vel),obj.max_vel)/obj.max_vel;
            obj.trigger = true;
          end
          if(obj.trigger && obj.count < obj.dur/dt)
              obj.count = obj.count + 1;
              V_lra = obj.amplitude;
          elseif(obj.count > obj.dur/dt)
              V_lra = 0;
              obj.count = 0;
              obj.trigger = false;
          else
              V_lra = 0;
          end
          obj.pos_prev = Pos_tip;        
      end
   end
end


