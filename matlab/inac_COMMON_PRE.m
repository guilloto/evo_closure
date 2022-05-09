%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Degradation des contraintes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fire, transition] = COMMON_PRE(transition)
global PN
global global_info

% Puits
if rand< global_info.m && sum(PN.X)~=0 % renvoie 1 dans m% des cas   % m taux de degradation  

% Tirer un jeton à éliminer
% tok = [PN.global_places.tokens] ;
% idx_tok = randsample(find(tok>0),1);
% tok(1,idx_tok) = tok(1,idx_tok)-1 ; % Perdre des jetons

idx_tok = randsample(find(PN.X>0),1);

PN.X(idx_tok) = PN.X(idx_tok)-1 ;


% PN.tokens = tok ;
% PN.global_places.tokens = tok ;
% PN = setfield(PN,'tokens',tok) ;
% PN = setfield(PN,'global_places','tokens',tok) ;

% Update list of enabled trans after token removal?     
Ts = PN.No_of_transitions; % number of tansitions
for i = 1:Ts, PN.Enabled_Transitions(i) = enabled_transition(i); end

% fire = enabled_transition(transition.name) ; %%% marche pas
fire = is_enabled(transition.name) ; %%%  

else
Ts = PN.No_of_transitions; % number of tansitions 
for i = 1:Ts, PN.Enabled_Transitions(i) = enabled_transition(i); end % a revoir, ne devrait pas être necessaire
fire = is_enabled(transition.name) ; %%%  
end
  
%             % Update list of enabled trans after token removal
%             for j = 1:No_of_enabledTrans %check events one by one 
%                 t2 = set_of_ordered_enabledTrans(j); 
%                 PN.Enabled_Transitions(t2) = enabled_transition(t2); % recheck 
%             end            
       