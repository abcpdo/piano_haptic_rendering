classdef piano_model < handle
   properties (SetAccess = private)
      pos double
      vel double
      accl double
      mass double 
      stiffness double
      contact_stiffness double
      damping double
      max_depth double
   end
   methods
      function obj = piano_model(m,k,k_user,b,d)
          obj.pos = 0;
          obj.vel = 0;
          obj.accl = 0;
          obj.mass = m;
          obj.stiffness = k;
          obj.contact_stiffness = k_user;
          obj.damping = b;
          obj.max_depth = d;
      end
      function [F_key,Pos_key] = step(obj,Pos_tip,Brake_signal,dt)
        
        %update using previous accl  
        obj.vel = obj.vel + obj.accl*dt;
        obj.pos = obj.pos + obj.vel*dt;
        internal_sum = -obj.pos*obj.stiffness - obj.vel*obj.damping;  

        
        if(Pos_tip <= obj.pos)   %if fingertip is below key  
           force_contact = obj.contact_stiffness*(Pos_tip - obj.pos); 
           if(~Brake_signal)
               F_key = -obj.pos*obj.stiffness;
           else
               F_key = 0;
           end
           obj.accl = (force_contact+internal_sum)/obj.mass;
        else                     %if tip is above key
           if(Pos_tip < obj.pos + 0.001 && ~Brake_signal)        %give a bit to leeway to avoid oscilations 
               F_key = -obj.pos*obj.stiffness;
           else
               F_key = 0;
           end
           obj.accl = internal_sum/obj.mass;
        end    

%         if(obj.pos < -obj.max_depth)   %if bottomed out
%            obj.bottomed();
        if(obj.pos > 0)        %if topped out
           obj.topped();
        end
        Pos_key = obj.pos;
      end
      
      function topped(obj)
          obj.pos = 0;
          obj.vel = 0;
          obj.accl = 0;
      end
      
      function bottomed(obj)
          obj.pos = -obj.max_depth;
          obj.vel = 0;
          obj.accl = obj.max_depth*obj.stiffness/obj.mass;
      end
   end
end
