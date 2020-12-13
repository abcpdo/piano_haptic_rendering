clear all; close all; clc

A = rand(6);
B = rand(6);

plot(A,B);
linkdata on

for i = 1:100
    A = rand(6);
    B = rand(6);
    refreshdata
    pause(0.1);
end