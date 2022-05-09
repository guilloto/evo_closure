function [] = COMMON_POST(transition)
% COMMON_POST file codes the post firing actions.

% Here, right after firing, the fired transition 
% set the value of semaphore to the other 
% transition so that the other one fires next

global global_info

if strcmp(transition.name, 'tX1'), 
    global_info.semafor = 2; % t1 releases semafor to t2
elseif strcmp(transition.name, 'tX2'), % transition.name 't2'
    global_info.semafor = 1; % t2 releases semafor to t1
else
%    disp('transition name is neither "tX1" nor "tX2"?);
%    disp('This is not possible'); 
%    error('something wrong in COMMON_POST'); 
end