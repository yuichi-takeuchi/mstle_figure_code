clc
clear
 set(0,'DefaultFigureVisible','on')
x1 = normrnd(5,1,100,1);
x2 = normrnd(6,1,100,1);
x3 = normrnd(7,1,100,1);
x4 = normrnd(8,1,100,1);
figure;
boxplot([x1,x2,x3,x4]);
% Change the boxplot color from blue to green
a = get(get(gca,'children'),'children');   % Get the handles of all the objects
t = get(a,'tag');   % List the names of all the objects 
box1 = a(25);
set(box1, 'Color', 'g');   % Set the color of the first box to green