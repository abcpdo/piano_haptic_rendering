classdef hits_keybed < handle
   properties (SetAccess = private)
       state logical
       prev_state logical
       prev_pos double
       prev_force double
       threshold double
   end
   methods
       function obj = hits_keybed(thresh)
           obj.state = false;
           obj.prev_pos = 0;
           obj.prev_force = 0;
           obj.threshold = thresh;
       end
       function Signal = brake_state(obj, Pos_key,Pos_tip,F_tip,F_user,max_depth,piano_mk,piano_mh,piano_k, piano_b, piano_l1, piano_l2, piano_l3, piano_l4, piano_l5,dt)    
           if(obj.state == false)   %if brake is off
               if(Pos_tip <= -max_depth && (Pos_tip - obj.prev_pos)/dt < -0.001)
    
                    obj.state = true;
               end
           else    %if brake is on
               if(F_user > -9.81*piano_mk*(piano_l5/piano_l1) -9.81*piano_mh*(piano_l4/piano_l3)*(piano_l2/piano_l1) +obj.threshold)
                   obj.state = false;
               end
           end
           obj.prev_force = F_user;
           obj.prev_pos = Pos_tip;
           Signal = obj.state;
       end
   end
end