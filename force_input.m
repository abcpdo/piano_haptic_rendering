classdef force_input < handle
   properties (SetAccess = private)
      internal_t double
      dt double
      Kp double
      Ki double
      Kd double
      past_errors queue
   end
   methods
      function obj = force_input(kp, ki, kd, dt)
         obj.internal_t = 0;
         obj.dt = dt;
         obj.Kp = kp;
         obj.Ki = ki;
         obj.Kd = kd;
         obj.past_errors = queue(50);
         obj.past_errors.enqueue(0);  %so at least one value is 0 
      end
      function [force,target] = get_force(obj, t, Pos_tip, Vel_tip, input)
%         desired_pos = eval(input);  %target position of finger tip
        desired_pos = sin(5*t)*0.1-0.02;
        
        
        current_error = desired_pos - Pos_tip;  %error
        
        integral = 0;
        if(obj.Ki ~= 0)   %this is inefficient we're trying to not use the I controller
            for i=1:obj.past_errors.Depth
                value = obj.past_errors.dequeue;
                integral = integral + value*obj.dt;
                obj.past_errors.enqueue(value);
            end
            integral = integral/(obj.past_errors.Depth*obj.dt);
            obj.past_errors.enqueue(current_error);
            if(obj.past_errors.Depth > 5)
                obj.past_errors.dequeue;
            end
        end
        
        force = current_error*obj.Kp + integral*obj.Ki - Vel_tip*obj.Kd; %"PI" control
        target = desired_pos;
      end

   end
end






