clear all; close all; clc

%% test lra
t = 0;
dt = 0.00005;
LRA = lra_model(235,0.05,1); 
output = [];

while(t<5)
    output = [output,[LRA.step(true,dt);t]];
    t = t + dt;
end

plot(output(2,:),output(1,:));


%% test piano_model
t = 0;
dt = 0.00005;
Piano = piano_model(0.05,0.5,0.5,0.02);

while(t<1)
    [F_key,Pos_key] = Piano.step(Pos_key,-0.05,F_wire,dt);
    t = t + dt;
end