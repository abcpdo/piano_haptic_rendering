clear all; close all; clc

recObj = audiorecorder;
disp('Start recording');
recordblocking(recObj,1);
pause(1);
play(recObj);
