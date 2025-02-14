close all; clc
% This is the main file for the simulation

% Set constants
load('G.mat');
key_travel = 0.02; %m how far the key can depress 
finger_mass = 0.1; %kg  guessed mass of finger 

piano_mk = 0.06; %kg
piano_mh = 0.01; %kg
piano_k = 10; %N/m
piano_b = 5; %Ns/m
piano_l1 = 0.06; %m
piano_l2 = 0.04; %m
piano_l3 = 0.01; %m
piano_l4 = 0.04; %m
piano_l5 = 0.025; %m


lra_freq = 230; %hz
lra_duration = 0.02; %s
lra_amplitude = 0.05; %N
max_contact_velocity = 0.1; %m/s
brake_ramp = 0.0001;
brake_delay = 0.001;
brake_threshold = 0.1; %N
contact_stiffness = 1000; %N/m
tension_force = 0.01; %N
dt = 0.00005; % time step at 20khz
time = 10; % seconds
duration = time/dt;  %get number of loop cycles
ip = getip;

% Create objects from each model class
Finger = finger_model(finger_mass,0,0,0);
Piano = piano_model(piano_mk,piano_mh,piano_k, piano_b, piano_l1, piano_l2, piano_l3, piano_l4, piano_l5, contact_stiffness,key_travel);
LRA = lra_model(lra_freq,lra_amplitude,0.002);
Contact = contact_rendering(0.0005,max_contact_velocity,lra_duration);
Motor = motor_model(9,9,9);
Brake = brake_model(brake_ramp,brake_delay);
User = force_input(25,0,1.9,dt);  %P,I,D
Keybed = hits_keybed(brake_threshold);
Joy = vrjoystick(1);
Client = tcpclient(ip,1234);

% Initialize all variables
target_pos = 0; %this is the input position
F_user = 0;
F_tip = 0;
Pos_tip = 0;
Vel_tip = 0;
Pos_key = 0;
F_key = 0;
F_tension = 0;
F_out = 0;
F_motor = 0;
V_lra = 0;  %signal ranging from 0 to 1
Signal_brake = false;   %signal from 0 to 1
F_wire = 0;
F_lra = 0;
t = 0.0;
             %[t; F_user; F_key; Pos_key; F_out; V_lra; F_lra; F_motor; F_brake; F_wire; Pos_tip; Pos_target; Vel_tip; F_tip; Signal_brake];
Selection =   [1     1      0      1       1      0      0        1        1        1        1        1          1       1          0     ];
Output = zeros(nnz(Selection),duration);   %plotting vectors
ColorOrder  = lines(size(Output,1));

tic  
init_time = clock;
for i = 1:duration 
    % New input for current step
    target_pos = -axis(Joy,2)*0.05+0.001; %target position from joystick: 3cm above and below
    [F_user,Pos_target] = User.get_force(t,Pos_tip,Vel_tip,target_pos);
 
    % Virtual rendering previous step
    Signal_brake = Keybed.brake_state(Pos_key,Pos_tip,F_tip,F_user,key_travel,piano_mk,piano_mh,piano_k, piano_b, piano_l1, piano_l2, piano_l3, piano_l4, piano_l5,dt);
    [F_key, Pos_key] = Piano.step(Pos_tip,Signal_brake,dt);
    F_tension = tensioner(Pos_tip,tension_force);
    F_out = F_key + F_tension;
    F_out = ternary(Signal_brake,0,F_out);   %if brake, 0. else, F_out
    F_out = min(F_out,2.5);     %maximum force generated by the motor
    F_out = max(F_out,0);      %key can't depress itself
    V_lra = Contact.step(Vel_tip,Pos_tip,z,dt);

    % Physical componennts previous step
    F_lra = 0; %LRA.step(V_lra,dt);
    F_motor = Motor.step(F_motor,F_out,dt);
    F_brake = Brake.step(Signal_brake,F_user,dt);
    F_wire = ternary(Signal_brake,F_brake,F_motor);
    
    
    % Finger current step
    [Pos_tip,Vel_tip,F_tip] = Finger.step(F_wire, F_lra, F_user,Signal_brake,dt);
    
    % Increment time
    t = t + dt;
    
    % Collect data
    Output_i = [t; F_user; F_key; Pos_key; F_out; V_lra; F_lra; F_motor; F_brake; F_wire; Pos_tip; Pos_target; Vel_tip; F_tip; Signal_brake];
    Output_i = Output_i(Selection == 1,:);
    Output(:,i) = Output_i;
    
    %Plot sliding window of 1 seconds
%     if(i > 1/dt)   
%         if(mod(i,1000) == 0)
%             hold off
%             for j = 1:size(Output,1)-1
%                 plot(Output(1,i+1-1/dt:i), Output(j+1,i+1-1/dt:i), 'Color', ColorOrder(j, :));    
%                 hold on
%             end
%         end
%     end

    %Time control, each cycle waits until real time has caught up
    curr_time = clock;
    if(curr_time(5) ~= init_time(5))     
       curr_time(6) = curr_time(6) + 60; 
    end
    while(curr_time(6) - init_time(6) < t)
        pause(0.0001);
        curr_time = clock;
        if(curr_time(5) ~= init_time(5))
           curr_time(6) = curr_time(6) + 60; 
        end
    end
    if(mod(i,750) == 0)
        writeline(Client,string(Pos_key)+' '+string(Pos_tip));
    end
end
toc

%Plot whole plot
hold off
for j = 1:size(Output,1)-1
    plot(Output(1,:), Output(j+1,:), 'Color', ColorOrder(j, :));    
    hold on
end

%Label the chart
labels = {'F_{user}';'F_{key}';'Pos_{key}';'F_{out}';'V_{lra}';'F_{lra}';'F_{motor}';'F_{brake}';'F_{wire}';'Pos_{tip}';'Pos_{target}';'Vel_{tip}';'F_{tip}';'Signal_{brake}'};
labels = labels(Selection(2:end) == 1,:);
legend(labels);
