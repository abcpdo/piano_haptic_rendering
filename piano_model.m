classdef piano_model < handle
   properties (SetAccess = private)
      pos_k double
      vel_k double
      accl_k double
      mass_k double 
      pos_h double
      vel_h double
      accl_h double
      mass_h double 
      l1 double;
      l2 double;
      l3 double;
      l4 double; 
      l5 double;
      stiffness double
      contact_stiffness double
      damping double
      max_depth double
   end
   methods
      function obj = piano_model(piano_mk,piano_mh,piano_k, piano_b, piano_l1, piano_l2, piano_l3, piano_l4, piano_l5, contact_stiffness,key_travel)
          obj.pos_k = 0;
          obj.vel_k = 0;
          obj.accl_k = 0;
          obj.mass_k = piano_mk;
          obj.pos_h = 0;
          obj.vel_h = 0;
          obj.accl_h = 0;
          obj.mass_h = piano_mh;
          obj.l1 = piano_l1;
          obj.l2 = piano_l2;
          obj.l3 = piano_l3;
          obj.l4 = piano_l4;
          obj.l5 = piano_l5;
          obj.stiffness = piano_k;
          obj.contact_stiffness = contact_stiffness;
          obj.damping = piano_b;
          obj.max_depth = key_travel;
      end
      function [F_key,Pos_key] = step(obj,Pos_tip,Brake_signal,dt)
        
        %update pos using previous accl  
        obj.vel_k = obj.vel_k + obj.accl_k*dt;
        obj.pos_k = obj.pos_k + obj.vel_k*dt;
        obj.vel_h = obj.vel_h + obj.accl_h*dt;
        obj.pos_h = obj.pos_h + obj.vel_h*dt;
        Pos_key = -obj.pos_k*(obj.l1/obj.l5);
        
        f_k = obj.stiffness*(obj.pos_k*(obj.l2/obj.l5)-obj.pos_h*(obj.l3/obj.l4));  %as seen by m_h
        f_b = obj.damping*(-obj.vel_k);
        
        
        if(Pos_tip <= Pos_key)   %if fingertip is below key  
           force_contact = obj.contact_stiffness*(Pos_tip - Pos_key); 
           if(~Brake_signal)
               F_key = -f_b*(obj.l5/obj.l1)+f_k*(obj.l2/obj.l1);
           else
               F_key = 0;
           end
           obj.accl_h = -9.81 + f_k*(obj.l3/obj.l4)/obj.mass_h;  
           obj.accl_k = -9.81 + (-force_contact*(obj.l1/obj.l5) +f_b -f_k*(obj.l2/obj.l5))/obj.mass_k;
        else                     %if tip is above key, we do not apply a force at the tip
           if(Pos_tip < Pos_key + 0.001 && ~Brake_signal)        %give a bit to leeway to avoid oscilations 
               F_key = -f_k*(obj.l2/obj.l1);
           else
               F_key = 0;
           end
           
           obj.accl_h = -9.81 + f_k*(obj.l3/obj.l4)/obj.mass_h;  
           obj.accl_k = -9.81 + (f_b -f_k*(obj.l2/obj.l5))/obj.mass_k;
        end    

%         if(obj.pos < -obj.max_depth)   %if bottomed out
%            obj.bottomed();
        if(obj.pos_k < 0)        %if topped out
           obj.topped();
        end
      end
      
      function topped(obj)
          obj.pos_k = 0;
          obj.vel_k = 0;
          obj.accl_k = 0;
          obj.pos_h = 0;
          obj.vel_h = 0;
          obj.accl_h = 0;
      end
   end
end
