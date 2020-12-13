classdef finger_model < handle
   properties (SetAccess = private)
      pos double
      vel double
      accl double
      mass double
   end
   methods
      function obj = finger_model(m, x, v, a)
          obj.pos = x;
          obj.vel = v;
          obj.accl = a;
          obj.mass = m;
      end
      function [Pos_tip,Vel_tip,F_tip] = step(obj,F_wire,F_lra,F_user,Brake_signal,dt)
          F_tip = F_wire + F_lra + F_user;
          obj.accl = F_tip/obj.mass;       
          obj.vel = obj.vel + obj.accl*dt;
          if(Brake_signal)  %if it is bottomed out the finger stops moving. 
              obj.vel = 0;
          end
          obj.pos = obj.pos + obj.vel*dt;
          Pos_tip = obj.pos;
          Vel_tip = obj.vel;
      end
   end
end


