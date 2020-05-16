
clc;
close all;

% load('ecoli\In.mat');
% load('ecoli\Label.mat');
% 
% load('iris\In.mat');
% load('iris\Label.mat');
% 
load('diagnosis\In.mat');
load('diagnosis\Label.mat');

% load('breastCancer\In.mat');
% load('breastCancer\Label.mat');


Input = normalization(In);              %归一化
Input2 = dimensionRaise(Input);         %升维处理
% CCA(Input2,Label);
VCCA(Input2,Label);










