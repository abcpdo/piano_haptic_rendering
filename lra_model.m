classdef lra_model < handle
   properties (SetAccess = private)
       count double
       freq double
       dur double
       a double
   end
   methods
      function obj = lra_model(frequency,amplitude,duration)
          obj.count = 0;
          obj.freq = frequency;
          obj.a = amplitude;
          obj.dur = duration;
      end
      function F_lra = step(obj,V_lra,dt) 
          if(V_lra > 0)
              if(obj.count > 0)
                F_lra = V_lra*obj.a*sin(obj.count*dt*2*pi*obj.freq);
                disp(F_lra);
              else
                F_lra = 0; 
              end
              obj.count = obj.count + 1;
          else
              F_lra = 0;
              obj.count = round(-obj.dur/dt);  %adds a interval before it can ramp up
          end 
          
      end
   end
end


