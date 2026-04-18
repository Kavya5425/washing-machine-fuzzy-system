clc;
clear;
close all;

% Create FIS
fis = mamfis('Name','WashingMachine');

%% Input 1: Dirt Level
fis = addInput(fis,[0 10],'Name','Dirt');
fis = addMF(fis,'Dirt','trimf',[0 0 5],'Name','Low');
fis = addMF(fis,'Dirt','trimf',[2 5 8],'Name','Medium');
fis = addMF(fis,'Dirt','trimf',[5 10 10],'Name','High');

%% Input 2: Load Size
fis = addInput(fis,[0 10],'Name','Load');
fis = addMF(fis,'Load','trimf',[0 0 5],'Name','Small');
fis = addMF(fis,'Load','trimf',[2 5 8],'Name','Medium');
fis = addMF(fis,'Load','trimf',[5 10 10],'Name','Large');

%% Output: Wash Time
fis = addOutput(fis,[0 60],'Name','Time');
fis = addMF(fis,'Time','trimf',[0 0 20],'Name','Short');
fis = addMF(fis,'Time','trimf',[15 30 45],'Name','Medium');
fis = addMF(fis,'Time','trimf',[40 60 60],'Name','Long');

%% Rules
rules = [
    1 1 1 1 1;  % Low, Small -> Short
    1 2 1 1 1;  % Low, Medium -> Short
    1 3 2 1 1;  % Low, Large -> Medium
    2 1 2 1 1;  % Medium, Small -> Medium
    2 2 2 1 1;  % Medium, Medium -> Medium
    2 3 3 1 1;  % Medium, Large -> Long
    3 1 2 1 1;  % High, Small -> Medium
    3 2 3 1 1;  % High, Medium -> Long
    3 3 3 1 1;  % High, Large -> Long
];

fis = addRule(fis,rules);

%% View System
figure;
plotmf(fis,'input',1); % Dirt MF
figure;
plotmf(fis,'input',2); % Load MF
figure;
plotmf(fis,'output',1); % Time MF

%% Rule Viewer
ruleview(fis)

%% Test Example
input = [7 8]; % Dirt=7, Load=8
output = evalfis(fis,input)

disp(['Washing Time: ', num2str(output), ' minutes']);
