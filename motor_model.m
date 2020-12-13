classdef motor_model < handle
   properties (SetAccess = private)
      A1 double
      A2 double
      A3 double
      B1 double
      B2 double
      B3 double
   end
   methods
      function obj = motor_model(P,I,D)
          
      end
      function F_motor_out = step(obj,F_motor,F_in,dt)
          F_motor_out = F_in;
      end
   end
end


