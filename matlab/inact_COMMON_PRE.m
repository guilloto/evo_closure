% Fichier pour définir des conitions particulières à une ou pls transitions

%by Oceane Guillot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

% Un pre_process pour chaque transition si elles n'ont pas les memes
% conditions
% attention si la transition s'appelle T1, ce fichier doit s'appeler
% T1_pre.m


% example: T1 se lancera seulement s'il y a moins de 2 jetons dans la
% place de sortie E2

% function[fire, transition] = T1_pre(transition)
% 
% n1 = ntokens('E1') ; %nombre de jetons/marques dans E1
% n2 = ntokens('E2') ; %nombre de jetons dans E2
% fire = and(lt(n1,n2),lt(n1,2) ;


%% Les processus utilisant substrats codés en variables externes %%
% function [fire, transition] = COMMON_PRE(transition) % transition: str with enabled transitions.
% switch transition.name
%     % Cloture initiale
%     case 'T11'
%         granted = requestSR({'S1',1}) ; %requestSR: spcific %GR:   %AR: 
%     case 'T12'
%         granted = requestSR({'S2',1}) ;
% 
%     % Variant
% %         granted = requestSR({'S2',1}) ;
% %     case 'T21'
% %         granted = requestSR({'S1',1}) ;
% %     case 'T22'
% %         granted = requestSR({'S2',1}) ;
% %     case 'V1'
% %         granted = 1 ; %ne fait rien
% %     case 'V2'
% %         granted = 1 ;
% end
% fire = granted ; %fire only if resources acquisition was successful (granted=1)
       
%% 
function [fire, transition] = COMMON_PRE(transition)
cloture = is_enabled("T11")& is_enabled("T12") ; %cloture principale
            

%a changer, utiliser chaine de caractere
