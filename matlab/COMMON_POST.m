%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Degradation des contraintes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = COMMON_POST(transition)
global PN
global global_info

Ais = global_info.reseau.Ai ; %condis de possibilités
% Ao = global_info.reseau.Ao ;
% clone = global_info.reseau.clone ;
% process = Ao - clone ; % process
trans_name = {PN.global_transitions.name};  


% Determiner les places reliées à la transition (avec places reliées par condi de possibilités)
trans = find(strcmpi({transition.name},trans_name)); % trouver emplacement de la transition dans Ai

plc_idx = find(Ais(trans,:)==1) ; % index des places reliées 
X_plc = PN.X(plc_idx) ; % jetons dans les places reliées à la transition en cours


% if rand< global_info.m && sum(PN.X(idx_plc)) >0 % renvoie 1 dans m% des cas  % m taux de degradation  
if sum(X_plc) >0 %  s'il y a des jetons dans les places 

 nv = binornd(sum(X_plc),global_info.m) ; % n = nombre de variation max = nombre de jetons dispo. p = taux de variation
    % Tirer emplacement des variations
 % without replacement

 
     for i = 1:nv
          test_pre = PN.X;
          idx_tok = datasample(find(PN.X(plc_idx)>0),1); % permet le remplacement seulement s'il est possible (plus d'un jeton de dispo sur une place)
          idx_tok = plc_idx(idx_tok);
          PN.X(idx_tok) = PN.X(idx_tok)-1;
          
          if sum(PN.X<0)>0
            print("erreur : nb de jetons negatif")
          end
          
     end
     
     

    




% Tirer un jeton à éliminer
% tok = [PN.global_places.tokens] ;
% idx_tok = randsample(find(tok>0),1);
% tok(1,idx_tok) = tok(1,idx_tok)-1 ; % Perdre des jetons

% idx_tok = randsample(find(PN.X>0),1);
% PN.X(idx_tok) = PN.X(idx_tok)-1 ;


% PN.tokens = tok ;
% PN.global_places.tokens = tok ;
% PN = setfield(PN,'tokens',tok) ;
% PN = setfield(PN,'global_places','tokens',tok) ;
% 
% % Update list of enabled trans after token removal?     
% Ts = PN.No_of_transitions; % number of tansitions
% for i = 1:Ts, PN.Enabled_Transitions(i) = enabled_transition(i); end
% 
% % fire = enabled_transition(transition.name) ; %%% marche pas
% fire = is_enabled(transition.name) ; %%%  
% 
% else
% Ts = PN.No_of_transitions; % number of tansitions 
% for i = 1:Ts, PN.Enabled_Transitions(i) = enabled_transition(i); end % a revoir, ne devrait pas être necessaire
% fire = is_enabled(transition.name) ; %%%  
end
  
%             % Update list of enabled trans after token removal
%             for j = 1:No_of_enabledTrans %check events one by one 
%                 t2 = set_of_ordered_enabledTrans(j); 
%                 PN.Enabled_Transitions(t2) = enabled_transition(t2); % recheck 
%             end            
       